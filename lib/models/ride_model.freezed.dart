// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ride_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RideModel _$RideModelFromJson(Map<String, dynamic> json) {
  return _RideModel.fromJson(json);
}

/// @nodoc
mixin _$RideModel {
  String get id => throw _privateConstructorUsedError;
  String get driverId => throw _privateConstructorUsedError;
  String get driverName => throw _privateConstructorUsedError;
  String? get driverPhotoUrl => throw _privateConstructorUsedError;
  double get driverRating => throw _privateConstructorUsedError;
  String get fromLocation => throw _privateConstructorUsedError;
  String get toLocation => throw _privateConstructorUsedError;
  double? get fromLat => throw _privateConstructorUsedError;
  double? get fromLng => throw _privateConstructorUsedError;
  double? get toLat => throw _privateConstructorUsedError;
  double? get toLng => throw _privateConstructorUsedError;
  DateTime get departureDatetime => throw _privateConstructorUsedError;
  int get availableSeats => throw _privateConstructorUsedError;
  int get totalSeats => throw _privateConstructorUsedError;
  double get pricePerSeat => throw _privateConstructorUsedError;
  String? get vehicleInfo => throw _privateConstructorUsedError;
  String? get vehicleType => throw _privateConstructorUsedError;
  String? get description =>
      throw _privateConstructorUsedError; // Virtual field for pro-rata price based on search
  double? get segmentPrice =>
      throw _privateConstructorUsedError; // Route points stored as list of {lat, lng} maps
  @JsonKey(name: 'route_points')
  List<Map<String, dynamic>>? get routePointsJson =>
      throw _privateConstructorUsedError; // Extra Trip Details
  @JsonKey(name: 'distance_km')
  double? get distanceKm => throw _privateConstructorUsedError;
  @JsonKey(name: 'duration_mins')
  int? get durationMins =>
      throw _privateConstructorUsedError; // Trip Rules / Preferences
  bool get ruleNoSmoking => throw _privateConstructorUsedError;
  bool get ruleNoMusic => throw _privateConstructorUsedError;
  bool get ruleNoHeavyLuggage => throw _privateConstructorUsedError;
  bool get ruleNoPets => throw _privateConstructorUsedError;
  bool get ruleNegotiation => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this RideModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RideModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RideModelCopyWith<RideModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RideModelCopyWith<$Res> {
  factory $RideModelCopyWith(RideModel value, $Res Function(RideModel) then) =
      _$RideModelCopyWithImpl<$Res, RideModel>;
  @useResult
  $Res call(
      {String id,
      String driverId,
      String driverName,
      String? driverPhotoUrl,
      double driverRating,
      String fromLocation,
      String toLocation,
      double? fromLat,
      double? fromLng,
      double? toLat,
      double? toLng,
      DateTime departureDatetime,
      int availableSeats,
      int totalSeats,
      double pricePerSeat,
      String? vehicleInfo,
      String? vehicleType,
      String? description,
      double? segmentPrice,
      @JsonKey(name: 'route_points')
      List<Map<String, dynamic>>? routePointsJson,
      @JsonKey(name: 'distance_km') double? distanceKm,
      @JsonKey(name: 'duration_mins') int? durationMins,
      bool ruleNoSmoking,
      bool ruleNoMusic,
      bool ruleNoHeavyLuggage,
      bool ruleNoPets,
      bool ruleNegotiation,
      String status,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$RideModelCopyWithImpl<$Res, $Val extends RideModel>
    implements $RideModelCopyWith<$Res> {
  _$RideModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RideModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? driverId = null,
    Object? driverName = null,
    Object? driverPhotoUrl = freezed,
    Object? driverRating = null,
    Object? fromLocation = null,
    Object? toLocation = null,
    Object? fromLat = freezed,
    Object? fromLng = freezed,
    Object? toLat = freezed,
    Object? toLng = freezed,
    Object? departureDatetime = null,
    Object? availableSeats = null,
    Object? totalSeats = null,
    Object? pricePerSeat = null,
    Object? vehicleInfo = freezed,
    Object? vehicleType = freezed,
    Object? description = freezed,
    Object? segmentPrice = freezed,
    Object? routePointsJson = freezed,
    Object? distanceKm = freezed,
    Object? durationMins = freezed,
    Object? ruleNoSmoking = null,
    Object? ruleNoMusic = null,
    Object? ruleNoHeavyLuggage = null,
    Object? ruleNoPets = null,
    Object? ruleNegotiation = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      driverId: null == driverId
          ? _value.driverId
          : driverId // ignore: cast_nullable_to_non_nullable
              as String,
      driverName: null == driverName
          ? _value.driverName
          : driverName // ignore: cast_nullable_to_non_nullable
              as String,
      driverPhotoUrl: freezed == driverPhotoUrl
          ? _value.driverPhotoUrl
          : driverPhotoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      driverRating: null == driverRating
          ? _value.driverRating
          : driverRating // ignore: cast_nullable_to_non_nullable
              as double,
      fromLocation: null == fromLocation
          ? _value.fromLocation
          : fromLocation // ignore: cast_nullable_to_non_nullable
              as String,
      toLocation: null == toLocation
          ? _value.toLocation
          : toLocation // ignore: cast_nullable_to_non_nullable
              as String,
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
      departureDatetime: null == departureDatetime
          ? _value.departureDatetime
          : departureDatetime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      availableSeats: null == availableSeats
          ? _value.availableSeats
          : availableSeats // ignore: cast_nullable_to_non_nullable
              as int,
      totalSeats: null == totalSeats
          ? _value.totalSeats
          : totalSeats // ignore: cast_nullable_to_non_nullable
              as int,
      pricePerSeat: null == pricePerSeat
          ? _value.pricePerSeat
          : pricePerSeat // ignore: cast_nullable_to_non_nullable
              as double,
      vehicleInfo: freezed == vehicleInfo
          ? _value.vehicleInfo
          : vehicleInfo // ignore: cast_nullable_to_non_nullable
              as String?,
      vehicleType: freezed == vehicleType
          ? _value.vehicleType
          : vehicleType // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      segmentPrice: freezed == segmentPrice
          ? _value.segmentPrice
          : segmentPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      routePointsJson: freezed == routePointsJson
          ? _value.routePointsJson
          : routePointsJson // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      distanceKm: freezed == distanceKm
          ? _value.distanceKm
          : distanceKm // ignore: cast_nullable_to_non_nullable
              as double?,
      durationMins: freezed == durationMins
          ? _value.durationMins
          : durationMins // ignore: cast_nullable_to_non_nullable
              as int?,
      ruleNoSmoking: null == ruleNoSmoking
          ? _value.ruleNoSmoking
          : ruleNoSmoking // ignore: cast_nullable_to_non_nullable
              as bool,
      ruleNoMusic: null == ruleNoMusic
          ? _value.ruleNoMusic
          : ruleNoMusic // ignore: cast_nullable_to_non_nullable
              as bool,
      ruleNoHeavyLuggage: null == ruleNoHeavyLuggage
          ? _value.ruleNoHeavyLuggage
          : ruleNoHeavyLuggage // ignore: cast_nullable_to_non_nullable
              as bool,
      ruleNoPets: null == ruleNoPets
          ? _value.ruleNoPets
          : ruleNoPets // ignore: cast_nullable_to_non_nullable
              as bool,
      ruleNegotiation: null == ruleNegotiation
          ? _value.ruleNegotiation
          : ruleNegotiation // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RideModelImplCopyWith<$Res>
    implements $RideModelCopyWith<$Res> {
  factory _$$RideModelImplCopyWith(
          _$RideModelImpl value, $Res Function(_$RideModelImpl) then) =
      __$$RideModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String driverId,
      String driverName,
      String? driverPhotoUrl,
      double driverRating,
      String fromLocation,
      String toLocation,
      double? fromLat,
      double? fromLng,
      double? toLat,
      double? toLng,
      DateTime departureDatetime,
      int availableSeats,
      int totalSeats,
      double pricePerSeat,
      String? vehicleInfo,
      String? vehicleType,
      String? description,
      double? segmentPrice,
      @JsonKey(name: 'route_points')
      List<Map<String, dynamic>>? routePointsJson,
      @JsonKey(name: 'distance_km') double? distanceKm,
      @JsonKey(name: 'duration_mins') int? durationMins,
      bool ruleNoSmoking,
      bool ruleNoMusic,
      bool ruleNoHeavyLuggage,
      bool ruleNoPets,
      bool ruleNegotiation,
      String status,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$RideModelImplCopyWithImpl<$Res>
    extends _$RideModelCopyWithImpl<$Res, _$RideModelImpl>
    implements _$$RideModelImplCopyWith<$Res> {
  __$$RideModelImplCopyWithImpl(
      _$RideModelImpl _value, $Res Function(_$RideModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of RideModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? driverId = null,
    Object? driverName = null,
    Object? driverPhotoUrl = freezed,
    Object? driverRating = null,
    Object? fromLocation = null,
    Object? toLocation = null,
    Object? fromLat = freezed,
    Object? fromLng = freezed,
    Object? toLat = freezed,
    Object? toLng = freezed,
    Object? departureDatetime = null,
    Object? availableSeats = null,
    Object? totalSeats = null,
    Object? pricePerSeat = null,
    Object? vehicleInfo = freezed,
    Object? vehicleType = freezed,
    Object? description = freezed,
    Object? segmentPrice = freezed,
    Object? routePointsJson = freezed,
    Object? distanceKm = freezed,
    Object? durationMins = freezed,
    Object? ruleNoSmoking = null,
    Object? ruleNoMusic = null,
    Object? ruleNoHeavyLuggage = null,
    Object? ruleNoPets = null,
    Object? ruleNegotiation = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$RideModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      driverId: null == driverId
          ? _value.driverId
          : driverId // ignore: cast_nullable_to_non_nullable
              as String,
      driverName: null == driverName
          ? _value.driverName
          : driverName // ignore: cast_nullable_to_non_nullable
              as String,
      driverPhotoUrl: freezed == driverPhotoUrl
          ? _value.driverPhotoUrl
          : driverPhotoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      driverRating: null == driverRating
          ? _value.driverRating
          : driverRating // ignore: cast_nullable_to_non_nullable
              as double,
      fromLocation: null == fromLocation
          ? _value.fromLocation
          : fromLocation // ignore: cast_nullable_to_non_nullable
              as String,
      toLocation: null == toLocation
          ? _value.toLocation
          : toLocation // ignore: cast_nullable_to_non_nullable
              as String,
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
      departureDatetime: null == departureDatetime
          ? _value.departureDatetime
          : departureDatetime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      availableSeats: null == availableSeats
          ? _value.availableSeats
          : availableSeats // ignore: cast_nullable_to_non_nullable
              as int,
      totalSeats: null == totalSeats
          ? _value.totalSeats
          : totalSeats // ignore: cast_nullable_to_non_nullable
              as int,
      pricePerSeat: null == pricePerSeat
          ? _value.pricePerSeat
          : pricePerSeat // ignore: cast_nullable_to_non_nullable
              as double,
      vehicleInfo: freezed == vehicleInfo
          ? _value.vehicleInfo
          : vehicleInfo // ignore: cast_nullable_to_non_nullable
              as String?,
      vehicleType: freezed == vehicleType
          ? _value.vehicleType
          : vehicleType // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      segmentPrice: freezed == segmentPrice
          ? _value.segmentPrice
          : segmentPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      routePointsJson: freezed == routePointsJson
          ? _value._routePointsJson
          : routePointsJson // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      distanceKm: freezed == distanceKm
          ? _value.distanceKm
          : distanceKm // ignore: cast_nullable_to_non_nullable
              as double?,
      durationMins: freezed == durationMins
          ? _value.durationMins
          : durationMins // ignore: cast_nullable_to_non_nullable
              as int?,
      ruleNoSmoking: null == ruleNoSmoking
          ? _value.ruleNoSmoking
          : ruleNoSmoking // ignore: cast_nullable_to_non_nullable
              as bool,
      ruleNoMusic: null == ruleNoMusic
          ? _value.ruleNoMusic
          : ruleNoMusic // ignore: cast_nullable_to_non_nullable
              as bool,
      ruleNoHeavyLuggage: null == ruleNoHeavyLuggage
          ? _value.ruleNoHeavyLuggage
          : ruleNoHeavyLuggage // ignore: cast_nullable_to_non_nullable
              as bool,
      ruleNoPets: null == ruleNoPets
          ? _value.ruleNoPets
          : ruleNoPets // ignore: cast_nullable_to_non_nullable
              as bool,
      ruleNegotiation: null == ruleNegotiation
          ? _value.ruleNegotiation
          : ruleNegotiation // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RideModelImpl extends _RideModel {
  const _$RideModelImpl(
      {required this.id,
      required this.driverId,
      required this.driverName,
      this.driverPhotoUrl,
      this.driverRating = 5.0,
      required this.fromLocation,
      required this.toLocation,
      this.fromLat,
      this.fromLng,
      this.toLat,
      this.toLng,
      required this.departureDatetime,
      required this.availableSeats,
      required this.totalSeats,
      required this.pricePerSeat,
      this.vehicleInfo,
      this.vehicleType,
      this.description,
      this.segmentPrice,
      @JsonKey(name: 'route_points')
      final List<Map<String, dynamic>>? routePointsJson,
      @JsonKey(name: 'distance_km') this.distanceKm,
      @JsonKey(name: 'duration_mins') this.durationMins,
      this.ruleNoSmoking = false,
      this.ruleNoMusic = false,
      this.ruleNoHeavyLuggage = false,
      this.ruleNoPets = false,
      this.ruleNegotiation = false,
      this.status = 'active',
      required this.createdAt,
      this.updatedAt})
      : _routePointsJson = routePointsJson,
        super._();

  factory _$RideModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RideModelImplFromJson(json);

  @override
  final String id;
  @override
  final String driverId;
  @override
  final String driverName;
  @override
  final String? driverPhotoUrl;
  @override
  @JsonKey()
  final double driverRating;
  @override
  final String fromLocation;
  @override
  final String toLocation;
  @override
  final double? fromLat;
  @override
  final double? fromLng;
  @override
  final double? toLat;
  @override
  final double? toLng;
  @override
  final DateTime departureDatetime;
  @override
  final int availableSeats;
  @override
  final int totalSeats;
  @override
  final double pricePerSeat;
  @override
  final String? vehicleInfo;
  @override
  final String? vehicleType;
  @override
  final String? description;
// Virtual field for pro-rata price based on search
  @override
  final double? segmentPrice;
// Route points stored as list of {lat, lng} maps
  final List<Map<String, dynamic>>? _routePointsJson;
// Route points stored as list of {lat, lng} maps
  @override
  @JsonKey(name: 'route_points')
  List<Map<String, dynamic>>? get routePointsJson {
    final value = _routePointsJson;
    if (value == null) return null;
    if (_routePointsJson is EqualUnmodifiableListView) return _routePointsJson;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// Extra Trip Details
  @override
  @JsonKey(name: 'distance_km')
  final double? distanceKm;
  @override
  @JsonKey(name: 'duration_mins')
  final int? durationMins;
// Trip Rules / Preferences
  @override
  @JsonKey()
  final bool ruleNoSmoking;
  @override
  @JsonKey()
  final bool ruleNoMusic;
  @override
  @JsonKey()
  final bool ruleNoHeavyLuggage;
  @override
  @JsonKey()
  final bool ruleNoPets;
  @override
  @JsonKey()
  final bool ruleNegotiation;
  @override
  @JsonKey()
  final String status;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'RideModel(id: $id, driverId: $driverId, driverName: $driverName, driverPhotoUrl: $driverPhotoUrl, driverRating: $driverRating, fromLocation: $fromLocation, toLocation: $toLocation, fromLat: $fromLat, fromLng: $fromLng, toLat: $toLat, toLng: $toLng, departureDatetime: $departureDatetime, availableSeats: $availableSeats, totalSeats: $totalSeats, pricePerSeat: $pricePerSeat, vehicleInfo: $vehicleInfo, vehicleType: $vehicleType, description: $description, segmentPrice: $segmentPrice, routePointsJson: $routePointsJson, distanceKm: $distanceKm, durationMins: $durationMins, ruleNoSmoking: $ruleNoSmoking, ruleNoMusic: $ruleNoMusic, ruleNoHeavyLuggage: $ruleNoHeavyLuggage, ruleNoPets: $ruleNoPets, ruleNegotiation: $ruleNegotiation, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RideModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.driverId, driverId) ||
                other.driverId == driverId) &&
            (identical(other.driverName, driverName) ||
                other.driverName == driverName) &&
            (identical(other.driverPhotoUrl, driverPhotoUrl) ||
                other.driverPhotoUrl == driverPhotoUrl) &&
            (identical(other.driverRating, driverRating) ||
                other.driverRating == driverRating) &&
            (identical(other.fromLocation, fromLocation) ||
                other.fromLocation == fromLocation) &&
            (identical(other.toLocation, toLocation) ||
                other.toLocation == toLocation) &&
            (identical(other.fromLat, fromLat) || other.fromLat == fromLat) &&
            (identical(other.fromLng, fromLng) || other.fromLng == fromLng) &&
            (identical(other.toLat, toLat) || other.toLat == toLat) &&
            (identical(other.toLng, toLng) || other.toLng == toLng) &&
            (identical(other.departureDatetime, departureDatetime) ||
                other.departureDatetime == departureDatetime) &&
            (identical(other.availableSeats, availableSeats) ||
                other.availableSeats == availableSeats) &&
            (identical(other.totalSeats, totalSeats) ||
                other.totalSeats == totalSeats) &&
            (identical(other.pricePerSeat, pricePerSeat) ||
                other.pricePerSeat == pricePerSeat) &&
            (identical(other.vehicleInfo, vehicleInfo) ||
                other.vehicleInfo == vehicleInfo) &&
            (identical(other.vehicleType, vehicleType) ||
                other.vehicleType == vehicleType) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.segmentPrice, segmentPrice) ||
                other.segmentPrice == segmentPrice) &&
            const DeepCollectionEquality()
                .equals(other._routePointsJson, _routePointsJson) &&
            (identical(other.distanceKm, distanceKm) ||
                other.distanceKm == distanceKm) &&
            (identical(other.durationMins, durationMins) ||
                other.durationMins == durationMins) &&
            (identical(other.ruleNoSmoking, ruleNoSmoking) ||
                other.ruleNoSmoking == ruleNoSmoking) &&
            (identical(other.ruleNoMusic, ruleNoMusic) ||
                other.ruleNoMusic == ruleNoMusic) &&
            (identical(other.ruleNoHeavyLuggage, ruleNoHeavyLuggage) ||
                other.ruleNoHeavyLuggage == ruleNoHeavyLuggage) &&
            (identical(other.ruleNoPets, ruleNoPets) ||
                other.ruleNoPets == ruleNoPets) &&
            (identical(other.ruleNegotiation, ruleNegotiation) ||
                other.ruleNegotiation == ruleNegotiation) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        driverId,
        driverName,
        driverPhotoUrl,
        driverRating,
        fromLocation,
        toLocation,
        fromLat,
        fromLng,
        toLat,
        toLng,
        departureDatetime,
        availableSeats,
        totalSeats,
        pricePerSeat,
        vehicleInfo,
        vehicleType,
        description,
        segmentPrice,
        const DeepCollectionEquality().hash(_routePointsJson),
        distanceKm,
        durationMins,
        ruleNoSmoking,
        ruleNoMusic,
        ruleNoHeavyLuggage,
        ruleNoPets,
        ruleNegotiation,
        status,
        createdAt,
        updatedAt
      ]);

  /// Create a copy of RideModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RideModelImplCopyWith<_$RideModelImpl> get copyWith =>
      __$$RideModelImplCopyWithImpl<_$RideModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RideModelImplToJson(
      this,
    );
  }
}

abstract class _RideModel extends RideModel {
  const factory _RideModel(
      {required final String id,
      required final String driverId,
      required final String driverName,
      final String? driverPhotoUrl,
      final double driverRating,
      required final String fromLocation,
      required final String toLocation,
      final double? fromLat,
      final double? fromLng,
      final double? toLat,
      final double? toLng,
      required final DateTime departureDatetime,
      required final int availableSeats,
      required final int totalSeats,
      required final double pricePerSeat,
      final String? vehicleInfo,
      final String? vehicleType,
      final String? description,
      final double? segmentPrice,
      @JsonKey(name: 'route_points')
      final List<Map<String, dynamic>>? routePointsJson,
      @JsonKey(name: 'distance_km') final double? distanceKm,
      @JsonKey(name: 'duration_mins') final int? durationMins,
      final bool ruleNoSmoking,
      final bool ruleNoMusic,
      final bool ruleNoHeavyLuggage,
      final bool ruleNoPets,
      final bool ruleNegotiation,
      final String status,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$RideModelImpl;
  const _RideModel._() : super._();

  factory _RideModel.fromJson(Map<String, dynamic> json) =
      _$RideModelImpl.fromJson;

  @override
  String get id;
  @override
  String get driverId;
  @override
  String get driverName;
  @override
  String? get driverPhotoUrl;
  @override
  double get driverRating;
  @override
  String get fromLocation;
  @override
  String get toLocation;
  @override
  double? get fromLat;
  @override
  double? get fromLng;
  @override
  double? get toLat;
  @override
  double? get toLng;
  @override
  DateTime get departureDatetime;
  @override
  int get availableSeats;
  @override
  int get totalSeats;
  @override
  double get pricePerSeat;
  @override
  String? get vehicleInfo;
  @override
  String? get vehicleType;
  @override
  String? get description; // Virtual field for pro-rata price based on search
  @override
  double? get segmentPrice; // Route points stored as list of {lat, lng} maps
  @override
  @JsonKey(name: 'route_points')
  List<Map<String, dynamic>>? get routePointsJson; // Extra Trip Details
  @override
  @JsonKey(name: 'distance_km')
  double? get distanceKm;
  @override
  @JsonKey(name: 'duration_mins')
  int? get durationMins; // Trip Rules / Preferences
  @override
  bool get ruleNoSmoking;
  @override
  bool get ruleNoMusic;
  @override
  bool get ruleNoHeavyLuggage;
  @override
  bool get ruleNoPets;
  @override
  bool get ruleNegotiation;
  @override
  String get status;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of RideModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RideModelImplCopyWith<_$RideModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
