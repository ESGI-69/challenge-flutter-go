import 'package:move_together_app/core/models/user.dart';

enum FeatureNames {
  document,
  auth,
  chat,
  trip,
  note,
  transport,
  accommodation,
  user,
  photo,
  activity,
}

class Feature {
  final FeatureNames name;
  final bool isEnabled;
  final User modifiedBy;
  final DateTime updatedAt;

  Feature({
    required this.name,
    required this.isEnabled,
    required this.modifiedBy,
    required this.updatedAt,
  });

  factory Feature.fromJson(Map<String, dynamic> json) {
    return Feature(
      name: FeatureNames.values
          .firstWhere((e) => e.toString().split('.').last == json['name']),
      isEnabled: json['isEnabled'],
      modifiedBy: User.fromJson(json['modifiedBy']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isEnabled': isEnabled,
      'modifiedBy': modifiedBy.toJson(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  copyWith({required bool isEnabled}) {
    return Feature(
      name: name,
      isEnabled: isEnabled,
      modifiedBy: modifiedBy,
      updatedAt: updatedAt,
    );
  }
}
