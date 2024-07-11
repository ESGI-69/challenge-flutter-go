import 'package:move_together_app/core/models/user.dart';
import 'package:move_together_app/utils/dynamic_to_double.dart';

enum TransportType {
  car,
  plane,
  bus,
}

class Transport {
  final int id;
  final TransportType transportType;
  final DateTime startDate;
  final DateTime endDate;
  final String startAddress;
  final String endAddress;
  final String? meetingAddress;
  final DateTime? meetingTime;
  final User author;
  final double price;

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
    required this.price,
  });

  factory Transport.fromJson(Map<String, dynamic> json) {
    return Transport(
      id: json['id'],
      transportType: TransportType.values.firstWhere((e) => e.toString().split('.').last == json['transportType']),
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      startAddress: json['startAddress'],
      endAddress: json['endAddress'],
      meetingAddress: json['meetingAddress'],
      meetingTime: DateTime.parse(json['meetingTime']),
      author: User.fromJson(json['author']),
      price: dynamicToDouble(json['price']),
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
      'price': price,
    };
  }
}