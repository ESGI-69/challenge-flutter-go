import 'package:flutter/material.dart';
import 'package:move_together_app/Widgets/Participant/participant_icon.dart';
import 'package:move_together_app/core/models/participant.dart';

class ParticipantIcons extends StatelessWidget {
  final List<Participant> participants;
  final Function()? onTap;

  const ParticipantIcons({
    super.key,
    required this.participants,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 9),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
            ...participants.take(6).map((participant) {
            return Align(
              widthFactor: 0.5,
              child: ParticipantIcon(
              participant: participant,
              ),
            );
            }),
          onTap != null
              ? Align(
                  widthFactor: 0.5,
                  child: Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.add,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
        ]),
      ),
    );
  }
}
