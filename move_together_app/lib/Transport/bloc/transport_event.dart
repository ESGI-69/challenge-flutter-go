part of 'transport_bloc.dart';

@immutable
sealed class TransportEvent {}

final class TransportsDataFetch extends TransportEvent {
  final String tripId;

  TransportsDataFetch(this.tripId);
}
