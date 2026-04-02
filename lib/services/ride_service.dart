import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import '../models/ride_model.dart';
import 'supabase_service.dart';

class RideService {
  /// Search rides based on criteria
  static Future<List<RideModel>> searchRides({
    required String from,
    required String to,
    double? fromLat,
    double? fromLng,
    double? toLat,
    double? toLng,
    required DateTime date,
    int? maxResults,
  }) async {
    try {
      final now = DateTime.now();
      final startOfSearchDay = DateTime(date.year, date.month, date.day);
      
      // If searching for today, start from 'now + 5 mins' (booking gap)
      // If searching for future date, start from beginning of that day
      final bookingGap = now.add(const Duration(minutes: 5));
      final effectiveStart = startOfSearchDay.isBefore(now) ? bookingGap : startOfSearchDay;
      final endOfDay = startOfSearchDay.add(const Duration(days: 1));

      // 1. Fetch all active rides for the specific day
      // We filter by date first to reduce data transferred
      var query = SupabaseService.client
          .from('rides')
          .select()
          .eq('status', 'active')
          .gte('departure_datetime', effectiveStart.toIso8601String())
          .lt('departure_datetime', endOfDay.toIso8601String());

      final response = await query;
      
      // 2. Robust parsing: If one ride fails to parse, others should still show
      final List<RideModel> allRides = [];
      for (final json in (response as List)) {
        try {
          allRides.add(RideModel.fromJson(json));
        } catch (e) {
          debugPrint('Error parsing ride JSON: $e');
          // In development, you might want to see the JSON
          debugPrint('Malformed JSON: $json');
        }
      }

      // If no coordinates are provided, we fallback to simple string matching (case-insensitive)
      if (fromLat == null || fromLng == null || toLat == null || toLng == null) {
        final searchFrom = from.toLowerCase();
        final searchTo = to.toLowerCase();
        
        return allRides.where((ride) {
          final rideStr = '${ride.fromLocation} ${ride.toLocation} ${ride.description ?? ''} ${ride.vehicleInfo ?? ''}'.toLowerCase();
          return rideStr.contains(searchFrom) && rideStr.contains(searchTo);
        }).toList();
      }

      // 2. Filter rides based on coordinates (Proximity & Waypoints)
      final List<RideModel> matchingRides = [];
      for (final ride in allRides) {
        final result = calculateRideSegment(
          ride: ride,
          searchFromLat: fromLat,
          searchFromLng: fromLng,
          searchToLat: toLat,
          searchToLng: toLng,
        );

        if (result != null) {
          matchingRides.add(result);
        }
      }

      // Sort by departure time
      matchingRides.sort((a, b) => a.departureDatetime.compareTo(b.departureDatetime));
      
      return matchingRides.take(maxResults ?? 50).toList();
    } catch (e) {
      if (e.toString().contains('PostgrestException')) {
        throw Exception(e.toString().split('message: ').last.split(',').first);
      }
      throw Exception('Search error: $e');
    }
  }

