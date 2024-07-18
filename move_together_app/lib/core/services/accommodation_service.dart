import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/core/models/accommodation.dart';
import 'package:move_together_app/core/services/api.dart';

class AccommodationService {
  final api = Api().dio;
  final AuthProvider authProvider;

  AccommodationService(
    this.authProvider,
  );

  Future<List<Accommodation>> getAll(int tripId) async {
    final response = await api.get(
      '/trips/$tripId/accommodations',
    );

    if (response.statusCode! == 503) {
      throw Exception('Fonctionnalité indisponlibe pour l\'instant');
    } else if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return (response.data as List)
          .map((accommodation) => Accommodation.fromJson(accommodation))
          .toList();
    } else {
      throw Exception('Échec de l\'obtention de l\'utilisateur');
    }
  }

  Future<Accommodation> create({
    required int tripId,
    required AccommodationType accommodationType,
    required DateTime startDate,
    required DateTime endDate,
    required String address,
    required String name,
    required String? bookingUrl,
    required double price,
  }) async {
    final response = await api.post(
      '/trips/$tripId/accommodations',
      data: {
        'accommodationType': accommodationType.toString().split('.').last,
        'startDate': startDate.toUtc().toIso8601String(),
        'endDate': endDate.toUtc().toIso8601String(),
        'address': address,
        'name': name,
        'bookingUrl': bookingUrl,
        'price': price,
      },
    );

    if (response.statusCode! == 503) {
      throw Exception('Fonctionnalité indisponlibe pour l\'instant');
    } else if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return Accommodation.fromJson(response.data);
    } else {
      throw Exception('Échec de la création de l\'hébergement');
    }
  }

  Future<void> delete(int tripId, int accommodationId) async {
    final response = await api.delete(
      '/trips/$tripId/accommodations/$accommodationId',
    );

    if (response.statusCode! == 503) {
      throw Exception('Fonctionnalité indisponlibe pour l\'instant');
    } else if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return;
    } else {
      throw Exception('Échec de la suppression de l\'hébergement');
    }
  }
}
