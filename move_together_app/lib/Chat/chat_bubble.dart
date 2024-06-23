import 'package:flutter/material.dart';
import 'package:move_together_app/core/models/message.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
  final bool isOwnMessage;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isOwnMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isOwnMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.8,
          ),
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: isOwnMessage
                ? Theme.of(context).primaryColor
                : Colors.grey[200],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isOwnMessage)
                Text(
                  message.author.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              Text(message.content,
                  style: TextStyle(
                      color: isOwnMessage ? Colors.white : Colors.black)),
              Text(
                "${DateFormat.Md().format(message.createdAt)} ${DateFormat.Hm().format(message.createdAt)}",
                style: TextStyle(
                  fontSize: 10,
                  color: isOwnMessage ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
