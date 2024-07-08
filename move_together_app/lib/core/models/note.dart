import 'package:move_together_app/core/models/user.dart';

class Note {
  final int id;
  final String title;
  final String content;
  final User author;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      author: User.fromJson(json['author']),
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