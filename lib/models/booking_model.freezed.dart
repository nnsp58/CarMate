// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BookingModel _$BookingModelFromJson(Map<String, dynamic> json) {
  return _BookingModel.fromJson(json);
}

/// @nodoc
mixin _$BookingModel {
  String get id => throw _privateConstructorUsedError;
  String get rideId => throw _privateConstructorUsedError;
  String get passengerId => throw _privateConstructorUsedError;
  String get driverId => throw _privateConstructorUsedError;
  String get passengerName => throw _privateConstructorUsedError;
  String? get passengerPhone => throw _privateConstructorUsedError;
  String? get fromLocation => throw _privateConstructorUsedError;
  String? get toLocation => throw _privateConstructorUsedError;
  double? get fromLat => throw _privateConstructorUsedError;
  double? get fromLng => throw _privateConstructorUsedError;
  double? get toLat => throw _privateConstructorUsedError;
  double? get toLng => throw _privateConstructorUsedError;
  int get seatsBooked => throw _privateConstructorUsedError;
  double get totalPrice => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  DateTime get bookedAt => throw _privateConstructorUsedError;
  DateTime? get cancelledAt => throw _privateConstructorUsedError;
  String? get cancelReason =>
      throw _privateConstructorUsedError; // Virtual fields from join or snapshots
  String? get rideFrom => throw _privateConstructorUsedError;
  String? get rideTo => throw _privateConstructorUsedError;
  DateTime? get departureDatetime => throw _privateConstructorUsedError;
  String? get passengerEmail => throw _privateConstructorUsedError;
  String? get passengerBio => throw _privateConstructorUsedError;
  String? get passengerPhotoUrl => throw _privateConstructorUsedError;

  /// Serializes this BookingModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingModelCopyWith<BookingModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingModelCopyWith<$Res> {
  factory $BookingModelCopyWith(
          BookingModel value, $Res Function(BookingModel) then) =
      _$BookingModelCopyWithImpl<$Res, BookingModel>;
  @useResult
  $Res call(
      {String id,
      String rideId,
      String passengerId,
      String driverId,
      String passengerName,
      String? passengerPhone,
      String? fromLocation,
      String? toLocation,
      double? fromLat,
      double? fromLng,
      double? toLat,
      double? toLng,
      int seatsBooked,
      double totalPrice,
      String status,
      DateTime bookedAt,
      DateTime? cancelledAt,
      String? cancelReason,
      String? rideFrom,
      String? rideTo,
      DateTime? departureDatetime,
      String? passengerEmail,
      String? passengerBio,
      String? passengerPhotoUrl});
}

