import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/core/services/api.dart';

class AuthService {
  final api = Api().dio;
  final AuthProvider authProvider;

  AuthService(this.authProvider);

  Future<String> login(String username, String password) async {
    final response = await api.post(
      '/login',
      data: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      final String token = response.data['token'];
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      authProvider.login(decodedToken['id'], decodedToken['role'], token);

      return token;
    } else {
      throw Exception('Échec de la connexion');
    }
  }

  Future<void> register(String username, String password) async {
    final response = await api.post(
      '/users',
      data: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return;
    } else {
      throw Exception('Échec de l\'inscription');
    }
  }
}
