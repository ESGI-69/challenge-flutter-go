import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  String? jwt;

  @override
  void initState() {
    super.initState();
    _loadJwt();
  }

  Future<void> _loadJwt() async {
    final token = await _secureStorage.read(key: 'jwt');
    setState(() {
      jwt = token;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Bienvenue sur Move Together app',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16),
            //Pour du debug j'affiche le jwt
            if (jwt != null)
              Text(
                'JWT: $jwt',
                style: TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('Se connecter'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('S\'inscrire'),
            ),
          ],
        ),
      ),
    );
  }
}