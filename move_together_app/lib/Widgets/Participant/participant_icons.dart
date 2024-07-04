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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 9),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: participants.map((participant) {
          return Align(
            widthFactor: 0.5,
            child: ParticipantIcon(
              participant: participant,
            ),
          );
        }).toList(),
      ),
    );
  }
}