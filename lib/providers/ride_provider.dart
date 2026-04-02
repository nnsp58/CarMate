import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../models/ride_model.dart';
import '../services/ride_service.dart';
import '../services/map_service.dart';
import 'auth_provider.dart';


// Ride Search Provider
final rideSearchProvider = StateNotifierProvider<RideSearchNotifier, AsyncValue<List<RideModel>>>((ref) {
  return RideSearchNotifier();
});

class RideSearchNotifier extends StateNotifier<AsyncValue<List<RideModel>>> {
  RideSearchNotifier() : super(const AsyncValue.data([]));

  Future<void> search({
    required String from,
    required String to,
    double? fromLat,
    double? fromLng,
    double? toLat,
    double? toLng,
    required DateTime date,
    String? userId,
    int? maxResults,
  }) async {
    state = const AsyncValue.loading();
    try {
      final rides = await RideService.searchRides(
        from: from,
        to: to,
        fromLat: fromLat,
        fromLng: fromLng,
        toLat: toLat,
        toLng: toLng,
        date: date,
        maxResults: maxResults,
      );

      if (rides.isEmpty && userId != null) {
        RideService.recordRideSearch(
          userId: userId,
          from: from,
          to: to,
          fromLat: fromLat,
          fromLng: fromLng,
          toLat: toLat,
          toLng: toLng,
        ).catchError((e) => debugPrint('Background record search failed: $e'));
      }

      state = AsyncValue.data(rides);
    } catch (e, stack) {
      debugPrint('RideSearchNotifier: Search failed: $e');
      state = AsyncValue.error(e, stack);
    }
  }

  void clear() {
    state = const AsyncValue.data([]);
  }
}

// My Published Rides Provider
final myPublishedRidesProvider = FutureProvider<List<RideModel>>((ref) async {
  final currentUser = ref.watch(currentUserProvider);
  return currentUser.maybeWhen(
    data: (user) async {
      if (user != null) {
        return await RideService.getMyPublishedRides(driverId: user.id);
      }
      return [];
    },
    orElse: () => [],
  );
});

// Publish Ride Provider
final publishRideProvider = StateNotifierProvider<PublishRideNotifier, AsyncValue<void>>((ref) {
  return PublishRideNotifier(ref);
});

class PublishRideNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;
  PublishRideNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<void> publish(RideModel ride) async {
    state = const AsyncValue.loading();
    try {
      await RideService.publishRide(
        driverId: ride.driverId,
        driverName: ride.driverName,
        fromLocation: ride.fromLocation,
        toLocation: ride.toLocation,
        fromLat: ride.fromLat,
        fromLng: ride.fromLng,
        toLat: ride.toLat,
        toLng: ride.toLng,
        departureDatetime: ride.departureDatetime,
        totalSeats: ride.totalSeats,
        pricePerSeat: ride.pricePerSeat,
        vehicleInfo: ride.vehicleInfo,
        vehicleType: ride.vehicleType,
        description: ride.description,
        routePoints: ride.routePointsJson
            ?.map((p) => LatLng(
                (p['lat'] as num).toDouble(), (p['lng'] as num).toDouble()))
            .toList(),
        distanceKm: ride.distanceKm,
        durationMins: ride.durationMins,
        ruleNoSmoking: ride.ruleNoSmoking,
        ruleNoMusic: ride.ruleNoMusic,
        ruleNoHeavyLuggage: ride.ruleNoHeavyLuggage,
        ruleNoPets: ride.ruleNoPets,
        ruleNegotiation: ride.ruleNegotiation,
      );
      _ref.invalidate(myPublishedRidesProvider);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

// Ride Details Provider
final rideDetailsProvider = FutureProvider.family<RideModel?, String>((ref, rideId) async {
  return await RideService.getRideById(rideId: rideId);
});

// ✅ FIX: nearbyRidesProvider — ab actual GPS location se rides fetch karta hai.
// Pehle sirf empty list return hoti thi (TODO comment tha).
// Ab:
//  1. GPS permission check hoti hai
//  2. Current position liya jaata hai
//  3. Aaj ke active rides fetch hoti hain
//  4. 50km radius mein jo rides hain unhe filter karke return kiya jaata hai
final nearbyRidesProvider = FutureProvider<List<RideModel>>((ref) async {
  try {
    // Step 1: Location permission check
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('nearbyRidesProvider: Location service disabled');
      return [];
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        debugPrint('nearbyRidesProvider: Location permission denied');
        return [];
      }
    }

    // Step 2: Current position lo (5 second timeout)
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
      ),
    ).timeout(
      const Duration(seconds: 5),
      onTimeout: () => throw Exception('Location timeout'),
    );

    // Step 3: City name fetch karo (MapService reverse geocode se)
    final cityName = await MapService.getCityFromLatLng(
      position.latitude,
      position.longitude,
    );

    // Step 4: Aaj ke active rides fetch karo us city ke aas-paas
    final rides = await RideService.searchRides(
      from: cityName == 'Unknown' ? '' : cityName,
      to: '',
      fromLat: position.latitude,
      fromLng: position.longitude,
      toLat: null,
      toLng: null,
      date: DateTime.now(),
      maxResults: 10,
    );

    // Step 5: 50km radius filter
    const distance = Distance();
    final userLocation = LatLng(position.latitude, position.longitude);
    const double radiusMeters = 50000; // 50 km

    final nearby = rides.where((ride) {
      if (ride.fromLat == null || ride.fromLng == null) return false;
      final rideStart = LatLng(ride.fromLat!, ride.fromLng!);
      final distanceM = distance(userLocation, rideStart);
      return distanceM <= radiusMeters;
    }).toList();

    debugPrint('nearbyRidesProvider: ${nearby.length} rides found near $cityName');
    return nearby;
  } catch (e) {
    debugPrint('nearbyRidesProvider error: $e');
    return [];
  }
});
