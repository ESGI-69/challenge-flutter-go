import 'package:flutter/widgets.dart';
import 'package:move_together_app/Accommodation/accommodation_card.dart';
import 'package:move_together_app/Activity/activity_card.dart';
import 'package:move_together_app/Photo/photo_card.dart';
import 'package:move_together_app/Document/document_card.dart';
import 'package:move_together_app/Transport/transport_card.dart';
import 'package:move_together_app/Note/note_card.dart';
import 'package:move_together_app/core/models/trip.dart';
import 'package:move_together_app/Map/map_card.dart';
import 'package:move_together_app/core/models/feature.dart';

Map<FeatureNames, String> featureNames = {
  FeatureNames.document: 'document',
  FeatureNames.auth: 'auth',
  FeatureNames.chat: 'chat',
  FeatureNames.trip: 'trip',
  FeatureNames.note: 'note',
  FeatureNames.transport: 'transport',
  FeatureNames.accommodation: 'accommodation',
  FeatureNames.user: 'user',
  FeatureNames.photo: 'photo',
  FeatureNames.activity: 'activity',
};

class TripBody extends StatelessWidget {
  final Trip trip;
  final Function() onRefresh;

  const TripBody({
    required this.trip,
    super.key,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        MapCard(tripId: trip.id),
        TransportCard(
          tripId: trip.id,
          userHasEditPermission: trip.currentUserHasEditingRights(context),
          userIsOwner: trip.isCurrentUserOwner(context),
          onRefresh: onRefresh,
        ),
        AccommodationCard(
          tripId: trip.id,
          userHasEditPermission: trip.currentUserHasEditingRights(context),
          userIsOwner: trip.isCurrentUserOwner(context),
          onRefresh: onRefresh,
        ),
        PhotoCard(
          tripId: trip.id,
          userHasEditPermission: trip.currentUserHasEditingRights(context),
          userIsOwner: trip.isCurrentUserOwner(context),
        ),
        DocumentCard(
          tripId: trip.id,
          userHasEditPermission: trip.currentUserHasEditingRights(context),
          userIsOwner: trip.isCurrentUserOwner(context),
        ),
        NoteCard(
          tripId: trip.id,
          userHasEditPermission: trip.currentUserHasEditingRights(context),
          userIsOwner: trip.isCurrentUserOwner(context),
        ),
        ActivityCard(
          tripId: trip.id,
          userHasEditPermission: trip.currentUserHasEditingRights(context),
          userIsOwner: trip.isCurrentUserOwner(context),
          onRefresh: onRefresh,
        ),
      ],
    );
  }
}
