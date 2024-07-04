part of 'participant_bloc.dart';

@immutable
sealed class ParticipantState {}

final class ParticipantInitial extends ParticipantState {}

final class ParticipantDataLoading extends ParticipantState {}

final class ParticipantDataLoadingSuccess extends ParticipantState {
  final List<Participant> participants;

  ParticipantDataLoadingSuccess({required this.participants});
}

final class ParticipantDataLoadingError extends ParticipantState {
  final String errorMessage;

  ParticipantDataLoadingError({required this.errorMessage});
}
