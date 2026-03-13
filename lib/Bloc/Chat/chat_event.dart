part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

class InitChat extends ChatEvent {
  final String otherUserId;
  InitChat(this.otherUserId);
}

class SendMessage extends ChatEvent {
  final String message;
  SendMessage(this.message);
}

class NewMessageReceived extends ChatEvent {
  final MessageModel message;
  NewMessageReceived(this.message);
}
