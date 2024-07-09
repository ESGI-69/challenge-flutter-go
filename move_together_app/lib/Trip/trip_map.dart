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
    return BlocBuilder<AccommodationBloc, AccommodationState>(
      bloc: BlocProvider.of<AccommodationBloc>(context),
        builder: (context, state) {
          Set<Marker> markers = {};
          if (state is AccommodationsDataLoadingSuccess && state.accommodations.isNotEmpty) {
            markers = _createMarkers(state.accommodations);
            return Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.black12, width: 1),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(
                                  Icons.map,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                "Map",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 300,
                      width: double.infinity,
                      child: GoogleMap(
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(state.accommodations[0].latitude!, state.accommodations[0].longitude!),
                          zoom: 11.0,
                        ),
                        markers: markers,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is AccommodationsDataLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const SizedBox();
          }
      },
    );
  }
}