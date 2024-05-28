import 'package:flutter/material.dart';
import 'package:move_together_app/home/home_screen.dart';
import 'package:move_together_app/login/login_screen.dart';
import 'package:move_together_app/login/register_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      routes: {
        '/': (context) => const HomeScreen(),
        '/login':(context) => const LoginScreen(),
        '/register':(context) => const RegisterScreen(),
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
