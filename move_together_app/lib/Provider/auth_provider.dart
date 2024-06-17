import 'package:flutter/cupertino.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider extends ChangeNotifier {
  String _userId = '';
  String get userId => _userId;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<bool> isAuthenticated() async {
    final token = await secureStorage.read(key: 'jwt');
    if (token == null) return false;
    final isExpired = JwtDecoder.isExpired(token);
    return !isExpired;
  }

  void login(String userId) {
    _userId = userId;
    notifyListeners();
  }

  void logout() {
    _userId = '';
    notifyListeners();
  }
}