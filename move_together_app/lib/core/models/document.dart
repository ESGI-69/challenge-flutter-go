import 'package:move_together_app/core/models/user.dart';

class Document {
  final int id;
  final String title;
  final String description;
  final String? path;
  final DateTime createdAt;
  final User owner;

  Document({
    required this.id,
    required this.title,
    required this.description,
    required this.path,
    required this.createdAt,
    required this.owner,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      path: json['path'],
      createdAt: DateTime.parse(json['createdAt']),
      owner: User.fromJson(json['owner']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'path': path,
      'createdAt': createdAt.toIso8601String(),
      'owner': owner.toJson(),
    };
  }
}
