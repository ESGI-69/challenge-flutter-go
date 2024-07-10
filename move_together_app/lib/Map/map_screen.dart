import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:move_together_app/Map/bloc/map_bloc.dart';
import 'package:move_together_app/Widgets/Button/button_back.dart';
import 'package:move_together_app/utils/map.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
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
    final tripId = int.parse(GoRouterState.of(context).uri.pathSegments[1]);
    final Completer<GoogleMapController> mapController = Completer<GoogleMapController>();

    return BlocProvider(
      create: (context) => MapBloc(context)..add(MapDataFetch(tripId)),
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

            return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarBrightness: Brightness.light,
                ),
                backgroundColor: Colors.transparent,
                leading: const Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Row(
                    children: [
                      ButtonBack(),
                    ],
                  ),
                ),
              ),
              body: GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  mapController.complete(controller);
                },
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                ),
                zoomControlsEnabled: false,
                zoomGesturesEnabled: true,
                scrollGesturesEnabled: true,
                compassEnabled: true,
                rotateGesturesEnabled: true,
                mapToolbarEnabled: true,
                tiltGesturesEnabled: true,
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>> {
                  Factory<OneSequenceGestureRecognizer> (
                    () => EagerGestureRecognizer(),
                  ),
                },
                initialCameraPosition: getMapCameraPositionFromMarkers(_markers, false),
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
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      )
    );
  }
}
