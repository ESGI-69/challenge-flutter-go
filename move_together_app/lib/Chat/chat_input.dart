import 'package:flutter/material.dart';

class ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isButtonEnabled;
  final Function(String) onSendPressed;
  final VoidCallback onAttachPressed;

  const ChatInput({
    super.key,
    required this.controller,
    required this.isButtonEnabled,
    required this.onSendPressed,
    required this.onAttachPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Enter your message',
                // prefixIcon: IconButton(
                //   icon: const Icon(Icons.attach_file),
                //   onPressed: onAttachPressed,
                // ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          Container(
            decoration: BoxDecoration(
              color: isButtonEnabled
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.send,
                color: Colors.white,
              ),
              onPressed:
                  isButtonEnabled ? () => onSendPressed(controller.text) : null,
            ),
          ),
        ],
      ),
    );
  }
}
