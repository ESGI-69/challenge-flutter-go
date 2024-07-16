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
        MapCard(tripId: trip.id, trip: trip),
        if (featureProvider.isFeatureEnabled(FeatureNames.transport))
          TransportCard(
            tripId: trip.id,
            userHasEditPermission: trip.currentUserHasEditingRights(context),
            userIsOwner: trip.isCurrentUserOwner(context),
            onRefresh: onRefresh,
          ),
        if (featureProvider.isFeatureEnabled(FeatureNames.accommodation))
          AccommodationCard(
            tripId: trip.id,
            userHasEditPermission: trip.currentUserHasEditingRights(context),
            userIsOwner: trip.isCurrentUserOwner(context),
            onRefresh: onRefresh,
          ),
        if (featureProvider.isFeatureEnabled(FeatureNames.photo))
          PhotoCard(
            tripId: trip.id,
            userHasEditPermission: trip.currentUserHasEditingRights(context),
            userIsOwner: trip.isCurrentUserOwner(context),
          ),
        if (featureProvider.isFeatureEnabled(FeatureNames.document))
          DocumentCard(
            tripId: trip.id,
            userHasEditPermission: trip.currentUserHasEditingRights(context),
            userIsOwner: trip.isCurrentUserOwner(context),
          ),
        if (featureProvider.isFeatureEnabled(FeatureNames.note))
          NoteCard(
            tripId: trip.id,
            userHasEditPermission: trip.currentUserHasEditingRights(context),
            userIsOwner: trip.isCurrentUserOwner(context),
          ),
        if (featureProvider.isFeatureEnabled(FeatureNames.activity))
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
