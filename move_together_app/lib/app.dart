import 'package:flutter/material.dart';
import 'package:move_together_app/home/home_screen.dart';
import 'package:move_together_app/home/landing_screen.dart';
import 'package:move_together_app/login/login_screen.dart';
import 'package:move_together_app/login/register_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class App extends StatelessWidget {
  const App({super.key});
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      routes: {
        '/': (context) => const HomeScreen(),
        '/login':(context) => const LoginScreen(),
        '/register':(context) => const RegisterScreen(),
        '/home':(context) => const HomeScreen(),
      },
      theme: ThemeData(
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Color(0xFF55C0A8),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
