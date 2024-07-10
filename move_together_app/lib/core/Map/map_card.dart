import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:move_together_app/Widgets/Card/trip_feature_card.dart';

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
  BitmapDescriptor? customIcon;

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
      height: 32,
      'assets/images/pins/hotel_pin.png',
    ).then((BitmapDescriptor bitmapDescriptor) {
      setState(() {
        customIcon = bitmapDescriptor;
      });
    });
  }

  @override
  void dispose() {
    customIcon = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TripFeatureCard(
      title: 'Carte',
      type: TripFeatureCardType.full,
      isLoading: false,
      icon: Icons.pin_drop,
      child: GoogleMap(
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
        mapType: MapType.hybrid,
        initialCameraPosition: const CameraPosition(
          target: LatLng((48.8566 + 43.2965) / 2, (2.3522 + 5.3698) / 2),
          zoom: ((48.8566 - 43.2965) + (5.3698 - 2.3522)) / 2,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('1'),
            position: const LatLng(48.8566, 2.3522),
            infoWindow: const InfoWindow(title: 'Paris', snippet: 'The most beautiful city in the world'),
            icon: customIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
            
          ),
          Marker(
            markerId: const MarkerId('2'),
            position: const LatLng(43.2965, 5.3698),
            infoWindow: const InfoWindow(title: 'Marseille', snippet: 'The second most beautiful city in the world'),
            icon: customIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
          )
        },
        polylines: {
          const Polyline(
            polylineId: PolylineId('1'),
            points: [
              LatLng(48.8566, 2.3522),
              LatLng(43.2965, 5.3698),
            ],
            color: Colors.orange,
            width: 3,
          )
        },
        myLocationButtonEnabled: false,
      ),
    );
  }
}