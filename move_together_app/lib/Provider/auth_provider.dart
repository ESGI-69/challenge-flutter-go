import 'package:flutter/cupertino.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider extends ChangeNotifier {
  int _userId = 0;
  int get userId => _userId;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  AuthProvider() {
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    var token = (await secureStorage.read(key: 'jwt'))!;
    _userId = JwtDecoder.decode(token)['id'];
    notifyListeners();
  }

  Future<bool> isAuthenticated() async {
    final token = await secureStorage.read(key: 'jwt');
    if (token == null) return false;
    final isExpired = JwtDecoder.isExpired(token);
    return !isExpired;
  }

  void login(int userId) async {
    _userId = userId;
    notifyListeners();
  }

  void logout() async {
    _userId = 0;
    notifyListeners();
  }
}