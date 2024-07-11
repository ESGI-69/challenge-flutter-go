import 'package:move_together_app/utils/int_to_double.dart';

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
  final String name;
  final String? bookingUrl;
  final double? latitude;
  final double? longitude;
  final double price;


  Accommodation({
    required this.id,
    required this.accommodationType,
    required this.startDate,
    required this.endDate,
    required this.address,
    required this.name,
    this.bookingUrl,
    this.latitude,
    this.longitude,
    required this.price,
  });

  factory Accommodation.fromJson(Map<String, dynamic> json) {
    return Accommodation(
      id: json['id'],
      accommodationType: AccommodationType.values.firstWhere((e) => e.toString().split('.').last == json['accommodationType']),
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      address: json['address'],
      name: json['name'],
      bookingUrl: json['bookingURL'],
      latitude: json['latitude'] is int ? (json['latitude'] as int).toDouble() : json['latitude'],
      longitude: json['longitude'] is int ? (json['longitude'] as int).toDouble() : json['longitude'],
      price: dynamicToDouble(json['price']),
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
      'bookingUrl': bookingUrl,
      'latitude': latitude,
      'longitude': longitude,
      'price': price,
    };
  }
}