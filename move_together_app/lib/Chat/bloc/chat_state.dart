part of 'chat_bloc.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

final class ChatDataLoading extends ChatState {}

final class ChatDataLoadingSuccess extends ChatState {
  final List<Message> messages;
  final ChatSendMessageState sendMessageState;

  ChatDataLoadingSuccess({
    required this.messages,
    this.sendMessageState = const ChatSendMessageInitial(),
  });

  ChatDataLoadingSuccess copyWith({
    List<Message>? messages,
    ChatSendMessageState? sendMessageState,
  }) {
    return ChatDataLoadingSuccess(
      messages: messages ?? this.messages,
      sendMessageState: sendMessageState ?? this.sendMessageState,
    );
  }

  ChatDataLoadingSuccess addMessage(Message message) {
    final updatedMessages = List<Message>.from(messages)..add(message);
    return copyWith(messages: updatedMessages);
  }
}

final class ChatDataLoadingError extends ChatState {
  final String errorMessage;

  ChatDataLoadingError({required this.errorMessage});
}

@immutable
sealed class ChatSendMessageState {
  const ChatSendMessageState();
}

final class ChatSendMessageInitial extends ChatSendMessageState {
  const ChatSendMessageInitial();
}

final class ChatSendMessageLoading extends ChatSendMessageState {}

final class ChatSendMessageSuccess extends ChatSendMessageState {
  final Message message;

  const ChatSendMessageSuccess({required this.message});
}

final class ChatSendMessageError extends ChatSendMessageState {
  final String errorMessage;

  const ChatSendMessageError({required this.errorMessage});
}
