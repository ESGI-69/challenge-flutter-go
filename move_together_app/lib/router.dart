import 'package:go_router/go_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:move_together_app/core/models/trip.dart';
import 'package:move_together_app/views/landing_screen.dart';
import 'package:move_together_app/views/login_screen.dart';
import 'package:move_together_app/views/register_screen.dart';
import 'package:move_together_app/Home/home_screen.dart';
import 'package:move_together_app/Profile/profile_screen.dart';
import 'package:move_together_app/views/trip/join_screen.dart';
import 'package:move_together_app/Trip/trip_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const FlutterSecureStorage secureStorage = FlutterSecureStorage();

List<String> loggedRoutes = [
  '/home',
  '/join-trip',
  '/trip',
  '/profile',
  '/trip/:tripId',
];
List<String> unloggedRoutes = [
  '/login',
  '/register',
  '/',
];

Future<bool> isAuthenticated() async {
  final token = await secureStorage.read(key: 'jwt');
  if (token == null) return false;
  final isExpired = JwtDecoder.isExpired(token);
  return !isExpired;
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
      path: '/trip/:tripId',
      builder: (context, state) => TripScreen(trip: state.extra! as Trip),
      redirect: (context, state) {
        final Trip? trip = state.extra as Trip?;
        if (trip == null) return '/home';
        return null;
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
  ],
  redirect: (context, state) async {
    final topRoutePath = state.topRoute?.path;
    final bool userIsAuthenticated = await isAuthenticated();
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