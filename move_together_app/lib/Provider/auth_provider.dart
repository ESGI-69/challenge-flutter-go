import 'package:flutter/cupertino.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider extends ChangeNotifier {
  int _userId = 0;
  String _role = '';
  String _token = '';
  int get userId => _userId;
  String get role => _role;
  String get token => _token;
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
      _token = token;
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
    return decodedToken['role'] == 'ADMIN';
  }

  void login(int userId, String role, String token) async {
    _userId = userId;
    _role = role;
    _token = token;
    notifyListeners();
  }

  String getAuthorizationHeader() {
    return 'Bearer $_token';
  }

  logout() async {
    _userId = 0;
    _role = '';
    await secureStorage.delete(key: 'jwt');
    notifyListeners();
  }
}
