import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/core/models/trip.dart';
import 'package:move_together_app/core/models/user.dart';
import 'package:move_together_app/core/models/feature.dart';
import 'package:move_together_app/core/models/log.dart';
import 'package:move_together_app/core/services/api.dart';

class AdminService {
  final api = Api().dio;
  final AuthProvider authProvider;

  AdminService(
    this.authProvider,
  );

  Future<List<Trip>> getAllTrips() async {
    final response = await api.get('/admin/trips');

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return (response.data as List)
          .map((trip) => Trip.fromJson(trip))
          .toList();
    } else {
      throw Exception('Échec de l\'obtention des voyages');
    }
  }

  Future<void> deleteTrip(String tripId) async {
    final response = await api.delete('/admin/trips/$tripId');

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return;
    } else {
      throw Exception('Échec de la suppression du voyage');
    }
  }

  Future<Trip> edit(
    int tripId, {
    String? name,
    String? country,
    String? city,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final response = await api.patch(
      '/trips/$tripId',
      data: {
        'name': name,
        'country': country,
        'city': city,
        'startDate': startDate?.toUtc().toIso8601String(),
        'endDate': endDate?.toUtc().toIso8601String(),
      },
    );

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return Trip.fromJson(response.data);
    } else {
      throw Exception('Échec de la modification du voyage');
    }
  }

  Future<List<User>> getAllUsers() async {
    final response = await api.get('/admin/users');

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return (response.data as List)
          .map((user) => User.fromJson(user))
          .toList();
    } else {
      throw Exception('Échec de l\'obtention de l\'utilisateurs');
    }
  }

  Future<User> changeRoleUser(User user) async {
    final userId = user.id;
    final response = await api.patch(
      '/admin/users/$userId/role',
      data: {
        'role': user.role.toString().split('.').last,
      },
    );

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return User.fromJson(response.data);
    } else {
      throw Exception('Échec de la modification du rôle de l\'utilisateur');
    }
  }

  Future<Feature> patchFeature(String featureName, bool isEnabled) async {
    final response = await api.patch(
      '/admin/app-settings/$featureName',
      data: {
        'isEnabled': isEnabled,
      },
    );

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return Feature.fromJson(response.data);
    } else {
      throw Exception('Échec de la modification de la fonctionnalité');
    }
  }

  Future<List<Feature>> getAllFeatures() async {
    final response = await api.get(
      '/app-settings',
    );

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return (response.data as List)
          .map((feature) => Feature.fromJson(feature))
          .toList();
    } else {
      throw Exception('Échec de l\'obtention des fonctionnalités');
    }
  }

  Future<List<Log>> getAllLogs({String? filter, int? page}) async {
    final response = await api.get('/admin/logs', queryParameters: {
      'filter': filter,
      'page': page,
    });

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return (response.data as List).map((log) => Log.fromJson(log)).toList();
    } else {
      throw Exception('Échec de l\'obtention des logs');
    }
  }
}
