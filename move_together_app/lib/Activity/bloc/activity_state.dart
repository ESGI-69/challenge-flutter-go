part of 'activity_bloc.dart';

@immutable
sealed class ActivityState {}

final class ActivityInitial extends ActivityState {}

final class ActivitiesDataLoading extends ActivityState {}

final class ActivitiesDataLoadingSuccess extends ActivityState {
  final List<Activity> activities;

  ActivitiesDataLoadingSuccess({required this.activities});
}

final class ActivitiesDataLoadingError extends ActivityState {
  final String errorMessage;

  ActivitiesDataLoadingError({required this.errorMessage});
}
