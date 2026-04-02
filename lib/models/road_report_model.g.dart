// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'road_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RoadReportModelImpl _$$RoadReportModelImplFromJson(
        Map<String, dynamic> json) =>
    _$RoadReportModelImpl(
      id: json['id'] as String,
      reportType: json['report_type'] as String,
      description: json['description'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      reportedBy: json['reported_by'] as String,
      clearedVotes: (json['cleared_votes'] as num?)?.toInt() ?? 0,
      expiresAt: DateTime.parse(json['expires_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$RoadReportModelImplToJson(
        _$RoadReportModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'report_type': instance.reportType,
      'description': instance.description,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'reported_by': instance.reportedBy,
      'cleared_votes': instance.clearedVotes,
      'expires_at': instance.expiresAt.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
    };
