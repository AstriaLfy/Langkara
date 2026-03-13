import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:langkara/services/chat_service.dart';
import 'package:langkara/models/message_model.dart';
import 'package:langkara/models/conversation_model.dart';

class ChatRepository {
  final ChatService chatService;

  ChatRepository(this.chatService);

  String? get currentUserId => chatService.currentUserId;

  Future<ConversationModel> getOrCreateConversation(String otherUserId) {
    return chatService.getOrCreateConversation(otherUserId);
  }

  Future<List<MessageModel>> getMessages(String conversationId) {
    return chatService.getMessages(conversationId);
  }

  Future<void> sendMessage({
    required String conversationId,
    required String message,
  }) {
    return chatService.sendMessage(
      conversationId: conversationId,
      message: message,
    );
  }

  RealtimeChannel subscribeToMessages(
    String conversationId,
    void Function(MessageModel) onNewMessage,
  ) {
    return chatService.subscribeToMessages(conversationId, onNewMessage);
  }

  Future<void> markMessagesAsRead(String conversationId) {
    return chatService.markMessagesAsRead(conversationId);
  }

  void unsubscribe(RealtimeChannel channel) {
    chatService.unsubscribe(channel);
  }

  Future<List<Map<String, dynamic>>> getConversations() {
    return chatService.getConversations();
  }
}
