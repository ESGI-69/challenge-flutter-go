import 'package:flutter/widgets.dart';
import 'package:move_together_app/Accommodation/accommodation_card.dart';
import 'package:move_together_app/Activity/activity_card.dart';
import 'package:move_together_app/Photo/photo_card.dart';
import 'package:move_together_app/Document/document_card.dart';
import 'package:move_together_app/Transport/transport_card.dart';
import 'package:move_together_app/Note/note_card.dart';
import 'package:move_together_app/core/models/trip.dart';
import 'package:move_together_app/Map/map_card.dart';
import 'package:provider/provider.dart';
import 'package:move_together_app/Provider/feature_provider.dart';
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
    var featureProvider = Provider.of<FeatureProvider>(context);
    return ListView(
      children: [
        // if (featureProvider.isFeatureEnabled('map'))
          MapCard(tripId: trip.id),
        if (featureNames[FeatureNames.transport] == 'transport')
          TransportCard(
            tripId: trip.id,
            userHasEditPermission: trip.currentUserHasEditingRights(context),
            userIsOwner: trip.isCurrentUserOwner(context),
          ),
        if (featureNames[FeatureNames.accommodation] == 'accommodation')
          AccommodationCard(
            tripId: trip.id,
            userHasEditPermission: trip.currentUserHasEditingRights(context),
            userIsOwner: trip.isCurrentUserOwner(context),
          ),
        if (featureNames[FeatureNames.photo] == 'photo')
          PhotoCard(
            tripId: trip.id,
            userHasEditPermission: trip.currentUserHasEditingRights(context),
            userIsOwner: trip.isCurrentUserOwner(context),
          ),
        if (featureNames[FeatureNames.document] == 'document')
          DocumentCard(
            tripId: trip.id,
            userHasEditPermission: trip.currentUserHasEditingRights(context),
            userIsOwner: trip.isCurrentUserOwner(context),
          ),
        if (featureNames[FeatureNames.note] == 'note')
          NoteCard(
            tripId: trip.id,
            userHasEditPermission: trip.currentUserHasEditingRights(context),
            userIsOwner: trip.isCurrentUserOwner(context),
          ),
        if (featureNames[FeatureNames.activity] == 'activity')
          ActivityCard(
            tripId: trip.id,
            userHasEditPermission: trip.currentUserHasEditingRights(context),
            userIsOwner: trip.isCurrentUserOwner(context),
          ),
      ],
    );
  }
}
