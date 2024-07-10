part of 'feature_bloc.dart';

@immutable
sealed class FeaturesEvent {}

final class FeaturesDataFetch extends FeaturesEvent {}

final class FeatureDataPatchFeature extends FeaturesEvent {
  final Feature feature;

  FeatureDataPatchFeature(this.feature);
}