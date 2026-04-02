// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  String get id => throw _privateConstructorUsedError;
  String? get fullName => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get photoUrl => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  int get totalRidesGiven => throw _privateConstructorUsedError;
  int get totalRidesTaken => throw _privateConstructorUsedError;
  bool get isAdmin => throw _privateConstructorUsedError;
  bool get isBanned => throw _privateConstructorUsedError;
  bool get setupComplete => throw _privateConstructorUsedError;
  String? get fcmToken => throw _privateConstructorUsedError;
  String? get drivingExperience => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError; // Vehicle info
  String? get vehicleModel => throw _privateConstructorUsedError;
  String? get vehicleLicensePlate => throw _privateConstructorUsedError;
  String? get vehicleColor => throw _privateConstructorUsedError;
  String? get vehicleType =>
      throw _privateConstructorUsedError; // Document verification
  String? get docDrivingLicenseFront => throw _privateConstructorUsedError;
  String? get docDrivingLicenseBack => throw _privateConstructorUsedError;
  String? get docVehicleRc => throw _privateConstructorUsedError;
  String get docVerificationStatus => throw _privateConstructorUsedError;
  String? get docRejectionReason => throw _privateConstructorUsedError;
  DateTime? get docReviewedAt =>
      throw _privateConstructorUsedError; // Security & Identity Proof
  String? get idType => throw _privateConstructorUsedError;
  String? get idNumber => throw _privateConstructorUsedError;
  String? get idDocUrl => throw _privateConstructorUsedError;
  String? get addressDocType => throw _privateConstructorUsedError;
  String? get addressDocUrl =>
      throw _privateConstructorUsedError; // Address Details
  String? get pincode => throw _privateConstructorUsedError;
  String? get state => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get tehsil =>
      throw _privateConstructorUsedError; // Details Without Document Upload
  String? get drivingLicenseNumber => throw _privateConstructorUsedError;
  String? get pucNumber => throw _privateConstructorUsedError;
  String? get insuranceNumber =>
      throw _privateConstructorUsedError; // Preferences / Rules (Linked to Publish Ride)
  bool get prefNoSmoking => throw _privateConstructorUsedError;
  bool get prefNoMusic => throw _privateConstructorUsedError;
  bool get prefNoHeavyLuggage => throw _privateConstructorUsedError;
  bool get prefNoPets => throw _privateConstructorUsedError;
  bool get prefNegotiation => throw _privateConstructorUsedError;

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call(
      {String id,
      String? fullName,
      String? phone,
      String? email,
      String? photoUrl,
      String? bio,
      double rating,
      int totalRidesGiven,
      int totalRidesTaken,
      bool isAdmin,
      bool isBanned,
      bool setupComplete,
      String? fcmToken,
      String? drivingExperience,
      String? address,
      DateTime createdAt,
      DateTime updatedAt,
      String? vehicleModel,
      String? vehicleLicensePlate,
      String? vehicleColor,
      String? vehicleType,
      String? docDrivingLicenseFront,
      String? docDrivingLicenseBack,
      String? docVehicleRc,
      String docVerificationStatus,
      String? docRejectionReason,
      DateTime? docReviewedAt,
      String? idType,
      String? idNumber,
      String? idDocUrl,
      String? addressDocType,
      String? addressDocUrl,
      String? pincode,
      String? state,
      String? city,
      String? tehsil,
      String? drivingLicenseNumber,
      String? pucNumber,
      String? insuranceNumber,
      bool prefNoSmoking,
      bool prefNoMusic,
      bool prefNoHeavyLuggage,
      bool prefNoPets,
      bool prefNegotiation});
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = freezed,
    Object? phone = freezed,
    Object? email = freezed,
    Object? photoUrl = freezed,
    Object? bio = freezed,
    Object? rating = null,
    Object? totalRidesGiven = null,
    Object? totalRidesTaken = null,
    Object? isAdmin = null,
    Object? isBanned = null,
    Object? setupComplete = null,
    Object? fcmToken = freezed,
    Object? drivingExperience = freezed,
    Object? address = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? vehicleModel = freezed,
    Object? vehicleLicensePlate = freezed,
    Object? vehicleColor = freezed,
    Object? vehicleType = freezed,
    Object? docDrivingLicenseFront = freezed,
    Object? docDrivingLicenseBack = freezed,
    Object? docVehicleRc = freezed,
    Object? docVerificationStatus = null,
    Object? docRejectionReason = freezed,
    Object? docReviewedAt = freezed,
    Object? idType = freezed,
    Object? idNumber = freezed,
    Object? idDocUrl = freezed,
    Object? addressDocType = freezed,
    Object? addressDocUrl = freezed,
    Object? pincode = freezed,
    Object? state = freezed,
    Object? city = freezed,
    Object? tehsil = freezed,
    Object? drivingLicenseNumber = freezed,
    Object? pucNumber = freezed,
    Object? insuranceNumber = freezed,
    Object? prefNoSmoking = null,
    Object? prefNoMusic = null,
    Object? prefNoHeavyLuggage = null,
    Object? prefNoPets = null,
    Object? prefNegotiation = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      totalRidesGiven: null == totalRidesGiven
          ? _value.totalRidesGiven
          : totalRidesGiven // ignore: cast_nullable_to_non_nullable
              as int,
      totalRidesTaken: null == totalRidesTaken
          ? _value.totalRidesTaken
          : totalRidesTaken // ignore: cast_nullable_to_non_nullable
              as int,
      isAdmin: null == isAdmin
          ? _value.isAdmin
          : isAdmin // ignore: cast_nullable_to_non_nullable
              as bool,
      isBanned: null == isBanned
          ? _value.isBanned
          : isBanned // ignore: cast_nullable_to_non_nullable
              as bool,
      setupComplete: null == setupComplete
          ? _value.setupComplete
          : setupComplete // ignore: cast_nullable_to_non_nullable
              as bool,
      fcmToken: freezed == fcmToken
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String?,
      drivingExperience: freezed == drivingExperience
          ? _value.drivingExperience
          : drivingExperience // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      vehicleModel: freezed == vehicleModel
          ? _value.vehicleModel
          : vehicleModel // ignore: cast_nullable_to_non_nullable
              as String?,
      vehicleLicensePlate: freezed == vehicleLicensePlate
          ? _value.vehicleLicensePlate
          : vehicleLicensePlate // ignore: cast_nullable_to_non_nullable
              as String?,
      vehicleColor: freezed == vehicleColor
          ? _value.vehicleColor
          : vehicleColor // ignore: cast_nullable_to_non_nullable
              as String?,
      vehicleType: freezed == vehicleType
          ? _value.vehicleType
          : vehicleType // ignore: cast_nullable_to_non_nullable
              as String?,
      docDrivingLicenseFront: freezed == docDrivingLicenseFront
          ? _value.docDrivingLicenseFront
          : docDrivingLicenseFront // ignore: cast_nullable_to_non_nullable
              as String?,
      docDrivingLicenseBack: freezed == docDrivingLicenseBack
          ? _value.docDrivingLicenseBack
          : docDrivingLicenseBack // ignore: cast_nullable_to_non_nullable
              as String?,
      docVehicleRc: freezed == docVehicleRc
          ? _value.docVehicleRc
          : docVehicleRc // ignore: cast_nullable_to_non_nullable
              as String?,
      docVerificationStatus: null == docVerificationStatus
          ? _value.docVerificationStatus
          : docVerificationStatus // ignore: cast_nullable_to_non_nullable
              as String,
      docRejectionReason: freezed == docRejectionReason
          ? _value.docRejectionReason
          : docRejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      docReviewedAt: freezed == docReviewedAt
          ? _value.docReviewedAt
          : docReviewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      idType: freezed == idType
          ? _value.idType
          : idType // ignore: cast_nullable_to_non_nullable
              as String?,
      idNumber: freezed == idNumber
          ? _value.idNumber
          : idNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      idDocUrl: freezed == idDocUrl
          ? _value.idDocUrl
          : idDocUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      addressDocType: freezed == addressDocType
          ? _value.addressDocType
          : addressDocType // ignore: cast_nullable_to_non_nullable
              as String?,
      addressDocUrl: freezed == addressDocUrl
          ? _value.addressDocUrl
          : addressDocUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      pincode: freezed == pincode
          ? _value.pincode
          : pincode // ignore: cast_nullable_to_non_nullable
              as String?,
      state: freezed == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      tehsil: freezed == tehsil
          ? _value.tehsil
          : tehsil // ignore: cast_nullable_to_non_nullable
              as String?,
      drivingLicenseNumber: freezed == drivingLicenseNumber
          ? _value.drivingLicenseNumber
          : drivingLicenseNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      pucNumber: freezed == pucNumber
          ? _value.pucNumber
          : pucNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      insuranceNumber: freezed == insuranceNumber
          ? _value.insuranceNumber
          : insuranceNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      prefNoSmoking: null == prefNoSmoking
          ? _value.prefNoSmoking
          : prefNoSmoking // ignore: cast_nullable_to_non_nullable
              as bool,
      prefNoMusic: null == prefNoMusic
          ? _value.prefNoMusic
          : prefNoMusic // ignore: cast_nullable_to_non_nullable
              as bool,
      prefNoHeavyLuggage: null == prefNoHeavyLuggage
          ? _value.prefNoHeavyLuggage
          : prefNoHeavyLuggage // ignore: cast_nullable_to_non_nullable
              as bool,
      prefNoPets: null == prefNoPets
          ? _value.prefNoPets
          : prefNoPets // ignore: cast_nullable_to_non_nullable
              as bool,
      prefNegotiation: null == prefNegotiation
          ? _value.prefNegotiation
          : prefNegotiation // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
          _$UserModelImpl value, $Res Function(_$UserModelImpl) then) =
      __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String? fullName,
      String? phone,
      String? email,
      String? photoUrl,
      String? bio,
      double rating,
      int totalRidesGiven,
      int totalRidesTaken,
      bool isAdmin,
      bool isBanned,
      bool setupComplete,
      String? fcmToken,
      String? drivingExperience,
      String? address,
      DateTime createdAt,
      DateTime updatedAt,
      String? vehicleModel,
      String? vehicleLicensePlate,
      String? vehicleColor,
      String? vehicleType,
      String? docDrivingLicenseFront,
      String? docDrivingLicenseBack,
      String? docVehicleRc,
      String docVerificationStatus,
      String? docRejectionReason,
      DateTime? docReviewedAt,
      String? idType,
      String? idNumber,
      String? idDocUrl,
      String? addressDocType,
      String? addressDocUrl,
      String? pincode,
      String? state,
      String? city,
      String? tehsil,
      String? drivingLicenseNumber,
      String? pucNumber,
      String? insuranceNumber,
      bool prefNoSmoking,
      bool prefNoMusic,
      bool prefNoHeavyLuggage,
      bool prefNoPets,
      bool prefNegotiation});
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
      _$UserModelImpl _value, $Res Function(_$UserModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = freezed,
    Object? phone = freezed,
    Object? email = freezed,
    Object? photoUrl = freezed,
    Object? bio = freezed,
    Object? rating = null,
    Object? totalRidesGiven = null,
    Object? totalRidesTaken = null,
    Object? isAdmin = null,
    Object? isBanned = null,
    Object? setupComplete = null,
    Object? fcmToken = freezed,
    Object? drivingExperience = freezed,
    Object? address = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? vehicleModel = freezed,
    Object? vehicleLicensePlate = freezed,
    Object? vehicleColor = freezed,
    Object? vehicleType = freezed,
    Object? docDrivingLicenseFront = freezed,
    Object? docDrivingLicenseBack = freezed,
    Object? docVehicleRc = freezed,
    Object? docVerificationStatus = null,
    Object? docRejectionReason = freezed,
    Object? docReviewedAt = freezed,
    Object? idType = freezed,
    Object? idNumber = freezed,
    Object? idDocUrl = freezed,
    Object? addressDocType = freezed,
    Object? addressDocUrl = freezed,
    Object? pincode = freezed,
    Object? state = freezed,
    Object? city = freezed,
    Object? tehsil = freezed,
    Object? drivingLicenseNumber = freezed,
    Object? pucNumber = freezed,
    Object? insuranceNumber = freezed,
    Object? prefNoSmoking = null,
    Object? prefNoMusic = null,
    Object? prefNoHeavyLuggage = null,
    Object? prefNoPets = null,
    Object? prefNegotiation = null,
  }) {
    return _then(_$UserModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      totalRidesGiven: null == totalRidesGiven
          ? _value.totalRidesGiven
          : totalRidesGiven // ignore: cast_nullable_to_non_nullable
              as int,
      totalRidesTaken: null == totalRidesTaken
          ? _value.totalRidesTaken
          : totalRidesTaken // ignore: cast_nullable_to_non_nullable
              as int,
      isAdmin: null == isAdmin
          ? _value.isAdmin
          : isAdmin // ignore: cast_nullable_to_non_nullable
              as bool,
      isBanned: null == isBanned
          ? _value.isBanned
          : isBanned // ignore: cast_nullable_to_non_nullable
              as bool,
      setupComplete: null == setupComplete
          ? _value.setupComplete
          : setupComplete // ignore: cast_nullable_to_non_nullable
              as bool,
      fcmToken: freezed == fcmToken
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String?,
      drivingExperience: freezed == drivingExperience
          ? _value.drivingExperience
          : drivingExperience // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      vehicleModel: freezed == vehicleModel
          ? _value.vehicleModel
          : vehicleModel // ignore: cast_nullable_to_non_nullable
              as String?,
      vehicleLicensePlate: freezed == vehicleLicensePlate
          ? _value.vehicleLicensePlate
          : vehicleLicensePlate // ignore: cast_nullable_to_non_nullable
              as String?,
      vehicleColor: freezed == vehicleColor
          ? _value.vehicleColor
          : vehicleColor // ignore: cast_nullable_to_non_nullable
              as String?,
      vehicleType: freezed == vehicleType
          ? _value.vehicleType
          : vehicleType // ignore: cast_nullable_to_non_nullable
              as String?,
      docDrivingLicenseFront: freezed == docDrivingLicenseFront
          ? _value.docDrivingLicenseFront
          : docDrivingLicenseFront // ignore: cast_nullable_to_non_nullable
              as String?,
      docDrivingLicenseBack: freezed == docDrivingLicenseBack
          ? _value.docDrivingLicenseBack
          : docDrivingLicenseBack // ignore: cast_nullable_to_non_nullable
              as String?,
      docVehicleRc: freezed == docVehicleRc
          ? _value.docVehicleRc
          : docVehicleRc // ignore: cast_nullable_to_non_nullable
              as String?,
      docVerificationStatus: null == docVerificationStatus
          ? _value.docVerificationStatus
          : docVerificationStatus // ignore: cast_nullable_to_non_nullable
              as String,
      docRejectionReason: freezed == docRejectionReason
          ? _value.docRejectionReason
          : docRejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      docReviewedAt: freezed == docReviewedAt
          ? _value.docReviewedAt
          : docReviewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      idType: freezed == idType
          ? _value.idType
          : idType // ignore: cast_nullable_to_non_nullable
              as String?,
      idNumber: freezed == idNumber
          ? _value.idNumber
          : idNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      idDocUrl: freezed == idDocUrl
          ? _value.idDocUrl
          : idDocUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      addressDocType: freezed == addressDocType
          ? _value.addressDocType
          : addressDocType // ignore: cast_nullable_to_non_nullable
              as String?,
      addressDocUrl: freezed == addressDocUrl
          ? _value.addressDocUrl
          : addressDocUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      pincode: freezed == pincode
          ? _value.pincode
          : pincode // ignore: cast_nullable_to_non_nullable
              as String?,
      state: freezed == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      tehsil: freezed == tehsil
          ? _value.tehsil
          : tehsil // ignore: cast_nullable_to_non_nullable
              as String?,
      drivingLicenseNumber: freezed == drivingLicenseNumber
          ? _value.drivingLicenseNumber
          : drivingLicenseNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      pucNumber: freezed == pucNumber
          ? _value.pucNumber
          : pucNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      insuranceNumber: freezed == insuranceNumber
          ? _value.insuranceNumber
          : insuranceNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      prefNoSmoking: null == prefNoSmoking
          ? _value.prefNoSmoking
          : prefNoSmoking // ignore: cast_nullable_to_non_nullable
              as bool,
      prefNoMusic: null == prefNoMusic
          ? _value.prefNoMusic
          : prefNoMusic // ignore: cast_nullable_to_non_nullable
              as bool,
      prefNoHeavyLuggage: null == prefNoHeavyLuggage
          ? _value.prefNoHeavyLuggage
          : prefNoHeavyLuggage // ignore: cast_nullable_to_non_nullable
              as bool,
      prefNoPets: null == prefNoPets
          ? _value.prefNoPets
          : prefNoPets // ignore: cast_nullable_to_non_nullable
              as bool,
      prefNegotiation: null == prefNegotiation
          ? _value.prefNegotiation
          : prefNegotiation // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl extends _UserModel {
  const _$UserModelImpl(
      {required this.id,
      this.fullName,
      this.phone,
      this.email,
      this.photoUrl,
      this.bio,
      this.rating = 5.0,
      this.totalRidesGiven = 0,
      this.totalRidesTaken = 0,
      this.isAdmin = false,
      this.isBanned = false,
      this.setupComplete = false,
      this.fcmToken,
      this.drivingExperience,
      this.address,
      required this.createdAt,
      required this.updatedAt,
      this.vehicleModel,
      this.vehicleLicensePlate,
      this.vehicleColor,
      this.vehicleType,
      this.docDrivingLicenseFront,
      this.docDrivingLicenseBack,
      this.docVehicleRc,
      this.docVerificationStatus = 'not_submitted',
      this.docRejectionReason,
      this.docReviewedAt,
      this.idType,
      this.idNumber,
      this.idDocUrl,
      this.addressDocType,
      this.addressDocUrl,
      this.pincode,
      this.state,
      this.city,
      this.tehsil,
      this.drivingLicenseNumber,
      this.pucNumber,
      this.insuranceNumber,
      this.prefNoSmoking = false,
      this.prefNoMusic = false,
      this.prefNoHeavyLuggage = false,
      this.prefNoPets = false,
      this.prefNegotiation = false})
      : super._();

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  final String id;
  @override
  final String? fullName;
  @override
  final String? phone;
  @override
  final String? email;
  @override
  final String? photoUrl;
  @override
  final String? bio;
  @override
  @JsonKey()
  final double rating;
  @override
  @JsonKey()
  final int totalRidesGiven;
  @override
  @JsonKey()
  final int totalRidesTaken;
  @override
  @JsonKey()
  final bool isAdmin;
  @override
  @JsonKey()
  final bool isBanned;
  @override
  @JsonKey()
  final bool setupComplete;
  @override
  final String? fcmToken;
  @override
  final String? drivingExperience;
  @override
  final String? address;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
// Vehicle info
  @override
  final String? vehicleModel;
  @override
  final String? vehicleLicensePlate;
  @override
  final String? vehicleColor;
  @override
  final String? vehicleType;
// Document verification
  @override
  final String? docDrivingLicenseFront;
  @override
  final String? docDrivingLicenseBack;
  @override
  final String? docVehicleRc;
  @override
  @JsonKey()
  final String docVerificationStatus;
  @override
  final String? docRejectionReason;
  @override
  final DateTime? docReviewedAt;
// Security & Identity Proof
  @override
  final String? idType;
  @override
  final String? idNumber;
  @override
  final String? idDocUrl;
  @override
  final String? addressDocType;
  @override
  final String? addressDocUrl;
// Address Details
  @override
  final String? pincode;
  @override
  final String? state;
  @override
  final String? city;
  @override
  final String? tehsil;
// Details Without Document Upload
  @override
  final String? drivingLicenseNumber;
  @override
  final String? pucNumber;
  @override
  final String? insuranceNumber;
// Preferences / Rules (Linked to Publish Ride)
  @override
  @JsonKey()
  final bool prefNoSmoking;
  @override
  @JsonKey()
  final bool prefNoMusic;
  @override
  @JsonKey()
  final bool prefNoHeavyLuggage;
  @override
  @JsonKey()
  final bool prefNoPets;
  @override
  @JsonKey()
  final bool prefNegotiation;

  @override
  String toString() {
    return 'UserModel(id: $id, fullName: $fullName, phone: $phone, email: $email, photoUrl: $photoUrl, bio: $bio, rating: $rating, totalRidesGiven: $totalRidesGiven, totalRidesTaken: $totalRidesTaken, isAdmin: $isAdmin, isBanned: $isBanned, setupComplete: $setupComplete, fcmToken: $fcmToken, drivingExperience: $drivingExperience, address: $address, createdAt: $createdAt, updatedAt: $updatedAt, vehicleModel: $vehicleModel, vehicleLicensePlate: $vehicleLicensePlate, vehicleColor: $vehicleColor, vehicleType: $vehicleType, docDrivingLicenseFront: $docDrivingLicenseFront, docDrivingLicenseBack: $docDrivingLicenseBack, docVehicleRc: $docVehicleRc, docVerificationStatus: $docVerificationStatus, docRejectionReason: $docRejectionReason, docReviewedAt: $docReviewedAt, idType: $idType, idNumber: $idNumber, idDocUrl: $idDocUrl, addressDocType: $addressDocType, addressDocUrl: $addressDocUrl, pincode: $pincode, state: $state, city: $city, tehsil: $tehsil, drivingLicenseNumber: $drivingLicenseNumber, pucNumber: $pucNumber, insuranceNumber: $insuranceNumber, prefNoSmoking: $prefNoSmoking, prefNoMusic: $prefNoMusic, prefNoHeavyLuggage: $prefNoHeavyLuggage, prefNoPets: $prefNoPets, prefNegotiation: $prefNegotiation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.totalRidesGiven, totalRidesGiven) ||
                other.totalRidesGiven == totalRidesGiven) &&
            (identical(other.totalRidesTaken, totalRidesTaken) ||
                other.totalRidesTaken == totalRidesTaken) &&
            (identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin) &&
            (identical(other.isBanned, isBanned) ||
                other.isBanned == isBanned) &&
            (identical(other.setupComplete, setupComplete) ||
                other.setupComplete == setupComplete) &&
            (identical(other.fcmToken, fcmToken) ||
                other.fcmToken == fcmToken) &&
            (identical(other.drivingExperience, drivingExperience) ||
                other.drivingExperience == drivingExperience) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.vehicleModel, vehicleModel) ||
                other.vehicleModel == vehicleModel) &&
            (identical(other.vehicleLicensePlate, vehicleLicensePlate) ||
                other.vehicleLicensePlate == vehicleLicensePlate) &&
            (identical(other.vehicleColor, vehicleColor) ||
                other.vehicleColor == vehicleColor) &&
            (identical(other.vehicleType, vehicleType) ||
                other.vehicleType == vehicleType) &&
            (identical(other.docDrivingLicenseFront, docDrivingLicenseFront) ||
                other.docDrivingLicenseFront == docDrivingLicenseFront) &&
            (identical(other.docDrivingLicenseBack, docDrivingLicenseBack) ||
                other.docDrivingLicenseBack == docDrivingLicenseBack) &&
            (identical(other.docVehicleRc, docVehicleRc) ||
                other.docVehicleRc == docVehicleRc) &&
            (identical(other.docVerificationStatus, docVerificationStatus) ||
                other.docVerificationStatus == docVerificationStatus) &&
            (identical(other.docRejectionReason, docRejectionReason) ||
                other.docRejectionReason == docRejectionReason) &&
            (identical(other.docReviewedAt, docReviewedAt) ||
                other.docReviewedAt == docReviewedAt) &&
            (identical(other.idType, idType) || other.idType == idType) &&
            (identical(other.idNumber, idNumber) ||
                other.idNumber == idNumber) &&
            (identical(other.idDocUrl, idDocUrl) ||
                other.idDocUrl == idDocUrl) &&
            (identical(other.addressDocType, addressDocType) ||
                other.addressDocType == addressDocType) &&
            (identical(other.addressDocUrl, addressDocUrl) ||
                other.addressDocUrl == addressDocUrl) &&
            (identical(other.pincode, pincode) || other.pincode == pincode) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.tehsil, tehsil) || other.tehsil == tehsil) &&
            (identical(other.drivingLicenseNumber, drivingLicenseNumber) ||
                other.drivingLicenseNumber == drivingLicenseNumber) &&
            (identical(other.pucNumber, pucNumber) ||
                other.pucNumber == pucNumber) &&
            (identical(other.insuranceNumber, insuranceNumber) ||
                other.insuranceNumber == insuranceNumber) &&
            (identical(other.prefNoSmoking, prefNoSmoking) ||
                other.prefNoSmoking == prefNoSmoking) &&
            (identical(other.prefNoMusic, prefNoMusic) ||
                other.prefNoMusic == prefNoMusic) &&
            (identical(other.prefNoHeavyLuggage, prefNoHeavyLuggage) ||
                other.prefNoHeavyLuggage == prefNoHeavyLuggage) &&
            (identical(other.prefNoPets, prefNoPets) ||
                other.prefNoPets == prefNoPets) &&
            (identical(other.prefNegotiation, prefNegotiation) ||
                other.prefNegotiation == prefNegotiation));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        fullName,
        phone,
        email,
        photoUrl,
        bio,
        rating,
        totalRidesGiven,
        totalRidesTaken,
        isAdmin,
        isBanned,
        setupComplete,
        fcmToken,
        drivingExperience,
        address,
        createdAt,
        updatedAt,
        vehicleModel,
        vehicleLicensePlate,
        vehicleColor,
        vehicleType,
        docDrivingLicenseFront,
        docDrivingLicenseBack,
        docVehicleRc,
        docVerificationStatus,
        docRejectionReason,
        docReviewedAt,
        idType,
        idNumber,
        idDocUrl,
        addressDocType,
        addressDocUrl,
        pincode,
        state,
        city,
        tehsil,
        drivingLicenseNumber,
        pucNumber,
        insuranceNumber,
        prefNoSmoking,
        prefNoMusic,
        prefNoHeavyLuggage,
        prefNoPets,
        prefNegotiation
      ]);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(
      this,
    );
  }
}

