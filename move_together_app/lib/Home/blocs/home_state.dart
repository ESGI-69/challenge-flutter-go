part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeDataLoading extends HomeState {}

final class HomeDataLoadingSuccess extends HomeState {
  final List<Trip> trips;

  HomeDataLoadingSuccess({required this.trips});
}

final class HomeDataLoadingError extends HomeState {
  final String errorMessage;

  HomeDataLoadingError({required this.errorMessage});
}