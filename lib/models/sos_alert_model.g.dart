// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sos_alert_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SOSAlertModelImpl _$$SOSAlertModelImplFromJson(Map<String, dynamic> json) =>
    _$SOSAlertModelImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      userName: json['user_name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      locationName: json['location_name'] as String?,
      emergencyType: json['emergency_type'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      resolvedAt: json['resolved_at'] == null
          ? null
          : DateTime.parse(json['resolved_at'] as String),
      resolvedBy: json['resolved_by'] as String?,
    );

Map<String, dynamic> _$$SOSAlertModelImplToJson(_$SOSAlertModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'user_name': instance.userName,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'location_name': instance.locationName,
      'emergency_type': instance.emergencyType,
      'is_active': instance.isActive,
      'created_at': instance.createdAt.toIso8601String(),
      'resolved_at': instance.resolvedAt?.toIso8601String(),
      'resolved_by': instance.resolvedBy,
    };
