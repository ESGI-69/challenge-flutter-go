import 'package:flutter/material.dart';
import 'package:move_together_app/core/models/participant.dart';

class Trip {
  final int id;
  final String name;
  final String country;
  final String city;
  final DateTime startDate;
  final DateTime endDate;
  final List<Participant> participants;
  final String inviteCode;
  final String? photoUrl;

  Trip({
    required this.id,
    required this.name,
    required this.country,
    required this.city,
    required this.startDate,
    required this.endDate,
    required this.participants,
    required this.inviteCode,
    this.photoUrl = '',
    });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'],
      name: json['name'],
      country: json['country'],
      city: json['city'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      participants: json['participants'].map<Participant>((e) => Participant.fromJson(e)).toList(),
      inviteCode: json['inviteCode'],
      photoUrl: json['photoUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'country': country,
      'city': city,
      'startDate': startDate.toUtc().toIso8601String(),
      'endDate': endDate.toUtc().toIso8601String(),
      'participants': participants.map((participant) => participant.toJson()).toList(),
      'inviteCode': inviteCode,
      'photoUrl': photoUrl,
    };
  }

  bool isCurrentUserOwner(BuildContext context) {
    final Participant owner = participants.firstWhere((participant) => participant.tripRole == "OWNER");
    return owner.isMe(context);
  }

  bool currentUserHasEditingRights(BuildContext context) {
    final myRole = participants.firstWhere((participant) => participant.isMe(context)).tripRole;
    if (myRole == "OWNER") return true;
    if (myRole == "EDITOR") return true;
    return false;
  }
}