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

  Trip({
    required this.id,
    required this.name,
    required this.country,
    required this.city,
    required this.startDate,
    required this.endDate,
    required this.participants,
    required this.inviteCode,
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'country': country,
      'city': city,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'participants': participants.map((e) => e.toJson()).toList(),
      'inviteCode': inviteCode,
    };
  }
}