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
}
