part of 'transport_bloc.dart';

@immutable
sealed class TransportEvent {}

final class TransportsDataFetch extends TransportEvent {
  final int tripId;

  TransportsDataFetch(this.tripId);
}
