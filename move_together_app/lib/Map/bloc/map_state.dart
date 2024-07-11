part of 'map_bloc.dart';

@immutable
sealed class MapState {}

final class MapInitial extends MapState {}

final class MapDataLoading extends MapState {}

final class MapDataLoadingSuccess extends MapState {
  final List<Transport> transports;
  final List<Accommodation> accommodations;
  final List<Activity> activities;

  MapDataLoadingSuccess({
    required this.transports,
    required this.accommodations,
    required this.activities,
  });
}

final class MapDataLoadingError extends MapState {
  final String errorMessage;

  MapDataLoadingError({required this.errorMessage});
}
