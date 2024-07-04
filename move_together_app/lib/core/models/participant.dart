import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/Provider/auth_provider.dart';

// ignore: constant_identifier_names
enum ParticipantTripRole { OWNER, EDITOR, VIEWER }

class Participant {
  final int id;
  final String username;
  final ParticipantTripRole tripRole;

  Participant({
    required this.id,
    required this.username,
    required this.tripRole,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['id'],
      username: json['username'],
      tripRole: ParticipantTripRole.values.firstWhere((e) => e.toString().split('.').last == json['tripRole']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'tripRole': tripRole,
    };
  }
  
  bool isMe(BuildContext context) {
    final userId = context.read<AuthProvider>().userId;
    return userId == id;
  }

  @override
  String toString() {
    return 'Participant{id: $id, username: $username, tripRole: $tripRole}';
  }
}