import 'package:freezed_annotation/freezed_annotation.dart';

part 'road_report_model.freezed.dart';
part 'road_report_model.g.dart';

@freezed
class RoadReportModel with _$RoadReportModel {
  const factory RoadReportModel({
    required String id,
    required String reportType,
    String? description,
    double? latitude,
    double? longitude,
    required String reportedBy,
    @Default(0) int clearedVotes,
    required DateTime expiresAt,
    required DateTime createdAt,
  }) = _RoadReportModel;

  factory RoadReportModel.fromJson(Map<String, dynamic> json) =>
      _$RoadReportModelFromJson(json);

  const RoadReportModel._();

  String get reportTypeDisplay => _getReportTypeDisplay(reportType);
  String get descriptionDisplay => description ?? 'No description provided';

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get isActive => !isExpired;

  Duration get timeRemaining => expiresAt.difference(DateTime.now());
  String get timeRemainingText {
    if (isExpired) return 'Expired';

    final hours = timeRemaining.inHours;
    final minutes = timeRemaining.inMinutes.remainder(60);

    if (hours > 0) {
      return '$hours h ${minutes > 0 ? '$minutes m' : ''} remaining';
    } else if (minutes > 0) {
      return '$minutes min remaining';
    } else {
      return 'Expiring soon';
    }
  }

  static String _getReportTypeDisplay(String type) {
    switch (type) {
      case 'traffic':
        return 'Traffic Jam';
      case 'accident':
        return 'Accident';
      case 'police':
        return 'Police Activity';
      case 'roadblock':
        return 'Road Block';
      case 'hazard':
        return 'Hazard';
      default:
        return 'Road Issue';
    }
  }
}
