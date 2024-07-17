import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/Widgets/Participant/participant_icon.dart';
import 'package:move_together_app/core/models/participant.dart';
import 'package:move_together_app/core/services/participant_service.dart';

class ParticipantRow extends StatelessWidget {
  final int tripId;
  final bool showTrailingButton;
  final Participant participant;
  final Function() onAction;

  const ParticipantRow({
    super.key,
    required this.tripId,
    required this.showTrailingButton,
    required this.participant,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final participantService = ParticipantService(context.read<AuthProvider>());

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
      trailing: !showTrailingButton
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
                      await participantService.changeRole(
                          tripId, participant.id, ParticipantTripRole.EDITOR);
                    } else if (value == 'demote') {
                      await participantService.changeRole(
                          tripId, participant.id, ParticipantTripRole.VIEWER);
                    }
                    onAction();
                  },
                ),
    );
  }
}
