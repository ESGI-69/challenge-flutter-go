part of 'participant_bloc.dart';

@immutable
sealed class ParticipantEvent {}

final class ParticipantDataFetch extends ParticipantEvent {
  final int tripId;

  ParticipantDataFetch(this.tripId);
}
