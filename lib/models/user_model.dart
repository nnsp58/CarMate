import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    String? fullName,
    String? phone,
    String? email,
    String? photoUrl,
    String? bio,
    @Default(5.0) double rating,
    @Default(0) int totalRidesGiven,
    @Default(0) int totalRidesTaken,
    @Default(false) bool isAdmin,
    @Default(false) bool isBanned,
    @Default(false) bool setupComplete,
    String? fcmToken,
    String? drivingExperience,
    String? address,
    required DateTime createdAt,
    required DateTime updatedAt,

    // Vehicle info
    String? vehicleModel,
    String? vehicleLicensePlate,
    String? vehicleColor,
    String? vehicleType,

    // Document verification
    String? docDrivingLicenseFront,
    String? docDrivingLicenseBack,
    String? docVehicleRc,
    @Default('not_submitted') String docVerificationStatus,
    String? docRejectionReason,
    DateTime? docReviewedAt,

    // Security & Identity Proof
    String? idType,
    String? idNumber,
    String? idDocUrl,
    String? addressDocType,
    String? addressDocUrl,

    // Address Details
    String? pincode,
    String? state,
    String? city,
    String? tehsil,

    // Details Without Document Upload
    String? drivingLicenseNumber,
    String? pucNumber,
    String? insuranceNumber,
    // Preferences / Rules (Linked to Publish Ride)
    @Default(false) bool prefNoSmoking,
    @Default(false) bool prefNoMusic,
    @Default(false) bool prefNoHeavyLuggage,
    @Default(false) bool prefNoPets,
    @Default(false) bool prefNegotiation,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  const UserModel._();

  bool get isVerified => docVerificationStatus == 'approved';
  bool get hasVehicle =>
      vehicleModel != null && vehicleModel!.isNotEmpty;
  bool get canPublishRides =>
      setupComplete && isVerified && hasVehicle && !isBanned;

  String get displayName => fullName ?? 'Unknown User';
  String get initials => fullName != null && fullName!.isNotEmpty
      ? fullName!.split(' ').map((e) => e[0]).take(2).join().toUpperCase()
      : 'U';
}