  /// Helper to calculate pro-rata price and verify if a ride matches search coordinates
  static RideModel? calculateRideSegment({
    required RideModel ride,
    required double searchFromLat,
    required double searchFromLng,
    required double searchToLat,
    required double searchToLng,
  }) {
    final ridePoints = <LatLng>[];
    // Add start and end points
    if (ride.fromLat != null && ride.fromLng != null) {
      ridePoints.add(LatLng(ride.fromLat!, ride.fromLng!));
    }
    
    // Add intermediate points if available
    if (ride.routePointsJson != null) {
      for (final p in ride.routePointsJson!) {
        ridePoints.add(LatLng((p['lat'] as num).toDouble(), (p['lng'] as num).toDouble()));
      }
    }
    
    if (ride.toLat != null && ride.toLng != null) {
      ridePoints.add(LatLng(ride.toLat!, ride.toLng!));
    }

    if (ridePoints.isEmpty) return null;

    const distanceThreshold = 80000.0; // 80km radius for broad district matching
    const distance = Distance();

    // Find if any point on ride is near search 'from'
    int startIndex = -1;
    double minStartDist = double.infinity;
    for (int i = 0; i < ridePoints.length; i++) {
      final d = distance.as(LengthUnit.Meter, LatLng(searchFromLat, searchFromLng), ridePoints[i]);
      if (d < distanceThreshold && d < minStartDist) {
        minStartDist = d.toDouble();
        startIndex = i;
      }
    }

    if (startIndex == -1) return null;

    // Find if any point AFTER startIndex is near search 'to'
    int endIndex = -1;
    double minEndDist = double.infinity;
    for (int i = startIndex; i < ridePoints.length; i++) {
      final d = distance.as(LengthUnit.Meter, LatLng(searchToLat, searchToLng), ridePoints[i]);
      if (d < distanceThreshold && d < minEndDist) {
        minEndDist = d.toDouble();
        endIndex = i;
      }
    }

    if (endIndex != -1) {
      // Calculate segment distance (how much the user is actually traveling)
      double segmentDistance = 0;
      for (int i = startIndex; i < endIndex; i++) {
        segmentDistance += distance.as(LengthUnit.Meter, ridePoints[i], ridePoints[i + 1]);
      }

      // Total distance of the full ride
      double totalRideDistance = (ride.distanceKm ?? 0) * 1000;
      if (totalRideDistance <= 0) {
        for (int i = 0; i < ridePoints.length - 1; i++) {
          totalRideDistance += distance.as(LengthUnit.Meter, ridePoints[i], ridePoints[i + 1]);
        }
      }

      double segmentPrice = ride.pricePerSeat;
      int? segmentDuration = ride.durationMins;

      if (totalRideDistance > 0) {
        // Price proportional to the distance traveled
        segmentPrice = (ride.pricePerSeat / totalRideDistance) * segmentDistance;
        // Round to nearest 10 for clean fares
        segmentPrice = (segmentPrice / 10).round() * 10.0;
        // Ensure it's not more than full price
        if (segmentPrice > ride.pricePerSeat) segmentPrice = ride.pricePerSeat;
        // Minimum price check (Service charge + basic fuel)
        if (segmentPrice < 30) segmentPrice = 30; 

        // Approximate duration
        if (ride.durationMins != null) {
          segmentDuration = ((segmentDistance / totalRideDistance) * ride.durationMins!).round();
          if (segmentDuration < 5) segmentDuration = 5; // Minimum 5 mins
        }
      }

      return ride.copyWith(
        segmentPrice: segmentPrice,
        distanceKm: segmentDistance / 1000, 
        durationMins: segmentDuration,
      );
    }
    return null;
  }

  /// Record a failed search to notify the user later when a ride is published
  static Future<void> recordRideSearch({
    required String userId,
    required String from,
    required String to,
    double? fromLat,
    double? fromLng,
    double? toLat,
    double? toLng,
  }) async {
    try {
      await SupabaseService.client.from('ride_searches').insert({
        'user_id': userId,
        'from_location': from,
        'to_location': to,
        'from_lat': fromLat,
        'from_lng': fromLng,
        'to_lat': toLat,
        'to_lng': toLng,
        'search_date': DateTime.now().toIso8601String().split('T')[0],
      });
    } catch (e) {
      // Silently fail as this is a background optimization
      debugPrint('Failed to record search: $e');
    }
  }

