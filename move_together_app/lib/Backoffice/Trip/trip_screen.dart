import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/Backoffice/Trip/bloc/trips_bloc.dart';
import 'package:move_together_app/Backoffice/Trip/trips_table.dart';
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
                  return SingleChildScrollView(
                    child: SizedBox(
                      width: double.infinity,
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
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TripsTable(
                              trips: state.trips,
                              deleteTrip: (trip) {
                                context.read<TripBloc>().add(TripDataDeleteTrip(trip));
                              },
                            ),
                          )
                        ],
                      ),
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