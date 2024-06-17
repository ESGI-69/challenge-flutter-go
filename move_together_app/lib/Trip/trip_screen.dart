import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:move_together_app/Trip/bloc/trip_bloc.dart';
import 'package:move_together_app/Trip/trip_app_bar.dart';

class TripScreen extends StatelessWidget {
  const TripScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final tripId = GoRouterState.of(context).uri.pathSegments[1];

    return BlocProvider(
      create: (context) => TripBloc()..add(TripDataFetch(tripId)),
      child: BlocBuilder<TripBloc, TripState>(
        builder: (context, state) {
          if (state is TripDataLoading) {
            return Scaffold(
              appBar: TripAppBar(
                isLoading: true,
                name: '',
                startDate: DateTime.now(),
                endDate: DateTime.now(),
                participants: const [],
                onNameUpdate: (newName) {},
                imageUrl: '',
              ),
              body: const Center(
                child: CircularProgressIndicator.adaptive(),
              )
            );
          } else if (state is TripDataLoadingError) {
            return Center(
              child: Text(state.errorMessage),
            );
          } else if (state is TripDataLoadingSuccess) {
            return Scaffold(
              appBar: TripAppBar(
                name: state.trip.name,
                startDate: state.trip.startDate,
                endDate: state.trip.endDate,
                participants: state.trip.participants,
                onNameUpdate: (newName) {
                  context.read<TripBloc>().add(TripEdit(
                    tripId,
                    name: newName,
                  ));
                },
                imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a8/Tour_Eiffel_Wikimedia_Commons.jpg/260px-Tour_Eiffel_Wikimedia_Commons.jpg',
              ),
              body: const Text(
                'Welcome to the trip!(qsdsqdqsdqsd)',
                style: TextStyle(fontSize: 24),
              ),
            );
          } {
            return const Text('Unhandled state');
          }
        }
      )
    );
  }
}
