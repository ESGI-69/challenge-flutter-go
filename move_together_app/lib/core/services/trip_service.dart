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

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return Trip.fromJson(response.data);
    } else {
      throw Exception('Échec pour rejoindre le voyage');
    }
  }

  Future<List<Trip>> getAll() async {
    final response = await api.get('/trips');

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

  Future<void> leave(String tripId) async {
    final response = await api.post('/trips/$tripId/leave');

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return;
    } else {
      throw Exception('Échec pour quitter le voyage');
    }
  }

  Future<void> delete(String tripId) async {
    final response = await api.delete('/trips/$tripId');

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return;
    } else {
      throw Exception('Échec de la suppression du voyage');
    }
  }

  Future<Trip> create(Trip trip) async {
    final response = await api.post('/trips', data: trip.toJson());

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return Trip.fromJson(response.data);
    } else {
      throw Exception('Échec de la création du voyage');
    }
  }

  Future<Trip> get(String tripId) async {
    final response = await api.get('/trips/$tripId');

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return Trip.fromJson(response.data);
    } else {
      throw Exception('Échec de l\'obtention du voyage');
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
}
