part of 'trips_bloc.dart';

@immutable
sealed class TripsState {}

final class TripsInitial extends TripsState {}

final class TripsDataLoading extends TripsState {}

final class TripsDataLoadingSuccess extends TripsState {
  final List<Trip> trips;

  TripsDataLoadingSuccess({required this.trips});
}

final class TripsDataLoadingError extends TripsState {
  final String errorMessage;

  TripsDataLoadingError({required this.errorMessage});
}
