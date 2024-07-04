import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:move_together_app/Participant/bloc/participant_bloc.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/Widgets/Participant/participant_icon.dart';
import 'package:move_together_app/core/models/participant.dart';
import 'package:move_together_app/core/services/participant_service.dart';

class ParticipantScreen extends StatelessWidget {
  const ParticipantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tripId = int.parse(GoRouterState.of(context).uri.pathSegments[1]);
    final participantService = ParticipantService(context.read<AuthProvider>());

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
                final me = state.participants.firstWhere((participant) => participant.isMe(context), orElse: () => Participant(id: -1, username: '', tripRole: ParticipantTripRole.VIEWER));
                final iAmTheOwner = me.tripRole == ParticipantTripRole.OWNER;

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
                          const SizedBox(width: 8),
                          participant.isMe(context)
                            ? Text(
                              '(me)',
                              style: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontSize: 10,
                              ),
                            )
                            : const SizedBox(),
                        ],
                      ),
                      trailing: !iAmTheOwner 
                        ? const SizedBox()
                        : participant.isMe(context)
                          ? const SizedBox()
                          : PopupMenuButton(
                            itemBuilder: (context) {
                              return [
                                participant.tripRole == ParticipantTripRole.VIEWER
                                  ? const PopupMenuItem(
                                      value: 'promote',
                                      child: Text('Accorder les droits d\'édition'),
                                    )
                                  : const PopupMenuItem(
                                      value: 'demote',
                                      child: Text('Retirer les droits d\'édition'),
                                    ),
                                const PopupMenuItem(
                                  value: 'kick',
                                  child: Text(
                                    'Exclure',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ];
                            },
                            onSelected: (value) async {
                              if (value == 'kick') {
                                await participantService.remove(tripId, participant.id);
                              } else if (value == 'promote') {
                                await participantService.changeRole(tripId, participant.id, ParticipantTripRole.EDITOR);
                              } else if (value == 'demote') {
                                await participantService.changeRole(tripId, participant.id, ParticipantTripRole.VIEWER);
                              }
                              context.read<ParticipantBloc>().add(ParticipantDataFetch(tripId));
                            },
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