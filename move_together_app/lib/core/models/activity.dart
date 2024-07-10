import 'package:move_together_app/core/models/user.dart';
import 'package:move_together_app/utils/dynamic_to_double.dart';

class Activity {
  final int id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final double price;
  final String location;
  final double latitude;
  final double longitude;
  final User owner;

  Activity({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.price,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.owner,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      price: dynamicToDouble(json['price']),
      location: json['location'],
      latitude: dynamicToDouble(json['latitude']),
      longitude: dynamicToDouble(json['longitude']),
      owner: User.fromJson(json['owner']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'startDate': startDate.toUtc().toIso8601String(),
      'endDate': endDate.toUtc().toIso8601String(),
      'price': price,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'owner': owner.toJson(),
    };
  }
}