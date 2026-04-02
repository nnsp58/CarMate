import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/notification_service.dart';
import 'auth_provider.dart';

// My Notifications Provider - real-time stream
final myNotificationsProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final currentUser = ref.watch(currentUserProvider);
  return currentUser.maybeWhen(
    data: (user) {
      if (user != null) {
        return NotificationService.getMyNotifications(userId: user.id);
      }
      return Stream.value([]);
    },
    orElse: () => Stream.value([]),
  );
});

// Notification Actions Provider
final notificationActionsProvider = Provider<NotificationActions>((ref) {
  return NotificationActions(ref);
});

class NotificationActions {
  NotificationActions(Ref ref);

  Future<void> sendNotification({
    required String userId,
    required String title,
    required String message,
    required String type,
    String? rideId,
    String? bookingId,
  }) async {
    await NotificationService.sendNotification(
      userId: userId,
      title: title,
      message: message,
      type: type,
      rideId: rideId,
      bookingId: bookingId,
    );
  }

  Future<void> markAsRead(String notificationId) async {
    await NotificationService.markAsRead(notificationId: notificationId);
  }

  Future<void> markAllAsRead(String userId) async {
    await NotificationService.markAllAsRead(userId: userId);
  }

  Future<void> deleteNotification(String notificationId, String userId) async {
    await NotificationService.deleteNotification(notificationId: notificationId, userId: userId);
  }
}
