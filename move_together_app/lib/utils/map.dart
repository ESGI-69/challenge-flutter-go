import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';

CameraPosition getMapCameraPositionFromMarkers(Set<Marker> markers, bool isCard) {
  if (markers.isEmpty) {
    return const CameraPosition(
      target: LatLng(0, 0),
      zoom: 0,
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

  return latZoom < lngZoom ? latZoom : lngZoom;
}

double latRad(double lat) {
  final double sin = lat * 3.141592653589793 / 180;
  final double radX2 = 2 * atan(exp(sin)) - 3.141592653589793 / 2;
  return radX2;
}

double zoom(double fraction, double padding) {
  return log(1 / fraction) / log(2) - log(padding) / log(2);
}