/// @nodoc
class _$BookingModelCopyWithImpl<$Res, $Val extends BookingModel>
    implements $BookingModelCopyWith<$Res> {
  _$BookingModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? rideId = null,
    Object? passengerId = null,
    Object? driverId = null,
    Object? passengerName = null,
    Object? passengerPhone = freezed,
    Object? fromLocation = freezed,
    Object? toLocation = freezed,
    Object? fromLat = freezed,
    Object? fromLng = freezed,
    Object? toLat = freezed,
    Object? toLng = freezed,
    Object? seatsBooked = null,
    Object? totalPrice = null,
    Object? status = null,
    Object? bookedAt = null,
    Object? cancelledAt = freezed,
    Object? cancelReason = freezed,
    Object? rideFrom = freezed,
    Object? rideTo = freezed,
    Object? departureDatetime = freezed,
    Object? passengerEmail = freezed,
    Object? passengerBio = freezed,
    Object? passengerPhotoUrl = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      rideId: null == rideId
          ? _value.rideId
          : rideId // ignore: cast_nullable_to_non_nullable
              as String,
      passengerId: null == passengerId
          ? _value.passengerId
          : passengerId // ignore: cast_nullable_to_non_nullable
              as String,
      driverId: null == driverId
          ? _value.driverId
          : driverId // ignore: cast_nullable_to_non_nullable
              as String,
      passengerName: null == passengerName
          ? _value.passengerName
          : passengerName // ignore: cast_nullable_to_non_nullable
              as String,
      passengerPhone: freezed == passengerPhone
          ? _value.passengerPhone
          : passengerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      fromLocation: freezed == fromLocation
          ? _value.fromLocation
          : fromLocation // ignore: cast_nullable_to_non_nullable
              as String?,
      toLocation: freezed == toLocation
          ? _value.toLocation
          : toLocation // ignore: cast_nullable_to_non_nullable
              as String?,
      fromLat: freezed == fromLat
          ? _value.fromLat
          : fromLat // ignore: cast_nullable_to_non_nullable
              as double?,
      fromLng: freezed == fromLng
          ? _value.fromLng
          : fromLng // ignore: cast_nullable_to_non_nullable
              as double?,
      toLat: freezed == toLat
          ? _value.toLat
          : toLat // ignore: cast_nullable_to_non_nullable
              as double?,
      toLng: freezed == toLng
          ? _value.toLng
          : toLng // ignore: cast_nullable_to_non_nullable
              as double?,
      seatsBooked: null == seatsBooked
          ? _value.seatsBooked
          : seatsBooked // ignore: cast_nullable_to_non_nullable
              as int,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      bookedAt: null == bookedAt
          ? _value.bookedAt
          : bookedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      cancelledAt: freezed == cancelledAt
          ? _value.cancelledAt
          : cancelledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      cancelReason: freezed == cancelReason
          ? _value.cancelReason
          : cancelReason // ignore: cast_nullable_to_non_nullable
              as String?,
      rideFrom: freezed == rideFrom
          ? _value.rideFrom
          : rideFrom // ignore: cast_nullable_to_non_nullable
              as String?,
      rideTo: freezed == rideTo
          ? _value.rideTo
          : rideTo // ignore: cast_nullable_to_non_nullable
              as String?,
      departureDatetime: freezed == departureDatetime
          ? _value.departureDatetime
          : departureDatetime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      passengerEmail: freezed == passengerEmail
          ? _value.passengerEmail
          : passengerEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      passengerBio: freezed == passengerBio
          ? _value.passengerBio
          : passengerBio // ignore: cast_nullable_to_non_nullable
              as String?,
      passengerPhotoUrl: freezed == passengerPhotoUrl
          ? _value.passengerPhotoUrl
          : passengerPhotoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BookingModelImplCopyWith<$Res>
    implements $BookingModelCopyWith<$Res> {
  factory _$$BookingModelImplCopyWith(
          _$BookingModelImpl value, $Res Function(_$BookingModelImpl) then) =
      __$$BookingModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String rideId,
      String passengerId,
      String driverId,
      String passengerName,
      String? passengerPhone,
      String? fromLocation,
      String? toLocation,
      double? fromLat,
      double? fromLng,
      double? toLat,
      double? toLng,
      int seatsBooked,
      double totalPrice,
      String status,
      DateTime bookedAt,
      DateTime? cancelledAt,
      String? cancelReason,
      String? rideFrom,
      String? rideTo,
      DateTime? departureDatetime,
      String? passengerEmail,
      String? passengerBio,
      String? passengerPhotoUrl});
}

