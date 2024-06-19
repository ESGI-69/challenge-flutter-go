part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

final class ChatDataFetch extends ChatEvent {
  final String tripId;
  // log in console the tripId


  ChatDataFetch(this.tripId){
    print('ChatDataFetch: $tripId');
  }

}
