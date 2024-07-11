import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:move_together_app/Map/bloc/map_bloc.dart';
import 'package:move_together_app/Widgets/Card/trip_feature_card.dart';
import 'package:move_together_app/utils/map.dart';

class MapCard extends StatefulWidget {
  final int tripId;

  const MapCard({
    super.key,
    required this.tripId,
  });

  @override
  State<MapCard> createState() => _MapCardState();
}

class _MapCardState extends State<MapCard> {
  BitmapDescriptor? hotelPin;
  BitmapDescriptor? transportStartPin;
  BitmapDescriptor? transportEndPin;
  BitmapDescriptor? activityPin;
  var iconHeight = 48.0;

  @override
  void initState() {
    addCustomMapPins();
    super.initState();
  }

  void addCustomMapPins() {
    BitmapDescriptor.asset(
      const ImageConfiguration(
        devicePixelRatio: 2.5,
      ),
      height: iconHeight,
      'assets/images/pins/hotel_pin.png',
    ).then((BitmapDescriptor bitmapDescriptor) {
      setState(() {
        hotelPin = bitmapDescriptor;
      });
    });

    BitmapDescriptor.asset(
      const ImageConfiguration(
        devicePixelRatio: 2.5,
      ),
      height: iconHeight,
      'assets/images/pins/start_pin.png',
    ).then((BitmapDescriptor bitmapDescriptor) {
      setState(() {
        transportStartPin = bitmapDescriptor;
      });
    });

    BitmapDescriptor.asset(
      const ImageConfiguration(
        devicePixelRatio: 2.5,
      ),
      height: iconHeight,
      'assets/images/pins/end_pin.png',
    ).then((BitmapDescriptor bitmapDescriptor) {
      setState(() {
        transportEndPin = bitmapDescriptor;
      });
    });

    BitmapDescriptor.asset(
      const ImageConfiguration(
        devicePixelRatio: 2.5,
      ),
      height: iconHeight,
      'assets/images/pins/activity_pin.png',
    ).then((BitmapDescriptor bitmapDescriptor) {
      setState(() {
        activityPin = bitmapDescriptor;
      });
    });
  }

  final Set<Marker> _markers = <Marker>{};

  @override
  void dispose() {
    hotelPin = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MapBloc(context)..add(MapDataFetch(widget.tripId)),
      child: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          if (state is MapDataLoadingSuccess) {
            for (var activity in state.activities) {
              _markers.add(
                Marker(
                  markerId: MarkerId(activity.id.toString()),
                  position: LatLng(activity.latitude, activity.longitude),
                  infoWindow: InfoWindow(
                    title: activity.name,
                    snippet: activity.description,
                    // bottom center
                    anchor: const Offset(0.5, 0),
                  ),
                  icon: activityPin ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
                ),
              );
            }

            for (var accommodation in state.accommodations) {
              _markers.add(
                Marker(
                  markerId: MarkerId(accommodation.id.toString()),
                  position: LatLng(accommodation.latitude, accommodation.longitude),
                  infoWindow: InfoWindow(
                    title: accommodation.name,
                    snippet: accommodation.address,
                  ),
                  icon: hotelPin ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
                ),
              );
            }

            return TripFeatureCard(
              title: 'Carte',
              type: TripFeatureCardType.full,
              isLoading: false,
              icon: Icons.pin_drop,
              onTitleTap: () {
                context.pushNamed('map', pathParameters: {'tripId': widget.tripId.toString()});
              },
              child: GoogleMap(
                zoomControlsEnabled: false,
                zoomGesturesEnabled: false,
                scrollGesturesEnabled: false,
                rotateGesturesEnabled: false,
                tiltGesturesEnabled: false,
                mapType: MapType.hybrid,
                initialCameraPosition: getMapCameraPositionFromMarkers(_markers, true),
                markers: _markers,
                // polylines: {
                //   const Polyline(
                //     polylineId: PolylineId('1'),
                //     points: [
                //       LatLng(48.8566, 2.3522),
                //       LatLng(43.2965, 5.3698),
                //     ],
                //     color: Colors.orange,
                //     width: 3,
                //   )
                // },
                myLocationButtonEnabled: false,
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
        }
      )
    );
  }
}