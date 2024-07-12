import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:move_together_app/Accommodation/accommodation_screen.dart';
import 'package:move_together_app/Activity/activity_screen.dart';
import 'package:move_together_app/Backoffice/Logs/logs_screen.dart';
import 'package:move_together_app/Backoffice/Users/users_admin_screen.dart';
import 'package:move_together_app/Chat/chat_screen.dart';
import 'package:move_together_app/Document/document_screen.dart';
import 'package:move_together_app/Map/map_screen.dart';
import 'package:move_together_app/Photo/photos_screen.dart';
import 'package:move_together_app/Transport/transport_screen.dart';
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
import 'package:move_together_app/Backoffice/Dashboard/dashboard_screen.dart';
import 'package:move_together_app/Backoffice/Trip/trip_screen.dart';

const FlutterSecureStorage secureStorage = FlutterSecureStorage();

List<String> loggedRoutes = [
  '/trips',
  '/trips/join',
  '/trips/create',
  '/trips/:tripId',
  '/trips/:tripId/chat',
  '/trips/:tripId/participants',
  '/trips/:tripId/photos',
  '/profile',
];

List<String> unloggedRoutes = [
  '/login',
  '/register',
  '/',
];

List<String> backOfficeRoutes = [
  '/',
  '/trip',
  '/users',
];

Future<bool> isAuthenticated(BuildContext context) async {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  return await authProvider.isAuthenticated();
}

Future<bool> isAdmin(BuildContext context) async {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  return await authProvider.isUserAdmin();
}

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LandingScreen(),
      routes: [
        GoRoute(
          name: 'home',
          path: 'trips',
          builder: (context, state) => const HomeScreen(),
          routes: [
            GoRoute(
              name: 'join',
              path: 'join',
              builder: (context, state) => const JoinTripScreen(),
            ),
            GoRoute(
              name: 'create',
              path: 'create',
              builder: (context, state) => const CreateTripScreen(),
            ),
            GoRoute(
              name: 'trip',
              path: ':tripId',
              builder: (context, state) => const TripScreen(),
              routes: [
                GoRoute(
                  name: 'chat',
                  path: 'chat',
                  builder: (context, state) => const ChatScreen(),
                ),
                GoRoute(
                  name: 'photos',
                  path: 'photos',
                  builder: (context, state) => const PhotosScreen(),
                ),
                GoRoute(
                  name: 'activity',
                  path: 'activities/:activityId',
                  builder: (context, state) => const ActivityScreen(),
                ),
                GoRoute(
                  name: 'transport',
                  path: 'transports/:transportId',
                  builder: (context, state) => const TransportScreen(),
                ),
                GoRoute(
                  name: 'accommodation',
                  path: 'accommodations/:accommodationId',
                  builder: (context, state) => const AccommodationScreen(),
                ),
                GoRoute(
                  name: 'document',
                  path: 'documents/:documentId',
                  builder: (context, state) => const DocumentScreen(),
                ),
                GoRoute(
                  name: 'map',
                  path: 'map',
                  builder: (context, state) => const MapScreen(),
                ),
              ],
            ),
          ]
        ),
        GoRoute(
          name: 'profile',
          path: 'profile', 
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
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
      return '/trips';
    }
    return null;
  },
);

final GoRouter backOfficeRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/trip',
      name: 'trip',
      builder: (context, state) => const BackofficeTripsScreen(),
    ),
    GoRoute(
      path: '/logs',
      name: 'logs',
      builder: (context, state) => const LogsScreen()
    ),
    GoRoute(
      path: '/users',
      name: 'users',
      builder: (context, state) => const UsersAdminScreen()
    ),
  ],
  redirect: (context, state) async {
    final topRoutePath = state.topRoute?.path;
    final bool userIsAuthenticated = await isAuthenticated(context);
    if (!context.mounted) {
      return null;
    }
    final bool userIsAdmin = await isAdmin(context);


    final bool routeIsPublic = unloggedRoutes.contains(topRoutePath);
    final bool routeRequireAuthentication = backOfficeRoutes.contains(topRoutePath);

    if (!userIsAuthenticated && routeRequireAuthentication) {
      secureStorage.delete(key: 'jwt');
      return '/login';
    }

    if (userIsAuthenticated && routeIsPublic) {
      return '/';
    }

    if (userIsAuthenticated && !userIsAdmin) {
      secureStorage.delete(key: 'jwt');
      return '/login';
    }

    return null;
  },
);
