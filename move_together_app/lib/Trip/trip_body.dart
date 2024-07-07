import 'package:flutter/widgets.dart';
import 'package:move_together_app/Accommodation/accommodation_card.dart';
import 'package:move_together_app/Transport/transport_card.dart';
import 'package:move_together_app/core/models/trip.dart';

class TripBody extends StatelessWidget {
  final Trip trip;

  const TripBody({
    required this.trip,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          TransportCard(
            tripId: trip.id,
            userHasEditPermission: trip.currentUserHasEditingRights(context),
            userIsOwner: trip.isCurrentUserOwner(context),
          ),
          const SizedBox(height: 16),
          AccommodationCard(
            tripId: trip.id,
            userHasEditPermission: trip.currentUserHasEditingRights(context),
            userIsOwner: trip.isCurrentUserOwner(context),
          )
        ],
      ),
    );
  }
}