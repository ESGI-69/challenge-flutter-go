import 'package:flutter/material.dart';
import 'package:move_together_app/core/models/message.dart';

class ChatBody extends StatefulWidget {
  final List<Message> messages;
  final int userId;
  final ScrollController scrollController;

  const ChatBody({
    super.key,
    required this.messages,
    required this.userId,
    required this.scrollController,
  });

  @override
  ChatBodyState createState() => ChatBodyState();
}

class ChatBodyState extends State<ChatBody> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: widget.scrollController,
            itemCount: widget.messages.length,
            itemBuilder: (context, index) {
              final message = widget.messages[index];
              final isOwnMessage = message.author.id == widget.userId;
              return Row(
                mainAxisAlignment: isOwnMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: isOwnMessage ? Colors.blue : Colors.grey,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(message.content),
                  ),
                ],
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Entrez votre message...',
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  // Send the message
                  // You need to implement this part based on how your app sends messages
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}