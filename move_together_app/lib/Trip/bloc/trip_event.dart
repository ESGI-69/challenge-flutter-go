part of 'trip_bloc.dart';

@immutable
sealed class TripEvent {}

final class TripDataFetch extends TripEvent {
  final String tripId;

  TripDataFetch(this.tripId);
}