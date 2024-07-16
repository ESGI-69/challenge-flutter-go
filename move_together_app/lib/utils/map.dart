import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:move_together_app/core/models/accommodation.dart';
import 'dart:math';

import 'package:move_together_app/core/models/activity.dart';
import 'package:move_together_app/core/models/transport.dart';

CameraPosition getMapCameraPositionFromMarkers(Set<Marker> markers, bool isCard, LatLng initialCameraPosition) {
  if (markers.isEmpty) {
    return CameraPosition(
      target: initialCameraPosition,
      zoom: 12,
    );
  }

  final LatLngBounds bounds = getBoundsFromMarkers(markers);
  return CameraPosition(
    target: LatLng(
      bounds.southwest.latitude + (bounds.northeast.latitude - bounds.southwest.latitude) / 2,
      bounds.southwest.longitude + (bounds.northeast.longitude - bounds.southwest.longitude) / 2,
    ),
    zoom: getZoomLevel(bounds, isCard ? 2 : 0.8),
  );
}

LatLngBounds getBoundsFromMarkers(Set<Marker> markers) {
  double minLat = 90;
  double maxLat = -90;
  double minLng = 180;
  double maxLng = -180;

  for (final Marker marker in markers) {
    final double lat = marker.position.latitude;
    final double lng = marker.position.longitude;
    minLat = lat < minLat ? lat : minLat;
    maxLat = lat > maxLat ? lat : maxLat;
    minLng = lng < minLng ? lng : minLng;
    maxLng = lng > maxLng ? lng : maxLng;
  }

  return LatLngBounds(
    southwest: LatLng(minLat, minLng),
    northeast: LatLng(maxLat, maxLng),
  );
}

double getZoomLevel(LatLngBounds bounds, double padding) {
  final double latFraction = (latRad(bounds.northeast.latitude) - latRad(bounds.southwest.latitude)) / 3.141592653589793;
  final double lngDiff = bounds.northeast.longitude - bounds.southwest.longitude;
  final double lngFraction = ((lngDiff < 0) ? (lngDiff + 360) : lngDiff) / 360;

  final double latZoom = zoom(latFraction, padding);
  final double lngZoom = zoom(lngFraction, padding);

  final zoomLevel = latZoom < lngZoom ? latZoom : lngZoom;

  return zoomLevel > 15 ? 15 : zoomLevel;
}

double latRad(double lat) {
  final double sin = lat * 3.141592653589793 / 180;
  final double radX2 = 2 * atan(exp(sin)) - 3.141592653589793 / 2;
  return radX2;
}

double zoom(double fraction, double padding) {
  return log(1 / fraction) / log(2) - log(padding) / log(2);
}

enum RefinedGoogleMapType {
  fullPage,
  card,
  appBar,
}

class RefinedGoogleMap extends StatefulWidget {
  final List<Activity> activities;
  final List<Accommodation> accommodations;
  final List<Transport> transports;
  final RefinedGoogleMapType type;
  final LatLng initialCameraPosition;
  final Function(GoogleMapController)? onMapCreated;

  const RefinedGoogleMap({
    super.key,
    required this.activities,
    required this.accommodations,
    required this.transports,
    required this.type,
    this.initialCameraPosition = const LatLng(0, 0),
    this.onMapCreated,
  });

  @override
  State<RefinedGoogleMap> createState() => _RefinedGoogleMapState();
}

class _RefinedGoogleMapState extends State<RefinedGoogleMap> {
  BitmapDescriptor? hotelPin;
  BitmapDescriptor? transportStartPin;
  BitmapDescriptor? transportEndPin;
  BitmapDescriptor? activityPin;
  BitmapDescriptor? meetingPin;
  double iconHeight = 48.0;
  bool isMapReady = false;

  Future<void> addCustomMapPins() async {
    List<BitmapDescriptor> bitmaps = await Future.wait([
      BitmapDescriptor.asset(
        const ImageConfiguration(
          devicePixelRatio: 2.5,
        ),
        height: iconHeight,
        'assets/images/pins/hotel_pin.png',
      ),

      BitmapDescriptor.asset(
        const ImageConfiguration(
          devicePixelRatio: 2.5,
        ),
        height: iconHeight,
        'assets/images/pins/start_pin.png',
      ),

      BitmapDescriptor.asset(
        const ImageConfiguration(
          devicePixelRatio: 2.5,
        ),
        height: iconHeight,
        'assets/images/pins/end_pin.png',
      ),

      BitmapDescriptor.asset(
        const ImageConfiguration(
          devicePixelRatio: 2.5,
        ),
        height: iconHeight,
        'assets/images/pins/activity_pin.png',
      ),

      BitmapDescriptor.asset(
        const ImageConfiguration(
          devicePixelRatio: 2.5,
        ),
        height: iconHeight,
        'assets/images/pins/meeting_pin.png',
      ),
    ]);

    setState(() {
      hotelPin = bitmaps[0];
      transportStartPin = bitmaps[1];
      transportEndPin = bitmaps[2];
      activityPin = bitmaps[3];
      meetingPin = bitmaps[4];
    });
  }

