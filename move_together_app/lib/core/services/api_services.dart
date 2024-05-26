import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServices {
  static Future<String> loginUser(String username, String password) async {
    final response = await http.post(
      Uri.parse('https://dummyjson.com/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      print('request success');
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String token = responseData['token'];
      return token;
    } else {
      throw Exception('Failed to login user');
    }
  }
}