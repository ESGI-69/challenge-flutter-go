part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

final class ChatDataFetch extends ChatEvent {
  final String tripId;

  ChatDataFetch(this.tripId);
}

final class ChatDataSendMessage extends ChatEvent {
  final String tripId;
  final MessageToSend message;

  ChatDataSendMessage(this.tripId, this.message);
}