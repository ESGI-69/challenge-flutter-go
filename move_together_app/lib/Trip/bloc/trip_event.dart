part of 'trip_bloc.dart';

@immutable
sealed class TripEvent {}

final class TripDataFetch extends TripEvent {
  final String tripId;

  TripDataFetch(this.tripId);
}

final class TripDataCreateTrip extends TripEvent {
  final Trip trip;

  TripDataCreateTrip(this.trip);
}
