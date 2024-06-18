import 'package:move_together_app/core/models/user.dart';

enum TransportType {
  car,
}

class Transport {
  final int id;
  final TransportType transportType;
  final String startDate;
  final String endDate;
  final String startAddress;
  final String endAddress;
  final String? meetingAddress;
  final String? meetingTime;
  final User author;

  Transport({
    required this.id,
    required this.transportType,
    required this.startDate,
    required this.endDate,
    required this.startAddress,
    required this.endAddress,
    this.meetingAddress,
    this.meetingTime,
    required this.author,
  });

  factory Transport.fromJson(Map<String, dynamic> json) {
    return Transport(
      id: json['id'],
      transportType: TransportType.values.firstWhere((e) => e.toString().split('.').last == json['transportType']),
      startDate: json['startDate'],
      endDate: json['endDate'],
      startAddress: json['startAddress'],
      endAddress: json['endAddress'],
      meetingAddress: json['meetingAddress'],
      meetingTime: json['meetingTime'],
      author: User.fromJson(json['author']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transportType': transportType.toString(),
      'startDate': startDate,
      'endDate': endDate,
      'startAddress': startAddress,
      'endAddress': endAddress,
      'meetingAddress': meetingAddress,
      'meetingTime': meetingTime,
      'author': author.toJson(),
    };
  }
}