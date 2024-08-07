import 'package:move_together_app/utils/dynamic_to_double.dart';

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
  final double latitude;
  final double longitude;
  final double price;

  Accommodation({
    required this.id,
    required this.accommodationType,
    required this.startDate,
    required this.endDate,
    required this.address,
    required this.name,
    this.bookingUrl,
    required this.latitude,
    required this.longitude,
    required this.price,
  });

  factory Accommodation.fromJson(Map<String, dynamic> json) {
    return Accommodation(
      id: json['id'],
      accommodationType: AccommodationType.values.firstWhere(
          (e) => e.toString().split('.').last == json['accommodationType']),
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      address: json['address'],
      name: json['name'],
      bookingUrl: json['bookingURL'],
      latitude: dynamicToDouble(json['latitude']),
      longitude: dynamicToDouble(json['longitude']),
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

  bool get hasValidGeolocation => latitude != 0 && longitude != 0;
}
