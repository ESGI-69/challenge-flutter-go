import 'package:flutter/widgets.dart';
import 'package:move_together_app/Accommodation/accommodation_card.dart';
import 'package:move_together_app/Activity/activity_card.dart';
import 'package:move_together_app/Photo/photo_card.dart';
import 'package:move_together_app/Document/document_card.dart';
import 'package:move_together_app/Transport/transport_card.dart';
import 'package:move_together_app/Note/note_card.dart';
import 'package:move_together_app/core/models/trip.dart';
import 'package:move_together_app/Trip/trip_map.dart';

class TripBody extends StatelessWidget {
  final Trip trip;

  const TripBody({required this.trip, super.key});

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
          ),
          const SizedBox(height: 16),
          PhotoCard(
            tripId: trip.id,
            userHasEditPermission: trip.currentUserHasEditingRights(context),
            userIsOwner: trip.isCurrentUserOwner(context),
          ),
          const SizedBox(height: 16),
          DocumentCard(
            tripId: trip.id,
            userHasEditPermission: trip.currentUserHasEditingRights(context),
            userIsOwner: trip.isCurrentUserOwner(context)
          ),
          const SizedBox(height: 16),
          NoteCard(
            tripId: trip.id,
            userHasEditPermission: trip.currentUserHasEditingRights(context),
            userIsOwner: trip.isCurrentUserOwner(context),
          ),
          const SizedBox(height: 16),
          ActivityCard(
            tripId: trip.id,
            userHasEditPermission: trip.currentUserHasEditingRights(context),
            userIsOwner: trip.isCurrentUserOwner(context),
          ),
          TripMap(tripId: trip.id),
        ],
      ),
    );
  }
}
