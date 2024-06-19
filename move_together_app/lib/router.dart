import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:move_together_app/views/landing_screen.dart';
import 'package:move_together_app/views/login_screen.dart';
import 'package:move_together_app/views/register_screen.dart';
import 'package:move_together_app/Home/home_screen.dart';
import 'package:move_together_app/Profile/profile_screen.dart';
import 'package:move_together_app/Trip/trip_join_screen.dart';
import 'package:move_together_app/Trip/trip_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:move_together_app/Provider/auth_provider.dart';

import 'package:move_together_app/Trip/trip_create_screen.dart';

const FlutterSecureStorage secureStorage = FlutterSecureStorage();

List<String> loggedRoutes = [
  '/home',
  '/join-trip',
  '/trip',
  '/profile',
  '/trip/:tripId',
  '/create-trip',
];
List<String> unloggedRoutes = [
  '/login',
  '/register',
  '/',
];

Future<bool> isAuthenticated(BuildContext context) async {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  return await authProvider.isAuthenticated();
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
      name: 'home',
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/join-trip',
      builder: (context, state) => const JoinTripScreen(),
    ),
    GoRoute(
      path: '/create-trip',
      builder: (context, state) => const CreateTripScreen(),
    ),
    GoRoute(
      path: '/trip/:tripId',
      builder: (context, state) => const TripScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
  ],
  redirect: (context, state) async {
    final topRoutePath = state.topRoute?.path;
    final bool userIsAuthenticated = await isAuthenticated(context);
    final bool routeIsPublic = unloggedRoutes.contains(topRoutePath);
    final bool routeRequireAuthentication = loggedRoutes.contains(topRoutePath);
    if (!userIsAuthenticated && routeRequireAuthentication) {
      secureStorage.delete(key: 'jwt');
      return '/';
    }
    if (userIsAuthenticated && routeIsPublic) {
      return '/home';
    }
    return null;
  },
);