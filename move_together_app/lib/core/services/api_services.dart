import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:move_together_app/core/models/user.dart';

class ApiServices {
  static Future<String> loginUser(String username, String password) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/login'),
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

  static Future<User> registerUser(String username, String password) async {
    final response = await http.post(
      Uri.parse('http://10.2.2:8080/register'),
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

    } else {
      throw Exception('Failed to register user');
    }
  }
}