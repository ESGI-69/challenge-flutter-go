class AppSettings {
  final String name;
  final bool isEnabled;
  final ModifiedBy modifiedBy;
  final DateTime updatedAt;

  AppSettings({
    required this.name,
    required this.isEnabled,
    required this.modifiedBy,
    required this.updatedAt,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      name: json['name'],
      isEnabled: json['isEnabled'],
      modifiedBy: ModifiedBy.fromJson(json['modifiedBy']),
      updatedAt: DateTime.parse(json['updateAt']),
    );
  }
}

class ModifiedBy {
  final int id;
  final String username;

  ModifiedBy({
    required this.id,
    required this.username,
  });

  factory ModifiedBy.fromJson(Map<String, dynamic> json) {
    return ModifiedBy(
      id: json['id'],
      username: json['username'],
    );
  }
}
