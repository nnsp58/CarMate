import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/admin_service.dart';

// Dashboard Stats Provider
final adminStatsProvider = FutureProvider<Map<String, int>>((ref) async {
  return await AdminService.getDashboardStats();
});

// All Users Provider
final adminUsersProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return await AdminService.getAllUsers();
});

// Pending Verifications Provider
final pendingVerificationsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return await AdminService.getPendingVerifications();
});

// Active SOS Alerts Stream Provider
final activeSosProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  return AdminService.watchSosAlerts().map((list) => list.where((item) => item['is_active'] == true).toList());
});

// All Rides Provider
final adminRidesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return await AdminService.getAllRides();
});

// Admin Actions Notifier
final adminActionsProvider = Provider((ref) => AdminActions(ref));

class AdminActions {
  final Ref ref;
  AdminActions(this.ref);

  Future<void> updateUserStatus(String userId, bool isBanned) async {
    await AdminService.updateUserStatus(userId, isBanned: isBanned);
    ref.invalidate(adminUsersProvider);
  }

  Future<void> verifyDocument(String userId, bool approved, {String? reason}) async {
    await AdminService.verifyDocument(userId, approved: approved, reason: reason);
    ref.invalidate(pendingVerificationsProvider);
    ref.invalidate(adminStatsProvider);
  }

  Future<void> resolveSos(String alertId, String adminId) async {
    await AdminService.resolveSos(alertId, adminId);
  }
}