  /// Publish a new ride
  static Future<RideModel> publishRide({
    required String driverId,
    required String driverName,
    required String fromLocation,
    required String toLocation,
    double? fromLat,
    double? fromLng,
    double? toLat,
    double? toLng,
    required DateTime departureDatetime,
    required int totalSeats,
    required double pricePerSeat,
    String? vehicleInfo,
    String? vehicleType,
    String? description,
    List<LatLng>? routePoints,
    double? distanceKm,
    int? durationMins,
    bool ruleNoSmoking = false,
    bool ruleNoMusic = false,
    bool ruleNoHeavyLuggage = false,
    bool ruleNoPets = false,
    bool ruleNegotiation = false,
  }) async {
    try {
      final rideData = {
        'driver_id': driverId,
        'driver_name': driverName,
        'from_location': fromLocation,
        'to_location': toLocation,
        'from_lat': fromLat,
        'from_lng': fromLng,
        'to_lat': toLat,
        'to_lng': toLng,
        'departure_datetime': departureDatetime.toIso8601String(),
        'available_seats': totalSeats,
        'total_seats': totalSeats,
        'price_per_seat': pricePerSeat,
        'vehicle_info': vehicleInfo,
        'vehicle_type': vehicleType,
        'description': description,
        'route_points': routePoints?.map((p) => {'lat': p.latitude, 'lng': p.longitude}).toList(),
        'distance_km': distanceKm,
        'duration_mins': durationMins,
        'rule_no_smoking': ruleNoSmoking,
        'rule_no_music': ruleNoMusic,
        'rule_no_heavy_luggage': ruleNoHeavyLuggage,
        'rule_no_pets': ruleNoPets,
        'rule_negotiation': ruleNegotiation,
        'status': 'active',
      };

      final response = await SupabaseService.client
          .from('rides')
          .insert(rideData)
          .select()
          .single();

      return RideModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to publish ride: $e');
    }
  }

  /// Get rides published by a driver
  static Future<List<RideModel>> getMyPublishedRides({
    required String driverId,
  }) async {
    try {
      final response = await SupabaseService.client
          .from('rides')
          .select()
          .eq('driver_id', driverId)
          .order('departure_datetime', ascending: false);

      return response.map((json) => RideModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get published rides: $e');
    }
  }

  /// Cancel a ride
  static Future<void> cancelRide({
    required String rideId,
    required String driverId,
    String? reason,
  }) async {
    try {
      final response = await SupabaseService.client.rpc('cancel_full_ride', params: {
        'p_ride_id': rideId,
        'p_driver_id': driverId,
        'p_reason': reason,
      });

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Cancellation failed');
      }
    } catch (e) {
      throw Exception('Failed to cancel ride: $e');
    }
  }

  /// Start a ride (Mark as ongoing manually or via GPS)
  static Future<void> startRide({
    required String rideId,
    required String driverId,
  }) async {
    try {
      await SupabaseService.client
          .from('rides')
          .update({
            'status': 'ongoing',
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', rideId)
          .eq('driver_id', driverId);
    } catch (e) {
      throw Exception('Failed to start ride: $e');
    }
  }

  /// Get ride by ID
  static Future<RideModel?> getRideById({
    required String rideId,
  }) async {
    try {
      final response = await SupabaseService.client
          .from('rides')
          .select()
          .eq('id', rideId)
          .maybeSingle();

      return response != null ? RideModel.fromJson(response) : null;
    } catch (e) {
      throw Exception('Failed to get ride: $e');
    }
  }

  /// Get recent rides near location
  static Future<List<RideModel>> getRecentRidesNearMe({
    required double lat,
    required double lng,
    double radiusKm = 10,
    int limit = 10,
  }) async {
    try {
      final response = await SupabaseService.client
          .from('rides')
          .select()
          .eq('status', 'active')
          .gte('departure_datetime', DateTime.now().toIso8601String())
          .order('created_at', ascending: false)
          .limit(limit);

      return response.map((json) => RideModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get nearby rides: $e');
    }
  }

  /// Update ride details
  static Future<void> updateRide({
    required String rideId,
    required String driverId,
    required Map<String, dynamic> updates,
  }) async {
    try {
      await SupabaseService.client
          .from('rides')
          .update(updates)
          .eq('id', rideId)
          .eq('driver_id', driverId);
    } catch (e) {
      throw Exception('Failed to update ride: $e');
    }
  }
}
