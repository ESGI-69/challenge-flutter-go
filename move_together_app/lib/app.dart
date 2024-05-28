import 'package:flutter/material.dart';
import 'package:move_together_app/home/home_screen.dart';
import 'package:move_together_app/login/login_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      routes: {
        '/': (context) => const HomeScreen(),
        '/login':(context) => LoginScreen(),
      },
      theme: ThemeData(
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Colors.amber,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
