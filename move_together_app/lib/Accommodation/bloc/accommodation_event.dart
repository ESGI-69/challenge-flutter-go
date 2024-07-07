part of 'accommodation_bloc.dart';

@immutable
sealed class AccommodationEvent {}

final class AccommodationsDataFetch extends AccommodationEvent {
  final int tripId;

  AccommodationsDataFetch(this.tripId);
}
