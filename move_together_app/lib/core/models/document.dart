class Document {
  final int id;
  final String title;
  final String description;
  final String? path;
  final DateTime createdAt;

  Document({
    required this.id,
    required this.title,
    required this.description,
    required this.path,
    required this.createdAt,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      path: json['path'],
      createdAt: DateTime.parse(json['createdAt'])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'path': path,
      'createdAt': createdAt.toIso8601String()
    };
  }
}
