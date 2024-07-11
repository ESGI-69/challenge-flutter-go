part of 'trip_bloc.dart';

@immutable
sealed class TripEvent {}

final class TripDataFetch extends TripEvent {
  final int tripId;

  TripDataFetch(this.tripId);
}

final class TripDataRefreshTrip extends TripEvent {
  final int tripId;

  TripDataRefreshTrip(this.tripId);
}

final class TripDataCreateTrip extends TripEvent {
  final Trip trip;

  TripDataCreateTrip(this.trip);
}
