part of 'chat_bloc.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

final class ChatDataLoading extends ChatState {}

final class ChatDataLoadingSuccess extends ChatState {
  final List<Message> messages;

  ChatDataLoadingSuccess({required this.messages});
}

final class ChatDataLoadingError extends ChatState {
  final String errorMessage;

  ChatDataLoadingError({required this.errorMessage});
}