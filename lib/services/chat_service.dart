import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:langkara/models/message_model.dart';
import 'package:langkara/models/conversation_model.dart';

class ChatService {
  final SupabaseClient _client = Supabase.instance.client;

  String? get currentUserId => _client.auth.currentUser?.id;

  Future<ConversationModel> getOrCreateConversation(String otherUserId) async {
    final userId = currentUserId;
    if (userId == null) throw Exception("User tidak terautentikasi");

    final existing = await _client
        .from('conversations')
        .select()
        .or('and(user1.eq.$userId,user2.eq.$otherUserId),and(user1.eq.$otherUserId,user2.eq.$userId)')
        .maybeSingle();

    if (existing != null) {
      return ConversationModel.fromJson(existing);
    }

    final newConvo = await _client
        .from('conversations')
        .insert({
          'user1': userId,
          'user2': otherUserId,
        })
        .select()
        .single();

    return ConversationModel.fromJson(newConvo);
  }

  Future<List<MessageModel>> getMessages(String conversationId) async {
    final response = await _client
        .from('messages')
        .select()
        .eq('conversation_id', conversationId)
        .order('created_at', ascending: true);

    return (response as List)
        .map((e) => MessageModel.fromJson(e))
        .toList();
  }

  Future<void> sendMessage({
    required String conversationId,
    required String message,
  }) async {
    final userId = currentUserId;
    if (userId == null) throw Exception("User tidak terautentikasi");

    await _client.from('messages').insert({
      'conversation_id': conversationId,
      'sender_id': userId,
      'message': message,
    });
  }

  RealtimeChannel subscribeToMessages(
    String conversationId,
    void Function(MessageModel) onNewMessage,
  ) {
    final channel = _client
        .channel('messages:$conversationId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'conversation_id',
            value: conversationId,
          ),
          callback: (payload) {
            final newMessage =
                MessageModel.fromJson(payload.newRecord);
            onNewMessage(newMessage);
          },
        )
        .subscribe();

    return channel;
  }

  Future<void> markMessagesAsRead(String conversationId) async {
    final userId = currentUserId;
    if (userId == null) return;

    await _client
        .from('messages')
        .update({'is_read': true})
        .eq('conversation_id', conversationId)
        .neq('sender_id', userId)
        .eq('is_read', false);
  }

  void unsubscribe(RealtimeChannel channel) {
    _client.removeChannel(channel);
  }

  /// Get all conversations for the current user with other user info and last message.
  Future<List<Map<String, dynamic>>> getConversations() async {
    final userId = currentUserId;
    if (userId == null) return [];

    // Fetch all conversations involving the current user
    final conversations = await _client
        .from('conversations')
        .select()
        .or('user1.eq.$userId,user2.eq.$userId')
        .order('created_at', ascending: false);

    final List<Map<String, dynamic>> result = [];

    for (final conv in conversations) {
      final convId = conv['id'] as String;
      final otherUserId =
          conv['user1'] == userId ? conv['user2'] : conv['user1'];

      // Fetch the other user's profile
      Map<String, dynamic>? otherProfile;
      try {
        otherProfile = await _client
            .from('profiles')
            .select('username, avatar_url')
            .eq('id', otherUserId)
            .maybeSingle();
      } catch (_) {
        otherProfile = null;
      }

      // Fetch the last message in this conversation
      Map<String, dynamic>? lastMessage;
      try {
        lastMessage = await _client
            .from('messages')
            .select()
            .eq('conversation_id', convId)
            .order('created_at', ascending: false)
            .limit(1)
            .maybeSingle();
      } catch (_) {
        lastMessage = null;
      }

      // Count unread messages
      int unreadCount = 0;
      try {
        final unreadRows = await _client
            .from('messages')
            .select('id')
            .eq('conversation_id', convId)
            .neq('sender_id', userId)
            .eq('is_read', false);
        unreadCount = (unreadRows as List).length;
      } catch (_) {
        unreadCount = 0;
      }

      result.add({
        'conversation_id': convId,
        'other_user_id': otherUserId,
        'other_username': otherProfile?['username'] ?? 'Anonim',
        'other_avatar_url': otherProfile?['avatar_url'],
        'last_message': lastMessage?['message'],
        'last_message_time': lastMessage?['created_at'],
        'last_message_sender_id': lastMessage?['sender_id'],
        'unread_count': unreadCount,
      });
    }

    // Sort by last message time (most recent first)
    result.sort((a, b) {
      final aTime = a['last_message_time'] as String?;
      final bTime = b['last_message_time'] as String?;
      if (aTime == null && bTime == null) return 0;
      if (aTime == null) return 1;
      if (bTime == null) return -1;
      return bTime.compareTo(aTime);
    });

    return result;
  }
}
