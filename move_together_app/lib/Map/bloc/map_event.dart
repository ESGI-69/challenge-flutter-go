part of 'map_bloc.dart';

@immutable
sealed class MapEvent {}

final class MapDataFetch extends MapEvent {
  final int tripId;

  MapDataFetch(this.tripId);
}
