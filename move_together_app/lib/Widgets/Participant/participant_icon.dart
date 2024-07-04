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
    return Container(
      height: 36,
      width: 36,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        shape: BoxShape.circle,
        border: Border.all(
          strokeAlign: BorderSide.strokeAlignInside,
          color: Colors.white,
          width: 3,
        ),
      ),
      child: Center(
        child: Text(
          participant.username[0].toUpperCase(),
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}