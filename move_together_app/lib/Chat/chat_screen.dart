import 'package:flutter/material.dart';
import 'package:move_together_app/Chat/chat_app_bar.dart';

class ChatScreen extends StatelessWidget {
  // final Chat chat;

  const ChatScreen({
    super.key,
    //required this.chat,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: ChatAppBar(tripName: 'test'),
      body: Text(
        'Welcome to the chat!(placeholder page)',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
