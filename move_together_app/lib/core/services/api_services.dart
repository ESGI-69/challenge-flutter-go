import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:move_together_app/core/models/user.dart';
import 'package:move_together_app/core/models/trip.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:move_together_app/router.dart';

class ApiServices {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
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

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String token = responseData['token'];
      return token;
    } else {
      throw Exception('Failed to login user');
    }
  }

  Future<User> registerUser(String username, String password) async {
    final response = await http.post(
      Uri.parse('${dotenv.env['API_ADDRESS']!}/users'),
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
    
    if (response.statusCode == 200) {
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

    if (response.statusCode == 200) {
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
    var jwtPayload = JwtDecoder.decode(await secureStorage.read(key: 'jwt') ?? '');
    final response = await http.get(
      Uri.parse('${dotenv.env['API_ADDRESS']!}/users/${jwtPayload['id']}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${await secureStorage.read(key: 'jwt') ?? ''}',
      },
    );

    if (response.statusCode == 200) {
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
  
}