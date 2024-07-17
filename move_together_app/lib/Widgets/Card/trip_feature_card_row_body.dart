import 'package:flutter/material.dart';
import 'package:move_together_app/Widgets/Card/trip_feature_card_empty_body.dart';

class TripFeatureCardRowBody extends StatelessWidget {
  final bool isLoading;
  final int length;
  final String emptyMessage;
  final Widget? Function(BuildContext context, int index) itemBuilder;

  const TripFeatureCardRowBody({
    super.key,
    this.isLoading = false,
    this.length = 0,
    required this.emptyMessage,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(
          top: 6,
          bottom: 12,
          left: 16,
          right: 16,
        ),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : length == 0
                ? TripFeatureCardEmptyBody(message: emptyMessage)
                : ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 125),
                    child: ListView.separated(
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemCount: length,
                      itemBuilder: itemBuilder,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                    )));
  }
}
