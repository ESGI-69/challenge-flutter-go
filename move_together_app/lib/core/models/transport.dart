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
  final double startLatitude;
  final double startLongitude;
  final String endAddress;
  final double endLatitude;
  final double endLongitude;
  final String? meetingAddress;
  final double meetingLatitude;
  final double meetingLongitude;
  final DateTime? meetingTime;
  final User author;
  final double price;

  Transport({
    required this.id,
    required this.transportType,
    required this.startDate,
    required this.endDate,
    required this.startAddress,
    required this.startLatitude,
    required this.startLongitude,
    required this.endAddress,
    required this.endLatitude,
    required this.endLongitude,
    this.meetingAddress,
    required this.meetingLatitude,
    required this.meetingLongitude,
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
      startLatitude: dynamicToDouble(json['startLatitude']),
      startLongitude: dynamicToDouble(json['startLongitude']),
      endAddress: json['endAddress'],
      endLatitude: dynamicToDouble(json['endLatitude']),
      endLongitude: dynamicToDouble(json['endLongitude']),
      meetingAddress: json['meetingAddress'],
      meetingLatitude: dynamicToDouble(json['meetingLatitude']),
      meetingLongitude: dynamicToDouble(json['meetingLongitude']),
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
      'startLatitude': startLatitude,
      'startLongitude': startLongitude,
      'endAddress': endAddress,
      'endLatitude': endLatitude,
      'endLongitude': endLongitude,
      'meetingAddress': meetingAddress,
      'meetingLatitude': meetingLatitude,
      'meetingLongitude': meetingLongitude,
      'meetingTime': meetingTime,
      'author': author.toJson(),
      'price': price,
    };
  }

  bool get hasValidGeolocation => startLatitude != 0 && startLongitude != 0 && endLatitude != 0 && endLongitude != 0;
  bool get hasValidMeetingGeolocation => meetingLatitude != 0 && meetingLongitude != 0;
  // Is the meeting point is annormally far from the start point. Used to conditionally draw the dashed line between the start and meeting point to avoid performance issues.
  bool get isMeetingPointFarFromStartPoint => (startLatitude - meetingLatitude).abs() > 0.1 && (startLongitude - meetingLongitude).abs() > 0.1;
}