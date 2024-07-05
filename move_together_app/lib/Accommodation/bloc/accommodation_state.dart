part of 'accommodation_bloc.dart';

@immutable
sealed class AccommodationState {}

final class AccommodationInitial extends AccommodationState {}

final class AccommodationDataLoading extends AccommodationState {}

final class AccommodationsDataLoadingSuccess extends AccommodationState {
  final List<Accommodation> accommodations;

  AccommodationsDataLoadingSuccess({required this.accommodations});
}

final class AccommodationsDataLoadingError extends AccommodationState {
  final String errorMessage;

  AccommodationsDataLoadingError({required this.errorMessage});
}
