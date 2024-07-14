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

extension FeatureNamesExtension on FeatureNames {
  String get name {
    switch (this) {
      case FeatureNames.document:
        return 'document';
      case FeatureNames.auth:
        return 'auth';
      case FeatureNames.chat:
        return 'chat';
      case FeatureNames.trip:
        return 'trip';
      case FeatureNames.note:
        return 'note';
      case FeatureNames.transport:
        return 'transport';
      case FeatureNames.accommodation:
        return 'accommodation';
      case FeatureNames.user:
        return 'user';
      case FeatureNames.photo:
        return 'photo';
      case FeatureNames.activity:
        return 'activity';
    }
  }

  static FeatureNames fromName(String name) {
    switch (name) {
      case 'document':
        return FeatureNames.document;
      case 'auth':
        return FeatureNames.auth;
      case 'chat':
        return FeatureNames.chat;
      case 'trip':
        return FeatureNames.trip;
      case 'note':
        return FeatureNames.note;
      case 'transport':
        return FeatureNames.transport;
      case 'accommodation':
        return FeatureNames.accommodation;
      case 'user':
        return FeatureNames.user;
      case 'photo':
        return FeatureNames.photo;
      case 'activity':
        return FeatureNames.activity;
      default:
        throw Exception('Unknown feature name: $name');
    }
  }
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
      name: FeatureNamesExtension.fromName(json['name']),
      isEnabled: json['isEnabled'],
      modifiedBy: User.fromJson(json['modifiedBy']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name.name,
      'isEnabled': isEnabled,
      'modifiedBy': modifiedBy.toJson(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Feature copyWith({required bool isEnabled}) {
    return Feature(
      name: name,
      isEnabled: isEnabled,
      modifiedBy: modifiedBy,
      updatedAt: updatedAt,
    );
  }
}
