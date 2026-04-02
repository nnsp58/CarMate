import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_model.freezed.dart';
part 'booking_model.g.dart';

@freezed
class BookingModel with _$BookingModel {
  const factory BookingModel({
    required String id,
    required String rideId,
    required String passengerId,
    required String driverId,
    required String passengerName,
    String? passengerPhone,
    String? fromLocation,
    String? toLocation,
    double? fromLat,
    double? fromLng,
    double? toLat,
    double? toLng,
    @Default(1) int seatsBooked,
    required double totalPrice,
    @Default('confirmed') String status,
    required DateTime bookedAt,
    DateTime? cancelledAt,
    String? cancelReason,
    
    // Virtual fields from join or snapshots
    String? rideFrom,
    String? rideTo,
    DateTime? departureDatetime,
    String? passengerEmail,
    String? passengerBio,
    String? passengerPhotoUrl,
  }) = _BookingModel;

  factory BookingModel.fromJson(Map<String, dynamic> json) =>
      _$BookingModelFromJson(json);

  const BookingModel._();

  bool get isActive => status == 'confirmed';
  bool get isCancelled => status == 'cancelled';
  bool get isCompleted => status == 'completed';

  String get formattedPrice => '₹${totalPrice.toStringAsFixed(0)}';
  String get seatsText => '$seatsBooked seat${seatsBooked > 1 ? 's' : ''}';

  bool get canCancel => isActive;
  bool get canBeCancelledByDriver => isActive;
  bool get canBeCompleted => isActive;

  bool get isInPast => departureDatetime != null && departureDatetime!.isBefore(DateTime.now());

  String get displayFrom => fromLocation ?? rideFrom ?? 'Start';
  String get displayTo => toLocation ?? rideTo ?? 'Destination';
}
