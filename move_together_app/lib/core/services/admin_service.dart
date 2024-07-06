import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/core/models/trip.dart';
import 'package:move_together_app/core/services/api.dart';

class AdminService {
  final api = Api().dio;
  final AuthProvider authProvider;

  AdminService(
      this.authProvider,
      );

  Future<List<Trip>> getAllTrips() async {
    final response = await api.get('/admin/trips');

    if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
      return (response.data as List).map((trip) => Trip.fromJson(trip)).toList();
    } else {
      throw Exception('Failed to get trips');
    }
  }

  Future<void> deleteTrip(String tripId) async {
    final response = await api.delete('/admin/trips/$tripId');

    if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
      return;
    } else {
      throw Exception('Failed to delete trip');
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

    if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
      return Trip.fromJson(response.data);
    } else {
      throw Exception('Failed to edit trip');
    }
  }
}