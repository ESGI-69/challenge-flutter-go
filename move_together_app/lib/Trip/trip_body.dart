import 'package:flutter/widgets.dart';
import 'package:move_together_app/Transport/transport_card.dart';

class TripBody extends StatelessWidget {
  final String tripId;

  const TripBody({
    required this.tripId,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          TransportCard(tripId: tripId),
        ],
      ),
    );
  }
}