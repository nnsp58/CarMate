import '../models/message_model.dart';
import '../core/constants/supabase_constants.dart';
import 'supabase_service.dart';

class ChatService {
  /// Get or create a chat between two users for a ride/booking
  static Future<String> getOrCreateChat({
    required String otherUserId,
    String? rideId,
    String? bookingId,
  }) async {
    try {
      final currentUserId = SupabaseService.currentUserId;
      if (currentUserId == null) throw Exception('User not authenticated');

      // Check if chat already exists
      // Using explicit participant filter
      var existingChatQuery = SupabaseService.client
          .from(SupabaseConstants.chatsTable)
          .select()
          .or('and(participant_1.eq.$currentUserId,participant_2.eq.$otherUserId),and(participant_1.eq.$otherUserId,participant_2.eq.$currentUserId)');

      if (rideId != null) {
        existingChatQuery = existingChatQuery.eq('ride_id', rideId);
      }
      if (bookingId != null) {
        existingChatQuery = existingChatQuery.eq('booking_id', bookingId);
      }

      final existingChat = await existingChatQuery.maybeSingle();

      if (existingChat != null) {
        return existingChat['id'] as String;
      }

      // Create new chat
      final chatData = {
        'participant_1': currentUserId,
        'participant_2': otherUserId,
        'ride_id': rideId,
        'booking_id': bookingId,
        'last_message': 'Conversation started',
        'last_message_at': DateTime.now().toIso8601String(),
      };

      final response = await SupabaseService.client
          .from(SupabaseConstants.chatsTable)
          .insert(chatData)
          .select('id')
          .single();

      return response['id'] as String;
    } catch (e) {
      throw Exception('Failed to get/create chat: $e');
    }
  }

  /// Send a message
  static Future<void> sendMessage({
    required String chatId,
    required String text,
  }) async {
    try {
      final currentUserId = SupabaseService.currentUserId;
      if (currentUserId == null) throw Exception('User not authenticated');

      await SupabaseService.client
          .from(SupabaseConstants.messagesTable)
          .insert({
            'chat_id': chatId,
            'sender_id': currentUserId,
            'text': text,
          });

      // Update chat's last message
      await SupabaseService.client
          .from(SupabaseConstants.chatsTable)
          .update({
            'last_message': text,
            'last_message_at': DateTime.now().toIso8601String(),
          })
          .eq('id', chatId);
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  /// Get messages for a chat
  static Stream<List<MessageModel>> getMessages({
    required String chatId,
  }) {
    return SupabaseService.client
        .from(SupabaseConstants.messagesTable)
        .stream(primaryKey: ['id'])
        .eq('chat_id', chatId)
        .order('created_at', ascending: true)
        .map((data) => data.map((json) => MessageModel.fromJson(json)).toList());
  }

  /// Get user's chats enriched with participant info
  static Future<List<Map<String, dynamic>>> getMyChats({
    required String userId,
  }) async {
    try {
      final response = await SupabaseService.client
          .from(SupabaseConstants.chatsTable)
          .select('''
            *,
            participant_1_profile:users!participant_1(full_name, photo_url),
            participant_2_profile:users!participant_2(full_name, photo_url),
            rides(from_location, to_location)
          ''')
          .or('participant_1.eq.$userId,participant_2.eq.$userId')
          .order('last_message_at', ascending: false, nullsFirst: false);

      return response.map((chat) {
        final bool isP1Me = chat['participant_1'] == userId;
        final otherUser = isP1Me ? chat['participant_2_profile'] : chat['participant_1_profile'];
        
        return {
          ...chat,
          'other_user_name': otherUser?['full_name'] ?? 'User',
          'other_user_photo': otherUser?['photo_url'],
          'ride_route': chat['rides'] != null 
            ? '${chat['rides']['from_location']} → ${chat['rides']['to_location']}'
            : null,
          'unread_count': 0, // Count logic could be added if needed
        };
      }).toList();
    } catch (e) {
      throw Exception('Failed to get chats: $e');
    }
  }

  /// Mark messages as read in a chat
  static Future<void> markAsRead({
    required String chatId,
    required String userId,
  }) async {
    try {
      await SupabaseService.client
          .from(SupabaseConstants.messagesTable)
          .update({'is_read': true})
          .eq('chat_id', chatId)
          .neq('sender_id', userId);
    } catch (e) {
      throw Exception('Failed to mark messages as read: $e');
    }
  }

  /// Delete a chat (optional feature)
  static Future<void> deleteChat({
    required String chatId,
    required String userId,
  }) async {
    try {
      // Check if user is participant
      final chat = await SupabaseService.client
          .from(SupabaseConstants.chatsTable)
          .select()
          .eq('id', chatId)
          .single();

      if (chat['participant_1'] != userId && chat['participant_2'] != userId) {
        throw Exception('Not authorized to delete this chat');
      }

      // Delete messages first (cascade should handle this, but being explicit)
      await SupabaseService.client
          .from(SupabaseConstants.messagesTable)
          .delete()
          .eq('chat_id', chatId);

      // Delete chat
      await SupabaseService.client
          .from(SupabaseConstants.chatsTable)
          .delete()
          .eq('id', chatId);
    } catch (e) {
      throw Exception('Failed to delete chat: $e');
    }
  }
}
