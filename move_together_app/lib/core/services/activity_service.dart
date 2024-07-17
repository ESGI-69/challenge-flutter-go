import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/core/models/activity.dart';
import 'package:move_together_app/core/services/api.dart';

class ActivityService {
  final api = Api().dio;
  final AuthProvider authProvider;

  ActivityService(
    this.authProvider,
  );

  Future<List<Activity>> getAll(int tripId) async {
    final response = await api.get(
      '/trips/$tripId/activities',
    );

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return (response.data as List)
          .map((note) => Activity.fromJson(note))
          .toList();
    } else {
      throw Exception('Failed to get Activities');
    }
  }

  Future<Activity> create({
    required int tripId,
    required String name,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required double price,
    required String location,
  }) async {
    final response = await api.post(
      '/trips/$tripId/activities',
      data: {
        'name': name,
        'description': description,
        'startDate': startDate.toUtc().toIso8601String(),
        'endDate': endDate.toUtc().toIso8601String(),
        'price': price,
        'location': location,
      },
    );

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return Activity.fromJson(response.data);
    } else {
      throw Exception('Failed to create activities');
    }
  }

  Future<void> delete(int tripId, int activityId) async {
    final response = await api.delete(
      '/trips/$tripId/activities/$activityId',
    );

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return;
    } else {
      throw Exception('Failed to delete activities');
    }
  }
}
