import 'package:supabase_flutter/supabase_flutter.dart';

class AdminService {
  static SupabaseClient get _client => Supabase.instance.client;

  // --- Statistics ---
  static Future<Map<String, int>> getDashboardStats() async {
    final totals = await Future.wait([
      _client.from('users').count(CountOption.exact),
      _client.from('rides').count(CountOption.exact),
      _client.from('sos_alerts').count(CountOption.exact),
      _client.from('users')
          .count(CountOption.exact)
          .eq('doc_verification_status', 'pending'),
    ]);

    return {
      'totalUsers': totals[0],
      'activeRides': totals[1],
      'sosAlerts': totals[2],
      'pendingVerifications': totals[3],
    };
  }

  // --- User Management ---
  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    final response = await _client
        .from('users')
        .select()
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<void> updateUserStatus(String userId, {required bool isBanned}) async {
    await _client.from('users').update({'is_banned': isBanned}).eq('id', userId);
  }

  static Future<void> toggleAdminStatus(String userId, {required bool isAdmin}) async {
    await _client.from('users').update({'is_admin': isAdmin}).eq('id', userId);
  }

  // --- Document Verification ---
  static Future<List<Map<String, dynamic>>> getPendingVerifications() async {
    final response = await _client
        .from('users')
        .select()
        .eq('doc_verification_status', 'pending')
        .order('updated_at', ascending: true);
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<void> verifyDocument(String userId, {required bool approved, String? reason}) async {
    await _client.from('users').update({
      'doc_verification_status': approved ? 'approved' : 'rejected',
      'doc_rejection_reason': reason,
      'doc_reviewed_at': DateTime.now().toIso8601String(),
    }).eq('id', userId);

    // Create notification for user
    await _client.from('notifications').insert({
      'user_id': userId,
      'title': approved ? 'Documents Approved ✅' : 'Documents Rejected ❌',
      'message': approved 
          ? 'Congratulations! Your documents have been verified. You can now publish rides.'
          : 'Your document verification failed. Reason: ${reason ?? "Not specified"}. Please re-upload correct documents.',
      'type': approved ? 'document_approved' : 'document_rejected',
    });
  }

  // --- SOS Alerts ---
  static Future<List<Map<String, dynamic>>> getActiveSosAlerts() async {
    final response = await _client
        .from('sos_alerts')
        .select('*, users(full_name, phone)')
        .eq('is_active', true)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  static Stream<List<Map<String, dynamic>>> watchSosAlerts() {
    return _client
        .from('sos_alerts')
        .stream(primaryKey: ['id'])
        .map((data) => List<Map<String, dynamic>>.from(data));
  }

  static Future<void> resolveSos(String alertId, String adminId) async {
    await _client.from('sos_alerts').update({
      'is_active': false,
      'resolved_at': DateTime.now().toIso8601String(),
      'resolved_by': adminId,
    }).eq('id', alertId);
  }

  // --- Ride Management ---
  static Future<List<Map<String, dynamic>>> getAllRides() async {
    final response = await _client
        .from('rides')
        .select()
        .order('departure_datetime', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<void> forceCancelRide(String rideId) async {
    await _client.from('rides').update({'status': 'cancelled'}).eq('id', rideId);
    
    // In a real app, this would trigger a database function to also cancel bookings and notify users.
  }
}
