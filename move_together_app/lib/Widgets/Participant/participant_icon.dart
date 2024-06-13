import 'package:flutter/material.dart';
import 'package:move_together_app/core/models/participant.dart';

class ParticipantIcon extends StatelessWidget {
  final Participant participant;

  const ParticipantIcon({
    super.key,
    required this.participant,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      child: Center(
        child: Text(
          participant.username[0].toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}