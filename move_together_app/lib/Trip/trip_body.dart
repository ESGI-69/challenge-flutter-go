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
        if (featureProvider.isFeatureEnabled('transport'))
          TransportCard(
            tripId: trip.id,
            userHasEditPermission: trip.currentUserHasEditingRights(context),
            userIsOwner: trip.isCurrentUserOwner(context),
          ),
        if (featureProvider.isFeatureEnabled('accommodation'))
          AccommodationCard(
            tripId: trip.id,
            userHasEditPermission: trip.currentUserHasEditingRights(context),
            userIsOwner: trip.isCurrentUserOwner(context),
          ),
        if (featureProvider.isFeatureEnabled('photo'))
          PhotoCard(
            tripId: trip.id,
            userHasEditPermission: trip.currentUserHasEditingRights(context),
            userIsOwner: trip.isCurrentUserOwner(context),
          ),
        if (featureProvider.isFeatureEnabled('document'))
          DocumentCard(
            tripId: trip.id,
            userHasEditPermission: trip.currentUserHasEditingRights(context),
            userIsOwner: trip.isCurrentUserOwner(context),
          ),
        if (featureProvider.isFeatureEnabled('note'))
          NoteCard(
            tripId: trip.id,
            userHasEditPermission: trip.currentUserHasEditingRights(context),
            userIsOwner: trip.isCurrentUserOwner(context),
          ),
        if (featureProvider.isFeatureEnabled('activity'))
          ActivityCard(
            tripId: trip.id,
            userHasEditPermission: trip.currentUserHasEditingRights(context),
            userIsOwner: trip.isCurrentUserOwner(context),
          ),
      ],
    );
  }
}
