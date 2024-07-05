import 'package:move_together_app/core/models/user.dart';

enum AccommodationType {
  hotel,
  airbnb,
  other,
}

class Accommodation {
  final int id;
  final AccommodationType accommodationType;
  final DateTime startDate;
  final DateTime endDate;
  final String address;
  final User author;
  final String name;
  final String? bookingUrl;
  final double? latitude;
  final double? longitude;


  Accommodation({
    required this.id,
    required this.accommodationType,
    required this.startDate,
    required this.endDate,
    required this.address,
    required this.name,
    required this.author,
    this.bookingUrl,
    this.latitude,
    this.longitude,
  });

  factory Accommodation.fromJson(Map<String, dynamic> json) {
    return Accommodation(
      id: json['id'],
      accommodationType: AccommodationType.values.firstWhere((e) => e.toString().split('.').last == json['accommodationType']),
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      address: json['address'],
      name: json['name'],
      author: User.fromJson(json['author']),
      bookingUrl: json['bookingUrl'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'accommodationType': accommodationType.toString(),
      'startDate': startDate,
      'endDate': endDate,
      'address': address,
      'name': name,
      'author': author.toJson(),
      'bookingUrl': bookingUrl,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}