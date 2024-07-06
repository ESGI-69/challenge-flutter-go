import 'package:move_together_app/core/models/user.dart';

class Photo {
  final int id;
  final String title;
  final String description;
  final String uri;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User owner;

  Photo({
    required this.id,
    required this.title,
    required this.description,
    required this.uri,
    required this.createdAt,
    required this.updatedAt,
    required this.owner,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      uri: json['uri'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updateAt']),
      owner: User.fromJson(json['owner']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'uri': uri,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'owner': owner.toJson(),
    };
  }
}