  void generatePoints({
    required List<Activity> activities,
    required List<Accommodation> accommodations,
    required List<Transport> transports,
    required RefinedGoogleMapType mapType,
  }) {
    final Set<Marker> tempMarker = <Marker>{};
    final Set<Polyline> tempPolyline = <Polyline>{};
    final bool disabledTapOnMarker = mapType == RefinedGoogleMapType.card;

    for (var activity in activities) {
      tempMarker.add(
        Marker(
          consumeTapEvents: disabledTapOnMarker,
          markerId: MarkerId('activity-${activity.id}'),
          position: LatLng(activity.latitude, activity.longitude),
          infoWindow: InfoWindow(
            title: activity.name,
            snippet: activity.description,
            // bottom center
            anchor: const Offset(0.5, 0),
          ),
          icon: activityPin ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }

    for (var accommodation in accommodations) {
      tempMarker.add(
        Marker(
          consumeTapEvents: disabledTapOnMarker,
          markerId: MarkerId('accomodation-${accommodation.id}'),
          position: LatLng(accommodation.latitude, accommodation.longitude),
          infoWindow: InfoWindow(
            title: accommodation.name,
            snippet: accommodation.address,
          ),
          icon: hotelPin ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }

    for (var transport in transports) {
      tempMarker.add(
        Marker(
          consumeTapEvents: disabledTapOnMarker,
          markerId: MarkerId('transport-start-${transport.id}'),
          position: LatLng(transport.startLatitude, transport.startLongitude),
          infoWindow: InfoWindow(
            title: transport.startAddress,
            snippet: transport.startDate.toString(),
          ),
          icon: transportStartPin ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );

      tempMarker.add(
        Marker(
          consumeTapEvents: disabledTapOnMarker,
          markerId: MarkerId('transport-end-${transport.id}'),
          position: LatLng(transport.endLatitude, transport.endLongitude),
          infoWindow: InfoWindow(
            title: transport.endAddress,
            snippet: transport.endDate.toString(),
          ),
          icon: transportEndPin ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );

      tempPolyline.add(
        Polyline(
          polylineId: PolylineId('transport-stat-end-${transport.id}'),
          points: [
            LatLng(transport.startLatitude, transport.startLongitude),
            LatLng(transport.endLatitude, transport.endLongitude),
          ],
          color: Colors.orange,
          width: 4,
        ),
      );

      if (transport.hasValidMeetingGeolocation) {
        tempMarker.add(
          Marker(
            consumeTapEvents: disabledTapOnMarker,
            markerId: MarkerId('transport-meeting-${transport.id}'),
            position: LatLng(transport.meetingLatitude, transport.meetingLongitude),
            infoWindow: InfoWindow(
              title: transport.meetingAddress ?? 'Meeting Point',
              snippet: transport.meetingTime?.toString() ?? 'Meeting Time',
            ),
            icon: meetingPin ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          ),
        );

        if (!transport.isMeetingPointFarFromStartPoint) {
          tempPolyline.add(
            Polyline(
              polylineId: PolylineId('transport-meeting-start-${transport.id}'),
              patterns: <PatternItem>[PatternItem.dash(300), PatternItem.gap(300)],
              points: [
                LatLng(transport.startLatitude, transport.startLongitude),
                LatLng(transport.meetingLatitude, transport.meetingLongitude),
              ],
              color: Colors.orange,
              width: 4,
            ),
          );
        }
      }
    }

    setState(() {
      _markers = tempMarker;
      _polylines = tempPolyline;
    });
  }

  Set<Marker> _markers = <Marker>{};
  Set<Polyline> _polylines = <Polyline>{};

  @override
  void dispose() {
    hotelPin = null;
    transportStartPin = null;
    transportEndPin = null;
    activityPin = null;
    super.dispose();
  }

  void initMap() async {
    await addCustomMapPins();
    generatePoints(
      activities: widget.activities,
      accommodations: widget.accommodations,
      transports: widget.transports,
      mapType: widget.type,
    );
    setState(() {
      isMapReady = true;
    });
  }

  @override
  void initState() {
    initMap();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!isMapReady) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (widget.type == RefinedGoogleMapType.fullPage || widget.type == RefinedGoogleMapType.appBar) {
      return GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          widget.onMapCreated?.call(controller);
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
        mapType: MapType.hybrid,
        initialCameraPosition: getMapCameraPositionFromMarkers(_markers, RefinedGoogleMapType.appBar == widget.type, widget.initialCameraPosition),
        markers: _markers,
        polylines: _polylines,
        myLocationButtonEnabled: false,
      );
    } else if (widget.type == RefinedGoogleMapType.card) {
      return GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          widget.onMapCreated?.call(controller);
        },
        zoomControlsEnabled: false,
        zoomGesturesEnabled: false,
        scrollGesturesEnabled: false,
        rotateGesturesEnabled: false,
        tiltGesturesEnabled: false,
        mapType: MapType.hybrid,
        initialCameraPosition: getMapCameraPositionFromMarkers(_markers, true, widget.initialCameraPosition),
        markers: _markers,
        polylines: _polylines,
        myLocationButtonEnabled: false,
      );
    } else {
      return const SizedBox();
    }
  }
}