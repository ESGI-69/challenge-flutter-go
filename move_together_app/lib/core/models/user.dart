import 'package:flutter/material.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: constant_identifier_names
enum Role { USER, ADMIN }

class User {
  final int id;
  final String name;
  final Role role;
  final String? profilePicturePath;
  final String? profilePictureUri;

  User({
    required this.id,
    required this.name,
    required this.role,
    this.profilePicturePath,
    this.profilePictureUri,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['username'],
      role: json['role'] != null ? Role.values.firstWhere((e) => e.toString().split('.').last == json['role']) : Role.USER,
      profilePicturePath: json['profilePicturePath'],
      profilePictureUri: json['profilePictureUri'],
    );
  }

  String get formattedUsername => '@$name';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role.toString().split('.').last,
      'profilePicturePath': profilePicturePath,
      'profilePictureUri': profilePictureUri,
    };
  }

  bool isMe(BuildContext context) {
    final userId = context.read<AuthProvider>().userId;
    return userId == id;
  }
}