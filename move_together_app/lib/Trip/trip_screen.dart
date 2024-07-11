import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:move_together_app/Participant/participant_info.dart';
import 'package:move_together_app/Trip/bloc/trip_bloc.dart';
import 'package:move_together_app/Trip/trip_app_bar.dart';
import 'package:move_together_app/Trip/trip_body.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TripScreen extends StatelessWidget {
  const TripScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final tripId = GoRouterState.of(context).uri.pathSegments[1];

    return BlocProvider(
      create: (context) => TripBloc(context)..add(TripDataFetch(int.parse(tripId))),
      child: BlocBuilder<TripBloc, TripState>(builder: (context, state) {
        if (state is TripDataLoading) {
          return Scaffold(
            appBar: TripAppBar(
              isLoading: true,
              name: '',
              startDate: DateTime.now(),
              endDate: DateTime.now(),
              participants: const [],
              onNameUpdate: (newName) {},
              onDateUpdate: (firstDate, secondDate) {},
              imageUrl: '',
              tripId: 0,
              totalPrice: 0.0,
              onParticipantsTap: () {},
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
            extendBodyBehindAppBar: true,
            appBar: TripAppBar(
              name: state.trip.name,
              startDate: state.trip.startDate,
              endDate: state.trip.endDate,
              participants: state.trip.participants,
              tripId: state.trip.id,
              onNameUpdate: (newName) {
                context.read<TripBloc>().add(TripDataFetch(
                  state.trip.id,
                ));
              },
              onDateUpdate: (firstDate, secondDate) {
                context.read<TripBloc>().add(TripDataFetch(
                  state.trip.id,
                ));
              },
              imageUrl:  "${dotenv.env['API_ADDRESS']}/trips/${state.trip.id}/banner/download",
              userHasEditRights: state.trip.currentUserHasEditingRights(context),
              onParticipantsTap: () async {
                await showCupertinoModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) => ParticipantInfo(
                    tripId: state.trip.id,
                    inviteCode: state.trip.inviteCode,
                  )
                );
                context.read<TripBloc>().add(TripDataFetch(
                  state.trip.id,
                ));
              },
              totalPrice: state.trip.totalPrice,
            ),
            body: TripBody(
              trip: state.trip,
              onRefresh: () {
                context.read<TripBloc>().add(TripDataFetch(
                  state.trip.id,
                ));
              },
            ),
          );
        }
        {
          return const Text('Unhandled state');
        }
      })
    );
  }
}
