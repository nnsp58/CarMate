// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingModelImpl _$$BookingModelImplFromJson(Map<String, dynamic> json) =>
    _$BookingModelImpl(
      id: json['id'] as String,
      rideId: json['ride_id'] as String,
      passengerId: json['passenger_id'] as String,
      driverId: json['driver_id'] as String,
      passengerName: json['passenger_name'] as String,
      passengerPhone: json['passenger_phone'] as String?,
      fromLocation: json['from_location'] as String?,
      toLocation: json['to_location'] as String?,
      fromLat: (json['from_lat'] as num?)?.toDouble(),
      fromLng: (json['from_lng'] as num?)?.toDouble(),
      toLat: (json['to_lat'] as num?)?.toDouble(),
      toLng: (json['to_lng'] as num?)?.toDouble(),
      seatsBooked: (json['seats_booked'] as num?)?.toInt() ?? 1,
      totalPrice: (json['total_price'] as num).toDouble(),
      status: json['status'] as String? ?? 'confirmed',
      bookedAt: DateTime.parse(json['booked_at'] as String),
      cancelledAt: json['cancelled_at'] == null
          ? null
          : DateTime.parse(json['cancelled_at'] as String),
      cancelReason: json['cancel_reason'] as String?,
      rideFrom: json['ride_from'] as String?,
      rideTo: json['ride_to'] as String?,
      departureDatetime: json['departure_datetime'] == null
          ? null
          : DateTime.parse(json['departure_datetime'] as String),
      passengerEmail: json['passenger_email'] as String?,
      passengerBio: json['passenger_bio'] as String?,
      passengerPhotoUrl: json['passenger_photo_url'] as String?,
    );

Map<String, dynamic> _$$BookingModelImplToJson(_$BookingModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ride_id': instance.rideId,
      'passenger_id': instance.passengerId,
      'driver_id': instance.driverId,
      'passenger_name': instance.passengerName,
      'passenger_phone': instance.passengerPhone,
      'from_location': instance.fromLocation,
      'to_location': instance.toLocation,
      'from_lat': instance.fromLat,
      'from_lng': instance.fromLng,
      'to_lat': instance.toLat,
      'to_lng': instance.toLng,
      'seats_booked': instance.seatsBooked,
      'total_price': instance.totalPrice,
      'status': instance.status,
      'booked_at': instance.bookedAt.toIso8601String(),
      'cancelled_at': instance.cancelledAt?.toIso8601String(),
      'cancel_reason': instance.cancelReason,
      'ride_from': instance.rideFrom,
      'ride_to': instance.rideTo,
      'departure_datetime': instance.departureDatetime?.toIso8601String(),
      'passenger_email': instance.passengerEmail,
      'passenger_bio': instance.passengerBio,
      'passenger_photo_url': instance.passengerPhotoUrl,
    };
