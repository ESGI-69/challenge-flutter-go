part of 'trip_bloc.dart';

@immutable
sealed class TripEvent {}

final class TripDataCreateTrip extends TripEvent {
  final Trip trip;

  TripDataCreateTrip(this.trip);
}
