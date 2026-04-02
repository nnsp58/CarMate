import '../models/road_report_model.dart';
import '../core/constants/supabase_constants.dart';
import 'supabase_service.dart';

class ReportService {
  /// Create a road report
  static Future<String> createRoadReport({
    required String reportType,
    required double latitude,
    required double longitude,
    required String reportedBy,
    String? description,
  }) async {
    try {
      // Set expiration to 2 hours from now
      final expiresAt = DateTime.now().add(const Duration(hours: 2));

      final reportData = {
        'report_type': reportType,
        'description': description,
        'latitude': latitude,
        'longitude': longitude,
        'reported_by': reportedBy,
        'expires_at': expiresAt.toIso8601String(),
      };

      final response = await SupabaseService.client
          .from(SupabaseConstants.roadReportsTable)
          .insert(reportData)
          .select('id')
          .single();

      return response['id'] as String;
    } catch (e) {
      throw Exception('Failed to create road report: $e');
    }
  }

  /// Get active road reports
  static Future<List<RoadReportModel>> getActiveReports() async {
    try {
      final response = await SupabaseService.client
          .from(SupabaseConstants.roadReportsTable)
          .select()
          .gt('expires_at', DateTime.now().toIso8601String())
          .order('created_at', ascending: false);

      return response.map((json) => RoadReportModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get active reports: $e');
    }
  }

  /// Get reports near location
  static Future<List<RoadReportModel>> getReportsNearLocation({
    required double latitude,
    required double longitude,
    double radiusKm = 5,
  }) async {
    try {
      // For now, return all active reports (location filtering can be enhanced with PostGIS)
      final response = await SupabaseService.client
          .from(SupabaseConstants.roadReportsTable)
          .select()
          .gt('expires_at', DateTime.now().toIso8601String())
          .order('created_at', ascending: false);

      return response.map((json) => RoadReportModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get nearby reports: $e');
    }
  }

  /// Vote to clear a report
  static Future<void> voteToClearReport({
    required String reportId,
    required String userId,
  }) async {
    try {
      // Check if user already voted (simple implementation)
      final existingVote = await SupabaseService.client
          .from('report_votes') // This table would need to be created
          .select()
          .eq('report_id', reportId)
          .eq('user_id', userId)
          .maybeSingle();

      if (existingVote == null) {
        // Add vote
        await SupabaseService.client
            .from('report_votes')
            .insert({
              'report_id': reportId,
              'user_id': userId,
            });

        // Increment cleared_votes
        await SupabaseService.client
            .from(SupabaseConstants.roadReportsTable)
            .update({
              'cleared_votes': SupabaseService.client.rpc('increment_cleared_votes', params: {'report_id': reportId}),
            })
            .eq('id', reportId);
      }
    } catch (e) {
      throw Exception('Failed to vote on report: $e');
    }
  }

  /// Delete expired reports (admin/cleanup function)
  static Future<void> cleanupExpiredReports() async {
    try {
      await SupabaseService.client
          .from(SupabaseConstants.roadReportsTable)
          .delete()
          .lt('expires_at', DateTime.now().toIso8601String());
    } catch (e) {
      throw Exception('Failed to cleanup expired reports: $e');
    }
  }

  /// Get user's reports
  static Future<List<RoadReportModel>> getUserReports({
    required String userId,
  }) async {
    try {
      final response = await SupabaseService.client
          .from(SupabaseConstants.roadReportsTable)
          .select()
          .eq('reported_by', userId)
          .order('created_at', ascending: false);

      return response.map((json) => RoadReportModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get user reports: $e');
    }
  }
}
