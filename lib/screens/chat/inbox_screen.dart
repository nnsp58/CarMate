import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/chat_provider.dart';
import '../../widgets/empty_state.dart';

class InboxScreen extends ConsumerWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatsAsync = ref.watch(myChatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: chatsAsync.when(
        data: (chats) {
          if (chats.isEmpty) {
            return const EmptyState(
              title: 'No messages yet',
              message: 'When you start a conversation, it will appear here.',
              icon: Icons.chat_bubble_outline,
            );
          }

          return ListView.separated(
            itemCount: chats.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final chat = chats[index];
              final lastMessageAt = chat['last_message_at'] != null
                  ? DateTime.parse(chat['last_message_at'])
                  : null;

              return ListTile(
                onTap: () => context.push(
                  '/chat/${chat['id']}',
                  extra: {'otherUserName': chat['other_user_name']},
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: CircleAvatar(
                  radius: 28,
                  backgroundImage: chat['other_user_photo'] != null
                      ? CachedNetworkImageProvider(chat['other_user_photo'])
                      : null,
                  child: chat['other_user_photo'] == null
                      ? const Icon(Icons.person)
                      : null,
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      chat['other_user_name'] ?? 'User',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (lastMessageAt != null)
                      Text(
                        timeago.format(lastMessageAt, locale: 'en_short'),
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      chat['last_message'] ?? 'Start a conversation',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: chat['unread_count'] != null &&
                                chat['unread_count'] > 0
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                        fontWeight: chat['unread_count'] != null &&
                                chat['unread_count'] > 0
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    if (chat['ride_route'] != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.directions_car,
                              size: 12, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Text(
                            chat['ride_route'],
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
                trailing: chat['unread_count'] != null && chat['unread_count'] > 0
                    ? Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${chat['unread_count']}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : null,
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
