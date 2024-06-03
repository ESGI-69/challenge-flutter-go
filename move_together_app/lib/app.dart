import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:move_together_app/views/landing_screen.dart';
import 'package:move_together_app/views/login_screen.dart';
import 'package:move_together_app/views/register_screen.dart';
import 'package:move_together_app/views/home_screen.dart';
import 'package:move_together_app/views/trip/join_screen.dart';
import 'package:move_together_app/views/trip/trip_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();
    List<String> loggedRoutes = [
      '/home',
      '/join-trip',
      '/trip'
    ];
    List<String> unloggedRoutes = [
      '/login',
      '/register',
      '/',
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
        GoRoute(
          path: '/join-trip',
          builder: (context, state) => const JoinTripScreen(),
        ),
        GoRoute(
          path: '/trip',
          builder: (context, state) => const TripScreen(),
        ),
      ],
      redirect: (context, state) async {
        final bool loggedIn = await isAuthenticated();
        final bool goingToUnlogged = unloggedRoutes.contains(state.uri.toString());

        if (loggedIn && goingToUnlogged) return '/home';
        if (!loggedRoutes.contains(state.uri.toString())) return null;
        if (!loggedIn && !goingToUnlogged) return '/';

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
