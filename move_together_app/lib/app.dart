import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:move_together_app/views/landing_screen.dart';
import 'package:move_together_app/views/login_screen.dart';
import 'package:move_together_app/views/register_screen.dart';
import 'package:move_together_app/views/home_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();
    List<String> loggedRoutes = [
      '/home',
    ];

    Future<bool> isAuthenticated() async {
      final token = await secureStorage.read(key: 'jwt');
      return token != null;
    }

    final GoRouter router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const LandingScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
      ],
      redirect: (context, state) async {
        final bool loggedIn = await isAuthenticated();
        final bool goingToLogin = state.uri.toString() == '/login';

        if (!loggedRoutes.contains(state.uri.toString())) return null;

        if (!loggedIn && !goingToLogin) return '/login';
        if (loggedIn && goingToLogin) return '/login';
        return null;
      },
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Color(0xFF55C0A8),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}
