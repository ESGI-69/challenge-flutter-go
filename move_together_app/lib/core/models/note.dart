import 'package:move_together_app/core/models/user.dart';

class Note {
  final int id;
  final String title;
  final String content;
  final User author;
  final DateTime createdAt;
  final DateTime updateAt;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.createdAt,
    required this.updateAt,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      author: User.fromJson(json['author']),
      createdAt: DateTime.parse(json['createdAt']),
      updateAt: DateTime.parse(json['updateAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'author': author.toJson(),
    };
  }
}
