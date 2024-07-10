part of 'features_bloc.dart';

@immutable
sealed class FeaturesEvent {}

final class FeaturesDataFetch extends FeaturesEvent {}

final class FeatureDataLeaveFeature extends FeaturesEvent {
  final Feature features;

  FeatureDataLeaveFeature(this.features);
}

final class FeatureDataPatchFeature extends FeaturesEvent {
  final Feature feature;

  FeatureDataPatchFeature(this.feature);
}