/// @nodoc
class __$$BookingModelImplCopyWithImpl<$Res>
    extends _$BookingModelCopyWithImpl<$Res, _$BookingModelImpl>
    implements _$$BookingModelImplCopyWith<$Res> {
  __$$BookingModelImplCopyWithImpl(
      _$BookingModelImpl _value, $Res Function(_$BookingModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of BookingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? rideId = null,
    Object? passengerId = null,
    Object? driverId = null,
    Object? passengerName = null,
    Object? passengerPhone = freezed,
    Object? fromLocation = freezed,
    Object? toLocation = freezed,
    Object? fromLat = freezed,
    Object? fromLng = freezed,
    Object? toLat = freezed,
    Object? toLng = freezed,
    Object? seatsBooked = null,
    Object? totalPrice = null,
    Object? status = null,
    Object? bookedAt = null,
    Object? cancelledAt = freezed,
    Object? cancelReason = freezed,
    Object? rideFrom = freezed,
    Object? rideTo = freezed,
    Object? departureDatetime = freezed,
    Object? passengerEmail = freezed,
    Object? passengerBio = freezed,
    Object? passengerPhotoUrl = freezed,
  }) {
    return _then(_$BookingModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      rideId: null == rideId
          ? _value.rideId
          : rideId // ignore: cast_nullable_to_non_nullable
              as String,
      passengerId: null == passengerId
          ? _value.passengerId
          : passengerId // ignore: cast_nullable_to_non_nullable
              as String,
      driverId: null == driverId
          ? _value.driverId
          : driverId // ignore: cast_nullable_to_non_nullable
              as String,
      passengerName: null == passengerName
          ? _value.passengerName
          : passengerName // ignore: cast_nullable_to_non_nullable
              as String,
      passengerPhone: freezed == passengerPhone
          ? _value.passengerPhone
          : passengerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      fromLocation: freezed == fromLocation
          ? _value.fromLocation
          : fromLocation // ignore: cast_nullable_to_non_nullable
              as String?,
      toLocation: freezed == toLocation
          ? _value.toLocation
          : toLocation // ignore: cast_nullable_to_non_nullable
              as String?,
      fromLat: freezed == fromLat
          ? _value.fromLat
          : fromLat // ignore: cast_nullable_to_non_nullable
              as double?,
      fromLng: freezed == fromLng
          ? _value.fromLng
          : fromLng // ignore: cast_nullable_to_non_nullable
              as double?,
      toLat: freezed == toLat
          ? _value.toLat
          : toLat // ignore: cast_nullable_to_non_nullable
              as double?,
      toLng: freezed == toLng
          ? _value.toLng
          : toLng // ignore: cast_nullable_to_non_nullable
              as double?,
      seatsBooked: null == seatsBooked
          ? _value.seatsBooked
          : seatsBooked // ignore: cast_nullable_to_non_nullable
              as int,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      bookedAt: null == bookedAt
          ? _value.bookedAt
          : bookedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      cancelledAt: freezed == cancelledAt
          ? _value.cancelledAt
          : cancelledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      cancelReason: freezed == cancelReason
          ? _value.cancelReason
          : cancelReason // ignore: cast_nullable_to_non_nullable
              as String?,
      rideFrom: freezed == rideFrom
          ? _value.rideFrom
          : rideFrom // ignore: cast_nullable_to_non_nullable
              as String?,
      rideTo: freezed == rideTo
          ? _value.rideTo
          : rideTo // ignore: cast_nullable_to_non_nullable
              as String?,
      departureDatetime: freezed == departureDatetime
          ? _value.departureDatetime
          : departureDatetime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      passengerEmail: freezed == passengerEmail
          ? _value.passengerEmail
          : passengerEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      passengerBio: freezed == passengerBio
          ? _value.passengerBio
          : passengerBio // ignore: cast_nullable_to_non_nullable
              as String?,
      passengerPhotoUrl: freezed == passengerPhotoUrl
          ? _value.passengerPhotoUrl
          : passengerPhotoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingModelImpl extends _BookingModel {
  const _$BookingModelImpl(
      {required this.id,
      required this.rideId,
      required this.passengerId,
      required this.driverId,
      required this.passengerName,
      this.passengerPhone,
      this.fromLocation,
      this.toLocation,
      this.fromLat,
      this.fromLng,
      this.toLat,
      this.toLng,
      this.seatsBooked = 1,
      required this.totalPrice,
      this.status = 'confirmed',
      required this.bookedAt,
      this.cancelledAt,
      this.cancelReason,
      this.rideFrom,
      this.rideTo,
      this.departureDatetime,
      this.passengerEmail,
      this.passengerBio,
      this.passengerPhotoUrl})
      : super._();

  factory _$BookingModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingModelImplFromJson(json);

  @override
  final String id;
  @override
  final String rideId;
  @override
  final String passengerId;
  @override
  final String driverId;
  @override
  final String passengerName;
  @override
  final String? passengerPhone;
  @override
  final String? fromLocation;
  @override
  final String? toLocation;
  @override
  final double? fromLat;
  @override
  final double? fromLng;
  @override
  final double? toLat;
  @override
  final double? toLng;
  @override
  @JsonKey()
  final int seatsBooked;
  @override
  final double totalPrice;
  @override
  @JsonKey()
  final String status;
  @override
  final DateTime bookedAt;
  @override
  final DateTime? cancelledAt;
  @override
  final String? cancelReason;
// Virtual fields from join or snapshots
  @override
  final String? rideFrom;
  @override
  final String? rideTo;
  @override
  final DateTime? departureDatetime;
  @override
  final String? passengerEmail;
  @override
  final String? passengerBio;
  @override
  final String? passengerPhotoUrl;

  @override
  String toString() {
    return 'BookingModel(id: $id, rideId: $rideId, passengerId: $passengerId, driverId: $driverId, passengerName: $passengerName, passengerPhone: $passengerPhone, fromLocation: $fromLocation, toLocation: $toLocation, fromLat: $fromLat, fromLng: $fromLng, toLat: $toLat, toLng: $toLng, seatsBooked: $seatsBooked, totalPrice: $totalPrice, status: $status, bookedAt: $bookedAt, cancelledAt: $cancelledAt, cancelReason: $cancelReason, rideFrom: $rideFrom, rideTo: $rideTo, departureDatetime: $departureDatetime, passengerEmail: $passengerEmail, passengerBio: $passengerBio, passengerPhotoUrl: $passengerPhotoUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.rideId, rideId) || other.rideId == rideId) &&
            (identical(other.passengerId, passengerId) ||
                other.passengerId == passengerId) &&
            (identical(other.driverId, driverId) ||
                other.driverId == driverId) &&
            (identical(other.passengerName, passengerName) ||
                other.passengerName == passengerName) &&
            (identical(other.passengerPhone, passengerPhone) ||
                other.passengerPhone == passengerPhone) &&
            (identical(other.fromLocation, fromLocation) ||
                other.fromLocation == fromLocation) &&
            (identical(other.toLocation, toLocation) ||
                other.toLocation == toLocation) &&
            (identical(other.fromLat, fromLat) || other.fromLat == fromLat) &&
            (identical(other.fromLng, fromLng) || other.fromLng == fromLng) &&
            (identical(other.toLat, toLat) || other.toLat == toLat) &&
            (identical(other.toLng, toLng) || other.toLng == toLng) &&
            (identical(other.seatsBooked, seatsBooked) ||
                other.seatsBooked == seatsBooked) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.bookedAt, bookedAt) ||
                other.bookedAt == bookedAt) &&
            (identical(other.cancelledAt, cancelledAt) ||
                other.cancelledAt == cancelledAt) &&
            (identical(other.cancelReason, cancelReason) ||
                other.cancelReason == cancelReason) &&
            (identical(other.rideFrom, rideFrom) ||
                other.rideFrom == rideFrom) &&
            (identical(other.rideTo, rideTo) || other.rideTo == rideTo) &&
            (identical(other.departureDatetime, departureDatetime) ||
                other.departureDatetime == departureDatetime) &&
            (identical(other.passengerEmail, passengerEmail) ||
                other.passengerEmail == passengerEmail) &&
            (identical(other.passengerBio, passengerBio) ||
                other.passengerBio == passengerBio) &&
            (identical(other.passengerPhotoUrl, passengerPhotoUrl) ||
                other.passengerPhotoUrl == passengerPhotoUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        rideId,
        passengerId,
        driverId,
        passengerName,
        passengerPhone,
        fromLocation,
        toLocation,
        fromLat,
        fromLng,
        toLat,
        toLng,
        seatsBooked,
        totalPrice,
        status,
        bookedAt,
        cancelledAt,
        cancelReason,
        rideFrom,
        rideTo,
        departureDatetime,
        passengerEmail,
        passengerBio,
        passengerPhotoUrl
      ]);

  /// Create a copy of BookingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingModelImplCopyWith<_$BookingModelImpl> get copyWith =>
      __$$BookingModelImplCopyWithImpl<_$BookingModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingModelImplToJson(
      this,
    );
  }
}

