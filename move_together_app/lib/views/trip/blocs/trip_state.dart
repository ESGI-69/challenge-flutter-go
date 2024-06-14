part of 'trip_bloc.dart';

@immutable
sealed class TripState {}

final class TripDataLoaded extends TripState {}

final class TripDataLoading extends TripState {}

final class TripDataLoadingSucess extends TripState {}

final class TripDataLoadFailed extends TripState {}

final class TripDataCreated extends TripState {}

final class TripDataCreating extends TripState {}

final class TripDataCreateFailed extends TripState {}

