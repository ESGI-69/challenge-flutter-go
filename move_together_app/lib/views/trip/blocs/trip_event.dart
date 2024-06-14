part of 'trip_bloc.dart';

@immutable
sealed class TripEvent {}

final class TripDataLoaded extends TripEvent {}

final class TripDataLoading extends TripEvent {}

final class TripDataLoadingSucess extends TripEvent {
  final List<Trip> trips;

  TripDataLoadingSucess(this.trips);

}

final class TripDataLoadFailed extends TripEvent {}

final class TripDataCreated extends TripEvent {}

final class TripDataCreating extends TripEvent {}

final class TripDataCreateFailed extends TripEvent {}