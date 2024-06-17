import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:move_together_app/app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:move_together_app/router.dart';
import 'package:provider/provider.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String _userId = '';

  String get userId => _userId;

  Future<bool> isAuthenticated() async {
    final token = await secureStorage.read(key: 'jwt');
    if (token == null) return false;
    final isExpired = JwtDecoder.isExpired(token);
    return !isExpired;
  }

  void login(String userId) {
    _isAuthenticated = true;
    _userId = userId;
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    _userId = '';
    notifyListeners();
  }
}

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: const App(),
    ),
  );
}
