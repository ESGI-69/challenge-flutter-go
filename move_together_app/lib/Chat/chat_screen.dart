import 'package:flutter/material.dart';
import 'package:move_together_app/Trip/trip_app_bar.dart';
import 'package:move_together_app/core/models/trip.dart';

class ChatScreen extends StatelessWidget {
  // final Chat chat;

  const ChatScreen({
    super.key,
    //required this.chat,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text(
        'Welcome to the chat!(placeholder page)',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
