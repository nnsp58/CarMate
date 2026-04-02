// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ride_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RideModelImpl _$$RideModelImplFromJson(Map<String, dynamic> json) =>
    _$RideModelImpl(
      id: json['id'] as String,
      driverId: json['driver_id'] as String,
      driverName: json['driver_name'] as String,
      driverPhotoUrl: json['driver_photo_url'] as String?,
      driverRating: (json['driver_rating'] as num?)?.toDouble() ?? 5.0,
      fromLocation: json['from_location'] as String,
      toLocation: json['to_location'] as String,
      fromLat: (json['from_lat'] as num?)?.toDouble(),
      fromLng: (json['from_lng'] as num?)?.toDouble(),
      toLat: (json['to_lat'] as num?)?.toDouble(),
      toLng: (json['to_lng'] as num?)?.toDouble(),
      departureDatetime: DateTime.parse(json['departure_datetime'] as String),
      availableSeats: (json['available_seats'] as num).toInt(),
      totalSeats: (json['total_seats'] as num).toInt(),
      pricePerSeat: (json['price_per_seat'] as num).toDouble(),
      vehicleInfo: json['vehicle_info'] as String?,
      vehicleType: json['vehicle_type'] as String?,
      description: json['description'] as String?,
      segmentPrice: (json['segment_price'] as num?)?.toDouble(),
      routePointsJson: (json['route_points'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      distanceKm: (json['distance_km'] as num?)?.toDouble(),
      durationMins: (json['duration_mins'] as num?)?.toInt(),
      ruleNoSmoking: json['rule_no_smoking'] as bool? ?? false,
      ruleNoMusic: json['rule_no_music'] as bool? ?? false,
      ruleNoHeavyLuggage: json['rule_no_heavy_luggage'] as bool? ?? false,
      ruleNoPets: json['rule_no_pets'] as bool? ?? false,
      ruleNegotiation: json['rule_negotiation'] as bool? ?? false,
      status: json['status'] as String? ?? 'active',
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$RideModelImplToJson(_$RideModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'driver_id': instance.driverId,
      'driver_name': instance.driverName,
      'driver_photo_url': instance.driverPhotoUrl,
      'driver_rating': instance.driverRating,
      'from_location': instance.fromLocation,
      'to_location': instance.toLocation,
      'from_lat': instance.fromLat,
      'from_lng': instance.fromLng,
      'to_lat': instance.toLat,
      'to_lng': instance.toLng,
      'departure_datetime': instance.departureDatetime.toIso8601String(),
      'available_seats': instance.availableSeats,
      'total_seats': instance.totalSeats,
      'price_per_seat': instance.pricePerSeat,
      'vehicle_info': instance.vehicleInfo,
      'vehicle_type': instance.vehicleType,
      'description': instance.description,
      'segment_price': instance.segmentPrice,
      'route_points': instance.routePointsJson,
      'distance_km': instance.distanceKm,
      'duration_mins': instance.durationMins,
      'rule_no_smoking': instance.ruleNoSmoking,
      'rule_no_music': instance.ruleNoMusic,
      'rule_no_heavy_luggage': instance.ruleNoHeavyLuggage,
      'rule_no_pets': instance.ruleNoPets,
      'rule_negotiation': instance.ruleNegotiation,
      'status': instance.status,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
