import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:move_together_app/Map/bloc/map_bloc.dart';
import 'package:move_together_app/Widgets/Card/trip_feature_card.dart';
import 'package:move_together_app/core/models/trip.dart';
import 'package:move_together_app/utils/map.dart';

class MapCard extends StatelessWidget {
  final int tripId;
  final Trip trip;

  const MapCard({
    super.key,
    required this.tripId,
    required this.trip,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => MapBloc(context)..add(MapDataFetch(tripId)),
        child: BlocBuilder<MapBloc, MapState>(builder: (context, state) {
          if (state is MapDataLoadingSuccess) {
            return TripFeatureCard(
              title: 'Carte',
              type: TripFeatureCardType.full,
              isLoading: false,
              icon: Icons.pin_drop,
              onTitleTap: () {
                context.pushNamed('map', pathParameters: {
                  'tripId': tripId.toString()
                }, queryParameters: {
                  'lat': trip.latLng.latitude.toString(),
                  'lng': trip.latLng.longitude.toString(),
                });
              },
              child: Stack(
                children: [
                  RefinedGoogleMap(
                    activities: state.activities,
                    accommodations: state.accommodations,
                    transports: state.transports,
                    type: RefinedGoogleMapType.card,
                    initialCameraPosition: trip.latLng,
                  ),
                  GestureDetector(
                    onTap: () {
                      context.pushNamed('map', pathParameters: {
                        'tripId': tripId.toString()
                      }, queryParameters: {
                        'lat': trip.latLng.latitude.toString(),
                        'lng': trip.latLng.longitude.toString(),
                      });
                    },
                    behavior: HitTestBehavior.translucent,
                  ),
                ],
              ),
            );
          } else {
            return TripFeatureCard(
              title: 'Carte',
              type: TripFeatureCardType.full,
              isLoading: state is MapDataLoading,
              icon: Icons.pin_drop,
            );
          }
        }));
  }
}
