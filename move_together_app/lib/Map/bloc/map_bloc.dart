import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/core/models/accommodation.dart';
import 'package:move_together_app/core/models/activity.dart';
import 'package:move_together_app/core/models/transport.dart';
import 'package:move_together_app/core/services/accommodation_service.dart';
import 'package:move_together_app/core/services/activity_service.dart';
import 'package:move_together_app/core/services/transport_service.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc(BuildContext context) : super(MapInitial()) {
    final transportService = TransportService(context.read<AuthProvider>());
    final accommodationService = AccommodationService(context.read<AuthProvider>());
    final activityService = ActivityService(context.read<AuthProvider>());
    
    on<MapDataFetch>((event, emit) async {
      emit(MapDataLoading());
      
      var results = await Future.wait([
        transportService.getAll(event.tripId),
        accommodationService.getAll(event.tripId),
        activityService.getAll(event.tripId),
      ]);

      var transportsWithGeoPos = (results[0] as List<Transport>).where((transport) => transport.hasValidGeolocation).toList();
      var accommodationsWithGeoPos = (results[1] as List<Accommodation>).where((accommodation) => accommodation.hasValidGeolocation).toList();
      var activitiesWithGeoPos = (results[2] as List<Activity>).where((activity) => activity.hasValidGeolocation).toList();

      emit(MapDataLoadingSuccess(
        transports: transportsWithGeoPos,
        accommodations: accommodationsWithGeoPos,
        activities: activitiesWithGeoPos,
      ));
    });
  }
}
