part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

final class ChatDataFetch extends ChatEvent {
  final String chatId;

  ChatDataFetch(this.chatId);
}