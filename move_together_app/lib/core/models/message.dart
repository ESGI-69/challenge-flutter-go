import 'package:flutter/material.dart';
import 'package:move_together_app/core/models/user.dart';

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
    print('JSON: $json');
    print('ID: ${json['id']}');
    print('Content: ${json['content']}');
    print('Author: ${json['author']}');
    print('CreatedAt: ${json['createdAt']}');
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
}
