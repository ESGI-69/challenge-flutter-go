import 'package:go_router/go_router.dart';
import 'package:move_together_app/views/landing_screen.dart';
import 'package:move_together_app/views/login_screen.dart';
import 'package:move_together_app/views/register_screen.dart';
import 'package:move_together_app/Home/home_screen.dart';
import 'package:move_together_app/Profile/profile_screen.dart';
import 'package:move_together_app/views/trip/join_screen.dart';
import 'package:move_together_app/views/trip/trip_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
      path: '/trip/:tripId',
      builder: (context, state) => const TripScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
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