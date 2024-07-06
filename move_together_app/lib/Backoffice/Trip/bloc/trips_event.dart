part of 'trips_bloc.dart';

@immutable
sealed class TripsEvent {}

final class TripsDataFetch extends TripsEvent {}

final class TripDataLeaveTrip extends TripsEvent {
  final Trip trips;

  TripDataLeaveTrip(this.trips);
}

final class TripDataDeleteTrip extends TripsEvent {
  final Trip trip;

  TripDataDeleteTrip(this.trip);
}