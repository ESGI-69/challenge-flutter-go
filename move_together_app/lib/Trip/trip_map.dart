import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/Accommodation/bloc/accommodation_bloc.dart';

class TripMap extends StatefulWidget {
  final int tripId;

  const TripMap({
    super.key,
    required this.tripId,
  });

  @override
  State<TripMap> createState() => _TripMapState();
}

class _TripMapState extends State<TripMap> {
  GoogleMapController? mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  Set<Marker> _createMarkers(List<dynamic> accommodations) {
    return accommodations.map((accommodation) {
      return Marker(
        markerId: MarkerId(accommodation.id.toString()),
        position: LatLng(accommodation.latitude, accommodation.longitude),
        infoWindow: InfoWindow(
          title: "${accommodation.name} - ${accommodation.address}", 
          snippet: "${accommodation.latitude}, ${accommodation.longitude}"
        ),
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AccommodationBloc(context)..add(AccommodationsDataFetch(widget.tripId)),
      child: BlocBuilder<AccommodationBloc, AccommodationState>(
        builder: (context, state) {
          if (state is AccommodationsDataLoadingSuccess) {
            return SizedBox(
              height: 300,
              width: double.infinity,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                    target: state.accommodations.isNotEmpty
                      ? LatLng(state.accommodations[0].latitude!, state.accommodations[0].longitude!)
                      : const LatLng(48.866667, 2.333333),
                  zoom: 11.0,
                ),
                markers: _createMarkers(state.accommodations),
              ),
            );
          } else {
            return Center(
              child: state is AccommodationsDataLoading
                  ? const CircularProgressIndicator()
                  : const Text('Error loading accommodations'),
            );
          }
        },
      ),
    );
  }
}