import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:move_together_app/core/models/participant.dart';
import 'package:uuid/uuid.dart';

class ParticipantIcon extends StatelessWidget {
  final Participant participant;
  final uuid = const Uuid();

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
        image: participant.profilePicturePath != null && participant.profilePicturePath != '' ? DecorationImage(
          image: NetworkImage('${dotenv.env['API_ADDRESS']}${participant.profilePictureUri}?v=${uuid.v4()}'),
          fit: BoxFit.cover,
        ) : null,
      ),
      child: participant.profilePicturePath == null || participant.profilePicturePath == '' ? Center(
        child: Text(
          participant.username[0].toUpperCase(),
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ) : null,
    );
  }
}