part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

final class HomeDataFetch extends HomeEvent {}

final class HomeDataLeaveTrip extends HomeEvent {
  final Trip trip;

  HomeDataLeaveTrip(this.trip);
}