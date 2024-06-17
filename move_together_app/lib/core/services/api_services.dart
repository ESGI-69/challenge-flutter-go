import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:move_together_app/core/models/user.dart';
import 'package:move_together_app/core/models/trip.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:move_together_app/router.dart';
import 'package:move_together_app/Provider/auth_provider.dart';


class ApiServices {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final AuthProvider authProvider;

  ApiServices(this.authProvider);

  Future<String> loginUser(String username, String password) async {
    final response = await http.post(
      Uri.parse('${dotenv.env['API_ADDRESS']!}/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String token = responseData['token'];

      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      authProvider.login(decodedToken['id'].toString());

      return token;
    } else {
      throw Exception('Failed to login user');
    }
  }

  Future<User> registerUser(String username, String password) async {
    final response = await http.post(
      Uri.parse('${dotenv.env['API_ADDRESS']!}/users/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return User.fromJson(responseData);
    } else if (response.statusCode == 401) {
      secureStorage.delete(key: 'jwt');
      router.go('/home');
      throw Exception('Unauthorized');
    } else {
      throw Exception('Failed to register user');
    }
  }

  Future<Trip> joinTrip(String inviteCode) async {
    final response = await http.post(
      Uri.parse('${dotenv.env['API_ADDRESS']!}/trips/join?inviteCode=$inviteCode'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${await secureStorage.read(key: 'jwt') ?? ''}',
      },
    );
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return Trip.fromJson(responseData);
    } else if (response.statusCode == 401) {
      secureStorage.delete(key: 'jwt');
      router.go('/home');
      throw Exception('Unauthorized');
    } else {
      throw Exception('Failed to join trip');
    }
  }

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
    String tripId,
    {
      String? name,
      String? country,
      String? city,
      String? startDate,
      String? endDate,
    }
  ) async {
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
}