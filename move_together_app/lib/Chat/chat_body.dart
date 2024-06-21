import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/core/models/message.dart';
import 'package:move_together_app/Chat/chat_bubble.dart';
import 'package:move_together_app/Chat/chat_input.dart';

import 'bloc/chat_bloc.dart';

class ChatBody extends StatefulWidget {
  final List<Message> messages;
  final int userId;
  final ScrollController scrollController;
  final String tripId;

  const ChatBody({
    super.key,
    required this.messages,
    required this.userId,
    required this.scrollController,
    required this.tripId,
  });

  @override
  ChatBodyState createState() => ChatBodyState();
}

class ChatBodyState extends State<ChatBody> {
  final TextEditingController _controller = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleTextChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _handleTextChanged() {
    setState(() {
      _isButtonEnabled = _controller.text.isNotEmpty;
    });
  }

  void _sendMessage(String messageText) {
    if (_isButtonEnabled) {
      final messageText = _controller.text;

      // Dispatch the ChatDataSendMessage event
      print('Sending message: $messageText');
      context.read<ChatBloc>().add(ChatDataSendMessage(widget.tripId, messageText));

      setState(() {
        _controller.clear();
      });

      // Scroll to the bottom after the message is sent
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    if (widget.scrollController.hasClients) {
      widget.scrollController.jumpTo(widget.scrollController.position.minScrollExtent);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: widget.scrollController,
            reverse: true,
            itemCount: widget.messages.length,
            itemBuilder: (context, index) {
              final message = widget.messages[widget.messages.length - 1 - index];
              final isOwnMessage = message.author.id == widget.userId;
              return ChatBubble(
                message: message,
                isOwnMessage: isOwnMessage,
              );
            },
          ),
        ),
        ChatInput(
          controller: _controller,
          isButtonEnabled: _isButtonEnabled,
          onSendPressed: _sendMessage,
          onAttachPressed: () {
            // Handle attachment
          },
        ),
      ],
    );
  }
}
