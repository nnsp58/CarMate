import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/message_model.dart';
import '../services/chat_service.dart';
import 'auth_provider.dart';


// My Chats Provider
final myChatsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final currentUser = ref.watch(currentUserProvider);
  return currentUser.maybeWhen(
    data: (user) async {
      if (user != null) {
        return await ChatService.getMyChats(userId: user.id);
      }
      return [];
    },
    orElse: () => [],
  );
});

// Chat Messages Provider - real-time stream
final chatMessagesProvider = StreamProvider.family<List<MessageModel>, String>((ref, chatId) {
  return ChatService.getMessages(chatId: chatId);
});

// Chat Actions Provider
final chatActionsProvider = Provider<ChatActions>((ref) {
  return ChatActions(ref);
});

class ChatActions {
  ChatActions(Ref ref);

  Future<String> getOrCreateChat({
    required String otherUserId,
    String? rideId,
    String? bookingId,
  }) async {
    return await ChatService.getOrCreateChat(
      otherUserId: otherUserId,
      rideId: rideId,
      bookingId: bookingId,
    );
  }

  Future<void> sendMessage({
    required String chatId,
    required String text,
  }) async {
    await ChatService.sendMessage(chatId: chatId, text: text);
  }

  Future<void> markAsRead({
    required String chatId,
    required String userId,
  }) async {
    await ChatService.markAsRead(chatId: chatId, userId: userId);
  }

  Future<void> deleteChat({
    required String chatId,
    required String userId,
  }) async {
    await ChatService.deleteChat(chatId: chatId, userId: userId);
  }
}
