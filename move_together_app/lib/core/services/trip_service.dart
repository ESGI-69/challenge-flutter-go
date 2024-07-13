import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/core/models/trip.dart';
import 'package:move_together_app/core/services/api.dart';

class TripService {
  final api = Api().dio;
  final AuthProvider authProvider;

  TripService(
    this.authProvider,
  );

  Future<Trip> join(String inviteCode) async {
    final response = await api.post('/trips/join?inviteCode=$inviteCode');

    if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
      return Trip.fromJson(response.data);
    } else {
      throw Exception('Failed to join trip');
    }
  }

  Future<List<Trip>> getAll() async {
    final response = await api.get('/trips');

    if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
      return (response.data as List).map((trip) => Trip.fromJson(trip)).toList();
    } else {
      throw Exception('Failed to get trips');
    }
  }

  Future<void> leave(String tripId) async {
    final response = await api.post('/trips/$tripId/leave');

    if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
      return;
    } else {
      throw Exception('Failed to leave trip');
    }
  }

  Future<void> delete(String tripId) async {
    final response = await api.delete('/trips/$tripId');

    if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
      return;
    } else {
      throw Exception('Failed to delete trip');
    }
  }

  Future<Trip> create(Trip trip) async {
    final response = await api.post('/trips', data: trip.toJson());

    if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
      return Trip.fromJson(response.data);
    } else {
      throw Exception('Failed to create trip');
    }
  }

  Future<Trip> get(String tripId) async {
    final response = await api.get('/trips/$tripId');
    
    if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
      return Trip.fromJson(response.data);
    } else {
      throw Exception('Failed to get trip');
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