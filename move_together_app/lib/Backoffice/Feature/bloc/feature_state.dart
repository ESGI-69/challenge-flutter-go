part of 'feature_bloc.dart';

@immutable
sealed class FeaturesState {}

final class FeaturesInitial extends FeaturesState {}

final class FeaturesDataLoading extends FeaturesState {}

final class FeaturesDataLoadingSuccess extends FeaturesState {
  final List<Feature> features;

  FeaturesDataLoadingSuccess({required this.features});
}

final class FeaturesDataLoadingError extends FeaturesState {
  final String errorMessage;

  FeaturesDataLoadingError({required this.errorMessage});
}