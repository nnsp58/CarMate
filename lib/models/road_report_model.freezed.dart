// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'road_report_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RoadReportModel _$RoadReportModelFromJson(Map<String, dynamic> json) {
  return _RoadReportModel.fromJson(json);
}

/// @nodoc
mixin _$RoadReportModel {
  String get id => throw _privateConstructorUsedError;
  String get reportType => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  String get reportedBy => throw _privateConstructorUsedError;
  int get clearedVotes => throw _privateConstructorUsedError;
  DateTime get expiresAt => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this RoadReportModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RoadReportModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RoadReportModelCopyWith<RoadReportModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoadReportModelCopyWith<$Res> {
  factory $RoadReportModelCopyWith(
          RoadReportModel value, $Res Function(RoadReportModel) then) =
      _$RoadReportModelCopyWithImpl<$Res, RoadReportModel>;
  @useResult
  $Res call(
      {String id,
      String reportType,
      String? description,
      double? latitude,
      double? longitude,
      String reportedBy,
      int clearedVotes,
      DateTime expiresAt,
      DateTime createdAt});
}

/// @nodoc
class _$RoadReportModelCopyWithImpl<$Res, $Val extends RoadReportModel>
    implements $RoadReportModelCopyWith<$Res> {
  _$RoadReportModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RoadReportModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reportType = null,
    Object? description = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? reportedBy = null,
    Object? clearedVotes = null,
    Object? expiresAt = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      reportType: null == reportType
          ? _value.reportType
          : reportType // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      reportedBy: null == reportedBy
          ? _value.reportedBy
          : reportedBy // ignore: cast_nullable_to_non_nullable
              as String,
      clearedVotes: null == clearedVotes
          ? _value.clearedVotes
          : clearedVotes // ignore: cast_nullable_to_non_nullable
              as int,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RoadReportModelImplCopyWith<$Res>
    implements $RoadReportModelCopyWith<$Res> {
  factory _$$RoadReportModelImplCopyWith(_$RoadReportModelImpl value,
          $Res Function(_$RoadReportModelImpl) then) =
      __$$RoadReportModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String reportType,
      String? description,
      double? latitude,
      double? longitude,
      String reportedBy,
      int clearedVotes,
      DateTime expiresAt,
      DateTime createdAt});
}

/// @nodoc
class __$$RoadReportModelImplCopyWithImpl<$Res>
    extends _$RoadReportModelCopyWithImpl<$Res, _$RoadReportModelImpl>
    implements _$$RoadReportModelImplCopyWith<$Res> {
  __$$RoadReportModelImplCopyWithImpl(
      _$RoadReportModelImpl _value, $Res Function(_$RoadReportModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of RoadReportModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reportType = null,
    Object? description = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? reportedBy = null,
    Object? clearedVotes = null,
    Object? expiresAt = null,
    Object? createdAt = null,
  }) {
    return _then(_$RoadReportModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      reportType: null == reportType
          ? _value.reportType
          : reportType // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      reportedBy: null == reportedBy
          ? _value.reportedBy
          : reportedBy // ignore: cast_nullable_to_non_nullable
              as String,
      clearedVotes: null == clearedVotes
          ? _value.clearedVotes
          : clearedVotes // ignore: cast_nullable_to_non_nullable
              as int,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RoadReportModelImpl extends _RoadReportModel {
  const _$RoadReportModelImpl(
      {required this.id,
      required this.reportType,
      this.description,
      this.latitude,
      this.longitude,
      required this.reportedBy,
      this.clearedVotes = 0,
      required this.expiresAt,
      required this.createdAt})
      : super._();

  factory _$RoadReportModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoadReportModelImplFromJson(json);

  @override
  final String id;
  @override
  final String reportType;
  @override
  final String? description;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final String reportedBy;
  @override
  @JsonKey()
  final int clearedVotes;
  @override
  final DateTime expiresAt;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'RoadReportModel(id: $id, reportType: $reportType, description: $description, latitude: $latitude, longitude: $longitude, reportedBy: $reportedBy, clearedVotes: $clearedVotes, expiresAt: $expiresAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoadReportModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.reportType, reportType) ||
                other.reportType == reportType) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.reportedBy, reportedBy) ||
                other.reportedBy == reportedBy) &&
            (identical(other.clearedVotes, clearedVotes) ||
                other.clearedVotes == clearedVotes) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, reportType, description,
      latitude, longitude, reportedBy, clearedVotes, expiresAt, createdAt);

  /// Create a copy of RoadReportModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoadReportModelImplCopyWith<_$RoadReportModelImpl> get copyWith =>
      __$$RoadReportModelImplCopyWithImpl<_$RoadReportModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoadReportModelImplToJson(
      this,
    );
  }
}

abstract class _RoadReportModel extends RoadReportModel {
  const factory _RoadReportModel(
      {required final String id,
      required final String reportType,
      final String? description,
      final double? latitude,
      final double? longitude,
      required final String reportedBy,
      final int clearedVotes,
      required final DateTime expiresAt,
      required final DateTime createdAt}) = _$RoadReportModelImpl;
  const _RoadReportModel._() : super._();

  factory _RoadReportModel.fromJson(Map<String, dynamic> json) =
      _$RoadReportModelImpl.fromJson;

  @override
  String get id;
  @override
  String get reportType;
  @override
  String? get description;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  String get reportedBy;
  @override
  int get clearedVotes;
  @override
  DateTime get expiresAt;
  @override
  DateTime get createdAt;

  /// Create a copy of RoadReportModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoadReportModelImplCopyWith<_$RoadReportModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
