part of 'chat_bloc.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatReady extends ChatState {
  final String conversationId;
  final List<MessageModel> messages;
  final String currentUserId;

  ChatReady({
    required this.conversationId,
    required this.messages,
    required this.currentUserId,
  });

  ChatReady copyWith({List<MessageModel>? messages}) {
    return ChatReady(
      conversationId: conversationId,
      messages: messages ?? this.messages,
      currentUserId: currentUserId,
    );
  }
}

class ChatError extends ChatState {
  final String message;
  ChatError(this.message);
}
