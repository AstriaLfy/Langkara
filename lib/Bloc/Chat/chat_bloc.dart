import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:langkara/repository/chat_repository.dart';
import 'package:langkara/models/message_model.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository repository;
  RealtimeChannel? _channel;

  ChatBloc(this.repository) : super(ChatInitial()) {

    on<InitChat>((event, emit) async {
      try {
        emit(ChatLoading());

        final conversation =
            await repository.getOrCreateConversation(event.otherUserId);

        final messages =
            await repository.getMessages(conversation.id);

        final currentUserId = repository.currentUserId ?? '';

        emit(ChatReady(
          conversationId: conversation.id,
          messages: messages,
          currentUserId: currentUserId,
        ));

        await repository.markMessagesAsRead(conversation.id);

        _channel = repository.subscribeToMessages(
          conversation.id,
          (newMessage) {
            add(NewMessageReceived(newMessage));
          },
        );
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });

    on<SendMessage>((event, emit) async {
      final currentState = state;
      if (currentState is! ChatReady) return;

      try {
        await repository.sendMessage(
          conversationId: currentState.conversationId,
          message: event.message,
        );
      } catch (e) {
        emit(ChatError("Gagal mengirim pesan: ${e.toString()}"));
        emit(currentState);
      }
    });

    on<NewMessageReceived>((event, emit) async {
      final currentState = state;
      if (currentState is! ChatReady) return;

      final updatedMessages = [
        ...currentState.messages,
        event.message,
      ];
      emit(currentState.copyWith(messages: updatedMessages));

      if (event.message.senderId != currentState.currentUserId) {
        await repository.markMessagesAsRead(
            currentState.conversationId);
      }
    });
  }

  @override
  Future<void> close() {
    if (_channel != null) {
      repository.unsubscribe(_channel!);
    }
    return super.close();
  }
}
