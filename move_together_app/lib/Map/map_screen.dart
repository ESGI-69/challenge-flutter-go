import 'dart:async';

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
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tripId = int.parse(GoRouterState.of(context).uri.pathSegments[0]);
    final Completer<GoogleMapController> mapController =
        Completer<GoogleMapController>();

    return BlocProvider(
        create: (context) => MapBloc(context)..add(MapDataFetch(tripId)),
        child: BlocBuilder<MapBloc, MapState>(builder: (context, state) {
          if (state is MapDataLoadingSuccess) {
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
              body: RefinedGoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  mapController.complete(controller);
                },
                accommodations: state.accommodations,
                activities: state.activities,
                transports: state.transports,
                type: RefinedGoogleMapType.fullPage,
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }));
  }
}
