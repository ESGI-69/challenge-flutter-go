import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:move_together_app/Participant/bloc/participant_bloc.dart';
import 'package:move_together_app/Widgets/Participant/participant_icon.dart';

class ParticipantScreen extends StatelessWidget {
  const ParticipantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tripId = GoRouterState.of(context).uri.pathSegments[1];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Participants'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GoRouter.of(context).go('/trips/$tripId/join');
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
                return ListView.builder(
                  itemCount: state.participants.length,
                  itemBuilder: (context, index) {
                    final participant = state.participants[index];
                    return ListTile(
                      leading: ParticipantIcon(participant: participant),
                      title: Row(
                        textBaseline: TextBaseline.alphabetic,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        children: [
                          Text(participant.username),
                          const SizedBox(width: 8),
                          Text(
                            participant.tripRole.toString().split('.').last,
                            style: TextStyle(
                              color: Theme.of(context).hintColor,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
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