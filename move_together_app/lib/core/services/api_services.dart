import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:move_together_app/core/models/transport.dart';
import 'package:move_together_app/core/models/user.dart';
import 'package:move_together_app/core/models/trip.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:move_together_app/core/services/api.dart';
import 'package:move_together_app/router.dart';
import 'package:move_together_app/Provider/auth_provider.dart';


class ApiServices {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final AuthProvider authProvider;
  final api = Api();

  ApiServices(
    this.authProvider
  );

  Future<List<Trip>> getTrips() async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_ADDRESS']!}/trips'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${await secureStorage.read(key: 'jwt') ?? ''}',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final List<dynamic> responseData = jsonDecode(response.body);
      return responseData.map((trip) => Trip.fromJson(trip)).toList();
    } else if (response.statusCode == 401) {
      secureStorage.delete(key: 'jwt');
      router.go('/home');
      throw Exception('Unauthorized');
    } else {
      throw Exception('Failed to get trips');
    }
  }

  Future<User> getProfile() async {
    var userId = authProvider.userId;
    final response = await http.get(
      Uri.parse('${dotenv.env['API_ADDRESS']!}/users/$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${await secureStorage.read(key: 'jwt') ?? ''}',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return User.fromJson(responseData);
    } else if (response.statusCode == 401) {
      secureStorage.delete(key: 'jwt');
      router.go('/home');
      throw Exception('Unauthorized');
    } else {
      throw Exception('Failed to get profile');
    }
  }

  Future<Trip> getTrip(String tripId) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_ADDRESS']!}/trips/$tripId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${await secureStorage.read(key: 'jwt') ?? ''}',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return Trip.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      secureStorage.delete(key: 'jwt');
      router.go('/home');
      throw Exception('Unauthorized');
    } else {
      throw Exception('Failed to get trip');
    }
  }

  Future<Trip> editTrip(
    String tripId, {
    String? name,
    String? country,
    String? city,
    String? startDate,
    String? endDate,
  }) async {
    final response = await http.patch(
      Uri.parse('${dotenv.env['API_ADDRESS']!}/trips/$tripId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${await secureStorage.read(key: 'jwt') ?? ''}',
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'country': country,
        'city': city,
        'startDate': startDate,
        'endDate': endDate,
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return Trip.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      secureStorage.delete(key: 'jwt');
      router.go('/home');
      throw Exception('Unauthorized');
    } else {
      throw Exception('Failed to edit trip');
    }
  }

  Future<void> leaveTrip(String tripId) async {
    final response = await http.post(
      Uri.parse('${dotenv.env['API_ADDRESS']!}/trips/$tripId/leave'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${await secureStorage.read(key: 'jwt') ?? ''}',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    } else if (response.statusCode == 401) {
      secureStorage.delete(key: 'jwt');
      router.go('/home');
      throw Exception('Unauthorized');
    } else {
      throw Exception('Failed to leave trip');
    }
  }

  Future<void> deleteTrip(String tripID) async {
    final response = await http.delete(
      Uri.parse('${dotenv.env['API_ADDRESS']!}/trips/$tripID'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${await secureStorage.read(key: 'jwt') ?? ''}',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    } else if (response.statusCode == 401) {
      secureStorage.delete(key: 'jwt');
      router.go('/home');
      throw Exception('Unauthorized');
    } else {
      throw Exception('Failed to delete trip');
    }
  }

  Future<List<Transport>> getTransports(String tripId) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_ADDRESS']!}/trips/$tripId/transports'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${await secureStorage.read(key: 'jwt') ?? ''}',
      },
    );
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final List<dynamic> responseData = jsonDecode(response.body);
      return responseData.map((transport) => Transport.fromJson(transport)).toList();
    } else if (response.statusCode == 401) {
      secureStorage.delete(key: 'jwt');
      router.go('/home');
      throw Exception('Unauthorized');
    } else {
      throw Exception('Failed to get transport');
    }
  }

  Future<Trip> createTrip(Trip trip) async {
    String formattedStartDate = trip.startDate.toUtc().toIso8601String();
    String formattedEndDate = trip.endDate.toUtc().toIso8601String();
    final response = await http.post(
      Uri.parse('${dotenv.env['API_ADDRESS']!}/trips/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${await secureStorage.read(key: 'jwt') ?? ''}',
      },
      body: jsonEncode(<String, dynamic>{
        'name': trip.name,
        'country': trip.country,
        'city': trip.city,
        'startDate': formattedStartDate,
        'endDate': formattedEndDate,
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return Trip.fromJson(responseData);
    } else if (response.statusCode == 401) {
      secureStorage.delete(key: 'jwt');
      router.go('/home');
      throw Exception('Unauthorized');
    } else {
      throw Exception('Failed to create trip');
    }
  }
}
