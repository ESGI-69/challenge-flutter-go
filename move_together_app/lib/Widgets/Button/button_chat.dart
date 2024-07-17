import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ButtonChat extends StatelessWidget {
  final int tripId;
  final String tripName;

  const ButtonChat({
    super.key,
    required this.tripId,
    required this.tripName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed('chat',
            pathParameters: {'tripId': tripId.toString()},
            queryParameters: {'tripName': tripName});
      },
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Icon(
          Icons.chat_bubble,
          color: Theme.of(context).primaryColor,
          size: 20,
        ),
      ),
    );
  }
}
