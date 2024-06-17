part of 'trip_bloc.dart';

@immutable
sealed class TripEvent {}

final class TripDataFetch extends TripEvent {
  final String tripId;

  TripDataFetch(this.tripId);
}

final class TripEdit extends TripEvent {
  final String tripId;
  final String? name;
  final String? country;
  final String? city;
  final DateTime? startDate;
  final DateTime? endDate;

  TripEdit(
    this.tripId,
    {
      this.name,
      this.country,
      this.city,
      this.startDate,
      this.endDate,
    }
  );
}