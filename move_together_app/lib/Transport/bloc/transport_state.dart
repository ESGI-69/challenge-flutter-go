part of 'transport_bloc.dart';

@immutable
sealed class TransportState {}

final class TransportInitial extends TransportState {}

final class TransportsDataLoading extends TransportState {}

final class TransportsDataLoadingSuccess extends TransportState {
  final List<Transport> transports;

  TransportsDataLoadingSuccess({required this.transports});
}

final class TransportsDataLoadingError extends TransportState {
  final String errorMessage;

  TransportsDataLoadingError({required this.errorMessage});
}
