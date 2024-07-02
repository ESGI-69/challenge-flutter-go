import 'package:flutter/cupertino.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider extends ChangeNotifier {
  int _userId = 0;
  String _role = '';
  int get userId => _userId;
  String get role => _role;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  AuthProvider() {
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final isUserAuthenticated = await isAuthenticated();
    if (!isUserAuthenticated) return;
    var token = (await secureStorage.read(key: 'jwt'));
    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      _userId = decodedToken['id'];
      _role = decodedToken['role'];
      notifyListeners();
    }
  }

  Future<bool> isAuthenticated() async {
    final token = await secureStorage.read(key: 'jwt');
    if (token == null) return false;
    final isExpired = JwtDecoder.isExpired(token);
    return !isExpired;
  }

  Future<bool> isUserAdmin() async {
    final token = await secureStorage.read(key: 'jwt');
    if (token == null) return false;
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    print(decodedToken);
    return decodedToken['role'] == 'ADMIN';
  }

  void login(int userId, String role) async {
    _userId = userId;
    _role = role;
    notifyListeners();
  }

  logout() async {
    _userId = 0;
    _role = '';
    await secureStorage.delete(key: 'jwt');
    notifyListeners();
  }
}