abstract class _BookingModel extends BookingModel {
  const factory _BookingModel(
      {required final String id,
      required final String rideId,
      required final String passengerId,
      required final String driverId,
      required final String passengerName,
      final String? passengerPhone,
      final String? fromLocation,
      final String? toLocation,
      final double? fromLat,
      final double? fromLng,
      final double? toLat,
      final double? toLng,
      final int seatsBooked,
      required final double totalPrice,
      final String status,
      required final DateTime bookedAt,
      final DateTime? cancelledAt,
      final String? cancelReason,
      final String? rideFrom,
      final String? rideTo,
      final DateTime? departureDatetime,
      final String? passengerEmail,
      final String? passengerBio,
      final String? passengerPhotoUrl}) = _$BookingModelImpl;
  const _BookingModel._() : super._();

  factory _BookingModel.fromJson(Map<String, dynamic> json) =
      _$BookingModelImpl.fromJson;

  @override
  String get id;
  @override
  String get rideId;
  @override
  String get passengerId;
  @override
  String get driverId;
  @override
  String get passengerName;
  @override
  String? get passengerPhone;
  @override
  String? get fromLocation;
  @override
  String? get toLocation;
  @override
  double? get fromLat;
  @override
  double? get fromLng;
  @override
  double? get toLat;
  @override
  double? get toLng;
  @override
  int get seatsBooked;
  @override
  double get totalPrice;
  @override
  String get status;
  @override
  DateTime get bookedAt;
  @override
  DateTime? get cancelledAt;
  @override
  String? get cancelReason; // Virtual fields from join or snapshots
  @override
  String? get rideFrom;
  @override
  String? get rideTo;
  @override
  DateTime? get departureDatetime;
  @override
  String? get passengerEmail;
  @override
  String? get passengerBio;
  @override
  String? get passengerPhotoUrl;

  /// Create a copy of BookingModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingModelImplCopyWith<_$BookingModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
