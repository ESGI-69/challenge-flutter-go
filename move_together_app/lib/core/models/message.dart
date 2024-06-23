import 'package:flutter/cupertino.dart';
import 'package:move_together_app/core/models/user.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class Message {
  final int id;
  final String content;
  final UserWithoutRole author;
  final DateTime createdAt;


  Message({
    required this.id,
    required this.content,
    required this.author,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        id: json['id'],
        content: json['content'],
        author: UserWithoutRole.fromJson(json['author']),
        createdAt: DateTime.parse(json['createdAt'])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'author': author.toJson(),
      'createdAt': createdAt.toIso8601String()
    };
  }

  bool isCurrentUserAuthor(BuildContext context) {
    final userId = context.read<AuthProvider>().userId;
    return author.id == userId;
  }
}

class MessageToSend {
  final String content;

  MessageToSend({
    required this.content,
  });

  Map<String, dynamic> toJson() {
    return {
      'content': content,
    };
  }
}