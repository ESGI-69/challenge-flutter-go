import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:move_together_app/core/models/transport.dart';
import 'package:move_together_app/core/models/user.dart';
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
}