abstract class _UserModel extends UserModel {
  const factory _UserModel(
      {required final String id,
      final String? fullName,
      final String? phone,
      final String? email,
      final String? photoUrl,
      final String? bio,
      final double rating,
      final int totalRidesGiven,
      final int totalRidesTaken,
      final bool isAdmin,
      final bool isBanned,
      final bool setupComplete,
      final String? fcmToken,
      final String? drivingExperience,
      final String? address,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final String? vehicleModel,
      final String? vehicleLicensePlate,
      final String? vehicleColor,
      final String? vehicleType,
      final String? docDrivingLicenseFront,
      final String? docDrivingLicenseBack,
      final String? docVehicleRc,
      final String docVerificationStatus,
      final String? docRejectionReason,
      final DateTime? docReviewedAt,
      final String? idType,
      final String? idNumber,
      final String? idDocUrl,
      final String? addressDocType,
      final String? addressDocUrl,
      final String? pincode,
      final String? state,
      final String? city,
      final String? tehsil,
      final String? drivingLicenseNumber,
      final String? pucNumber,
      final String? insuranceNumber,
      final bool prefNoSmoking,
      final bool prefNoMusic,
      final bool prefNoHeavyLuggage,
      final bool prefNoPets,
      final bool prefNegotiation}) = _$UserModelImpl;
  const _UserModel._() : super._();

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  String get id;
  @override
  String? get fullName;
  @override
  String? get phone;
  @override
  String? get email;
  @override
  String? get photoUrl;
  @override
  String? get bio;
  @override
  double get rating;
  @override
  int get totalRidesGiven;
  @override
  int get totalRidesTaken;
  @override
  bool get isAdmin;
  @override
  bool get isBanned;
  @override
  bool get setupComplete;
  @override
  String? get fcmToken;
  @override
  String? get drivingExperience;
  @override
  String? get address;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt; // Vehicle info
  @override
  String? get vehicleModel;
  @override
  String? get vehicleLicensePlate;
  @override
  String? get vehicleColor;
  @override
  String? get vehicleType; // Document verification
  @override
  String? get docDrivingLicenseFront;
  @override
  String? get docDrivingLicenseBack;
  @override
  String? get docVehicleRc;
  @override
  String get docVerificationStatus;
  @override
  String? get docRejectionReason;
  @override
  DateTime? get docReviewedAt; // Security & Identity Proof
  @override
  String? get idType;
  @override
  String? get idNumber;
  @override
  String? get idDocUrl;
  @override
  String? get addressDocType;
  @override
  String? get addressDocUrl; // Address Details
  @override
  String? get pincode;
  @override
  String? get state;
  @override
  String? get city;
  @override
  String? get tehsil; // Details Without Document Upload
  @override
  String? get drivingLicenseNumber;
  @override
  String? get pucNumber;
  @override
  String? get insuranceNumber; // Preferences / Rules (Linked to Publish Ride)
  @override
  bool get prefNoSmoking;
  @override
  bool get prefNoMusic;
  @override
  bool get prefNoHeavyLuggage;
  @override
  bool get prefNoPets;
  @override
  bool get prefNegotiation;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
