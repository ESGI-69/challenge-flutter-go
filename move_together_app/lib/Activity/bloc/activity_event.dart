part of 'activity_bloc.dart';

@immutable
sealed class ActivityEvent {}

final class ActivitiesDataFetch extends ActivityEvent {
  final int tripId;

  ActivitiesDataFetch(this.tripId);
}
