part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

final class HomeDataFetch extends HomeEvent {}

final class HomeDataFetchSingleTrip extends HomeEvent {
  final int tripId;

  HomeDataFetchSingleTrip(this.tripId);
}

final class HomeDataLeaveTrip extends HomeEvent {
  final Trip trip;

  HomeDataLeaveTrip(this.trip);
}

final class HomeDataDeleteTrip extends HomeEvent {
  final Trip trip;

  HomeDataDeleteTrip(this.trip);
}