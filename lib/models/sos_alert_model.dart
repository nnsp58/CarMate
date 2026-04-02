import 'package:freezed_annotation/freezed_annotation.dart';

part 'sos_alert_model.freezed.dart';
part 'sos_alert_model.g.dart';

@freezed
class SOSAlertModel with _$SOSAlertModel {
  const factory SOSAlertModel({
    required String id,
    required String userId,
    required String userName,
    required double latitude,
    required double longitude,
    String? locationName,
    String? emergencyType,
    @Default(true) bool isActive,
    required DateTime createdAt,
    DateTime? resolvedAt,
    String? resolvedBy,
  }) = _SOSAlertModel;

  factory SOSAlertModel.fromJson(Map<String, dynamic> json) =>
      _$SOSAlertModelFromJson(json);

  const SOSAlertModel._();

  String get emergencyTypeDisplay => emergencyType ?? 'General Emergency';
  String get locationDisplay => locationName ?? 'Location shared';

  bool get isResolved => resolvedAt != null;
  bool get canBeResolved => isActive && !isResolved;
}
