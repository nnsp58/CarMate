import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/notification_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/empty_state.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(myNotificationsProvider);
    final user = ref.watch(currentUserProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          if (user != null)
            IconButton(
              onPressed: () => ref
                  .read(notificationActionsProvider)
                  .markAllAsRead(user.id),
              icon: const Icon(Icons.done_all),
              tooltip: 'Mark all as read',
            ),
        ],
      ),
      body: notificationsAsync.when(
        data: (notifications) {
          if (notifications.isEmpty) {
            return const EmptyState(
              title: 'No notifications',
              message: 'We will notify you about your rides and bookings.',
              icon: Icons.notifications_none,
            );
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              final bool isRead = notification['is_read'] ?? false;
              final createdAt = DateTime.parse(notification['created_at']);

              return Dismissible(
                key: Key(notification['id']),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  if (user != null) {
                    ref
                        .read(notificationActionsProvider)
                        .deleteNotification(notification['id'], user.id);
                  }
                },
                child: ListTile(
                  onTap: () async {
                    // Mark as read FIRST, await it so stream updates
                    if (!isRead) {
                      await ref
                          .read(notificationActionsProvider)
                          .markAsRead(notification['id']);
                    }

                    if (!context.mounted) return;

                    // Navigation logic based on type
                    final type = notification['type'] as String?;
                    final rideId = notification['ride_id'] as String?;
                    final bookingId = notification['booking_id'] as String?;

                    if (bookingId != null) {
                      context.push('/booking-detail/$bookingId');
                    } else if (rideId != null) {
                      context.push('/ride-details/$rideId');
                    } else if (type == 'document_approved' || type == 'document_rejected') {
                      context.push('/documents');
                    }
                  },
                  tileColor: isRead ? null : AppColors.primaryLight.withValues(alpha: 0.1),
                  leading: _buildIcon(notification['type']),
                  title: Text(
                    notification['title'] ?? 'Notification',
                    style: TextStyle(
                      fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification['message'] ?? '',
                        style: TextStyle(
                          color: isRead ? AppColors.textSecondary : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        timeago.format(createdAt),
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  trailing: !isRead
                      ? Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.secondary,
                            shape: BoxShape.circle,
                          ),
                        )
                      : null,
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildIcon(String? type) {
    IconData iconData;
    Color color;

    switch (type) {
      case 'booking_confirmed':
      case 'document_approved':
        iconData = Icons.check_circle;
        color = Colors.green;
        break;
      case 'booking_cancelled':
      case 'ride_cancelled':
      case 'document_rejected':
        iconData = Icons.cancel;
        color = Colors.red;
        break;
      case 'sos_alert':
        iconData = Icons.warning;
        color = Colors.orange;
        break;
      case 'new_message':
        iconData = Icons.chat;
        color = AppColors.primary;
        break;
      case 'booking_request':
        iconData = Icons.pending_actions;
        color = AppColors.secondary;
        break;
      default:
        iconData = Icons.notifications;
        color = AppColors.primary;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, color: color, size: 24),
    );
  }
}
