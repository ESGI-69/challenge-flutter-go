import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:move_together_app/Backoffice/Trip/bloc/trips_bloc.dart';
import 'package:move_together_app/Backoffice/Trip/trip_row.dart';
import 'package:move_together_app/Backoffice/Widgets/navigation_bar_backoffice.dart';

class BackofficeTripsScreen extends StatefulWidget {
  const BackofficeTripsScreen({
    super.key
  });

  @override
  State<BackofficeTripsScreen> createState() => _BackofficeTripsScreenState();
}

class _BackofficeTripsScreenState extends State<BackofficeTripsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavigationBarBackoffice(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed('join');
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      body: BlocProvider(
          create: (context) => TripBloc(context)..add(TripsDataFetch()),
          child: BlocBuilder<TripBloc, TripsState>(
              builder: (context, state) {
                if (state is TripsDataLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is TripsDataLoadingError) {
                  return Center(
                    child: Text(state.errorMessage),
                  );
                } else if (state is TripsDataLoadingSuccess) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'LIST OF TRIPS',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF263238),
                          ),
                        ),
                        Flex(
                            direction: Axis.vertical,
                            children: state.trips.map((trip){
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TripRow(
                                  tripId: trip.id,
                                  onDelete: () => context.read<TripBloc>().add(TripDataDeleteTrip(trip)),
                                  name: trip.name,
                                  country: trip.country,
                                  city: trip.city,
                                  nbParticipants: (trip.participants.length),
                                ),
                              );
                            }).toList(),

                          ),
                      ],
                    ),
                  );
                }
                return const SizedBox();
              }
          )
      ),
    );
  }
}