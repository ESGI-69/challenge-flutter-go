import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:move_together_app/Participant/bloc/participant_bloc.dart';
import 'package:move_together_app/Participant/participant_add_modal.dart';
import 'package:move_together_app/Participant/participant_row.dart';
import 'package:move_together_app/core/models/participant.dart';

class ParticipantScreen extends StatelessWidget {
  const ParticipantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tripId = int.parse(GoRouterState.of(context).uri.pathSegments[1]);
    final inviteCode = GoRouterState.of(context).uri.queryParameters['inviteCode'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Participants'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) => ParticipantAddModal(
              inviteCode: inviteCode ?? '',
            ),
          );
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: BlocProvider(
          create: (context) => ParticipantBloc(context)..add(ParticipantDataFetch(tripId)),
          child: BlocBuilder<ParticipantBloc, ParticipantState>(
            builder: (context, state) {
              if (state is ParticipantDataLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is ParticipantDataLoadingError) {
                return Center(
                  child: Text(state.errorMessage),
                );
              } else if (state is ParticipantDataLoadingSuccess) {
                final me = state.participants.firstWhere((participant) => participant.isMe(context), orElse: () => Participant(id: -1, username: '', tripRole: ParticipantTripRole.VIEWER));
                final iAmTheOwner = me.tripRole == ParticipantTripRole.OWNER;

                return ListView.builder(
                  itemCount: state.participants.length,
                  itemBuilder: (context, index) {
                    final participant = state.participants[index];

                    return ParticipantRow(
                      participant: participant,
                      showTrailingButton: iAmTheOwner,
                      tripId: tripId,
                      onAction: () {
                        context.read<ParticipantBloc>().add(ParticipantDataFetch(tripId));
                      },
                    );
                  },
                );
              }
              return const SizedBox();
            },
          )
        )
      )
    );
  }
}