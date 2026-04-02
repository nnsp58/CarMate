// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sos_alert_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SOSAlertModel _$SOSAlertModelFromJson(Map<String, dynamic> json) {
  return _SOSAlertModel.fromJson(json);
}

/// @nodoc
mixin _$SOSAlertModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  String? get locationName => throw _privateConstructorUsedError;
  String? get emergencyType => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get resolvedAt => throw _privateConstructorUsedError;
  String? get resolvedBy => throw _privateConstructorUsedError;

  /// Serializes this SOSAlertModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SOSAlertModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SOSAlertModelCopyWith<SOSAlertModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SOSAlertModelCopyWith<$Res> {
  factory $SOSAlertModelCopyWith(
          SOSAlertModel value, $Res Function(SOSAlertModel) then) =
      _$SOSAlertModelCopyWithImpl<$Res, SOSAlertModel>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String userName,
      double latitude,
      double longitude,
      String? locationName,
      String? emergencyType,
      bool isActive,
      DateTime createdAt,
      DateTime? resolvedAt,
      String? resolvedBy});
}

/// @nodoc
class _$SOSAlertModelCopyWithImpl<$Res, $Val extends SOSAlertModel>
    implements $SOSAlertModelCopyWith<$Res> {
  _$SOSAlertModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SOSAlertModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? userName = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? locationName = freezed,
    Object? emergencyType = freezed,
    Object? isActive = null,
    Object? createdAt = null,
    Object? resolvedAt = freezed,
    Object? resolvedBy = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      locationName: freezed == locationName
          ? _value.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String?,
      emergencyType: freezed == emergencyType
          ? _value.emergencyType
          : emergencyType // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      resolvedAt: freezed == resolvedAt
          ? _value.resolvedAt
          : resolvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      resolvedBy: freezed == resolvedBy
          ? _value.resolvedBy
          : resolvedBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SOSAlertModelImplCopyWith<$Res>
    implements $SOSAlertModelCopyWith<$Res> {
  factory _$$SOSAlertModelImplCopyWith(
          _$SOSAlertModelImpl value, $Res Function(_$SOSAlertModelImpl) then) =
      __$$SOSAlertModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String userName,
      double latitude,
      double longitude,
      String? locationName,
      String? emergencyType,
      bool isActive,
      DateTime createdAt,
      DateTime? resolvedAt,
      String? resolvedBy});
}

/// @nodoc
class __$$SOSAlertModelImplCopyWithImpl<$Res>
    extends _$SOSAlertModelCopyWithImpl<$Res, _$SOSAlertModelImpl>
    implements _$$SOSAlertModelImplCopyWith<$Res> {
  __$$SOSAlertModelImplCopyWithImpl(
      _$SOSAlertModelImpl _value, $Res Function(_$SOSAlertModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SOSAlertModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? userName = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? locationName = freezed,
    Object? emergencyType = freezed,
    Object? isActive = null,
    Object? createdAt = null,
    Object? resolvedAt = freezed,
    Object? resolvedBy = freezed,
  }) {
    return _then(_$SOSAlertModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      locationName: freezed == locationName
          ? _value.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String?,
      emergencyType: freezed == emergencyType
          ? _value.emergencyType
          : emergencyType // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      resolvedAt: freezed == resolvedAt
          ? _value.resolvedAt
          : resolvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      resolvedBy: freezed == resolvedBy
          ? _value.resolvedBy
          : resolvedBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SOSAlertModelImpl extends _SOSAlertModel {
  const _$SOSAlertModelImpl(
      {required this.id,
      required this.userId,
      required this.userName,
      required this.latitude,
      required this.longitude,
      this.locationName,
      this.emergencyType,
      this.isActive = true,
      required this.createdAt,
      this.resolvedAt,
      this.resolvedBy})
      : super._();

  factory _$SOSAlertModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SOSAlertModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String userName;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final String? locationName;
  @override
  final String? emergencyType;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime createdAt;
  @override
  final DateTime? resolvedAt;
  @override
  final String? resolvedBy;

  @override
  String toString() {
    return 'SOSAlertModel(id: $id, userId: $userId, userName: $userName, latitude: $latitude, longitude: $longitude, locationName: $locationName, emergencyType: $emergencyType, isActive: $isActive, createdAt: $createdAt, resolvedAt: $resolvedAt, resolvedBy: $resolvedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SOSAlertModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.locationName, locationName) ||
                other.locationName == locationName) &&
            (identical(other.emergencyType, emergencyType) ||
                other.emergencyType == emergencyType) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.resolvedAt, resolvedAt) ||
                other.resolvedAt == resolvedAt) &&
            (identical(other.resolvedBy, resolvedBy) ||
                other.resolvedBy == resolvedBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      userName,
      latitude,
      longitude,
      locationName,
      emergencyType,
      isActive,
      createdAt,
      resolvedAt,
      resolvedBy);

  /// Create a copy of SOSAlertModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SOSAlertModelImplCopyWith<_$SOSAlertModelImpl> get copyWith =>
      __$$SOSAlertModelImplCopyWithImpl<_$SOSAlertModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SOSAlertModelImplToJson(
      this,
    );
  }
}

abstract class _SOSAlertModel extends SOSAlertModel {
  const factory _SOSAlertModel(
      {required final String id,
      required final String userId,
      required final String userName,
      required final double latitude,
      required final double longitude,
      final String? locationName,
      final String? emergencyType,
      final bool isActive,
      required final DateTime createdAt,
      final DateTime? resolvedAt,
      final String? resolvedBy}) = _$SOSAlertModelImpl;
  const _SOSAlertModel._() : super._();

  factory _SOSAlertModel.fromJson(Map<String, dynamic> json) =
      _$SOSAlertModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get userName;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  String? get locationName;
  @override
  String? get emergencyType;
  @override
  bool get isActive;
  @override
  DateTime get createdAt;
  @override
  DateTime? get resolvedAt;
  @override
  String? get resolvedBy;

  /// Create a copy of SOSAlertModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SOSAlertModelImplCopyWith<_$SOSAlertModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
