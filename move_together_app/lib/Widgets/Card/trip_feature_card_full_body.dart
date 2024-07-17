import 'package:flutter/material.dart';
import 'package:move_together_app/Widgets/Card/trip_feature_card_empty_body.dart';

class TripFeatureCardFullBody extends StatelessWidget {
  final bool isLoading;
  final Widget? child;

  const TripFeatureCardFullBody({
    super.key,
    this.isLoading = false,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator.adaptive(),
          )
        : ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200),
            child: child ??
                const TripFeatureCardEmptyBody(message: 'No map provided'),
          );
  }
}
