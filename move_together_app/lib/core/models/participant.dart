import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/Provider/auth_provider.dart';

// ignore: constant_identifier_names
enum ParticipantTripRole { OWNER, EDITOR, VIEWER }

class Participant {
  final int id;
  final String username;
  final ParticipantTripRole tripRole;
  final String? profilePicturePath;
  final String? profilePictureUri;

  Participant({
    required this.id,
    required this.username,
    required this.tripRole,
    this.profilePicturePath,
    this.profilePictureUri,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['id'],
      username: json['username'],
      tripRole: ParticipantTripRole.values.firstWhere((e) => e.toString().split('.').last == json['tripRole']),
      profilePicturePath: json['profilePicturePath'],
      profilePictureUri: json['profilePictureUri'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'tripRole': tripRole,
      'profilePicturePath': profilePicturePath,
      'profilePictureUri': profilePictureUri,
    };
  }
  
  bool isMe(BuildContext context) {
    final userId = context.read<AuthProvider>().userId;
    return userId == id;
  }
}