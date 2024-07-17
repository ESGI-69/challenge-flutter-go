import 'package:flutter/material.dart';
import 'package:move_together_app/Widgets/Card/trip_feature_card_empty_body.dart';

class TripFeatureCardGridBody extends StatelessWidget {
  final bool isLoading;
  final int length;
  final String emptyMessage;
  final Widget? Function(BuildContext context, int index) itemBuilder;

  const TripFeatureCardGridBody({
    super.key,
    this.isLoading = false,
    this.length = 0,
    this.emptyMessage = 'No elements',
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator.adaptive(),
          )
        : length == 0
            ? Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 16,
                ),
                child: TripFeatureCardEmptyBody(message: emptyMessage),
              )
            : ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 1,
                    mainAxisSpacing: 1,
                  ),
                  itemCount: length,
                  itemBuilder: itemBuilder,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                ),
              );
  }
}
