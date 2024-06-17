import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ButtonChat extends StatelessWidget {
  final int tripId;

  const ButtonChat({
    super.key,
    required this.tripId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go('/trip/$tripId/chat');
      },
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withOpacity(0.3),
        ),
        child: const Icon(Icons.chat_bubble, color: Colors.black, size: 20),
      ),
    );
  }
}