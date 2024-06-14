import 'package:flutter/material.dart';
import 'package:move_together_app/Widgets/Participant/participant_icon.dart';
import 'package:move_together_app/core/models/participant.dart';

class ParticipantIcons extends StatelessWidget {
  final List<Participant> participants;

  const ParticipantIcons({
    super.key,
    required this.participants,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: participants.map((participant) {
        return Container(
          margin: const EdgeInsets.only(right: 4),
          child: ParticipantIcon(
            participant: participant,
          ),
        );
      }).toList(),
    );
  }
}