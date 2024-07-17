part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent {}

class ChatDataFetch extends ChatEvent {
  final String tripId;

  ChatDataFetch(this.tripId);
}

class ChatDataSendMessage extends ChatEvent {
  final String tripId;
  final MessageToSend message;

  ChatDataSendMessage(this.tripId, this.message);
}

class ChatDataReceived extends ChatEvent {
  final String message;

  ChatDataReceived(this.message);
}
