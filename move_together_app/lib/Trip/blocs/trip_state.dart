part of 'trip_bloc.dart';

@immutable
sealed class TripState {}

final class TripInitial extends TripState {}

final class TripDataLoading extends TripState {}

final class TripDataLoadingSuccess extends TripState {
  final Trip trip;

  TripDataLoadingSuccess({required this.trip});
}

final class TripDataLoadingError extends TripState {
  final String errorMessage;

  TripDataLoadingError({required this.errorMessage});
}