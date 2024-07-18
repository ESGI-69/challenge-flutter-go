import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/core/models/transport.dart';
import 'package:move_together_app/core/services/api.dart';

class TransportService {
  final api = Api().dio;
  final AuthProvider authProvider;

  TransportService(
    this.authProvider,
  );

  Future<List<Transport>> getAll(int tripId) async {
    final response = await api.get(
      '/trips/$tripId/transports',
    );

    if (response.statusCode! == 503) {
      throw Exception('Fonctionnalité indisponlibe pour l\'instant');
    } else if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return (response.data as List)
          .map((transport) => Transport.fromJson(transport))
          .toList();
    } else {
      throw Exception('Échec de l\'obtention de l\'utilisateur');
    }
  }

  Future<Transport> create({
    required int tripId,
    required TransportType transportType,
    required DateTime startDate,
    required DateTime endDate,
    required String startAddress,
    required String endAddress,
    required double price,
    String? meetingAddress,
    DateTime? meetingTime,
  }) async {
    final response = await api.post(
      '/trips/$tripId/transports',
      data: {
        'transportType': transportType.toString().split('.').last,
        'startDate': startDate.toUtc().toIso8601String(),
        'endDate': endDate.toUtc().toIso8601String(),
        'startAddress': startAddress,
        'endAddress': endAddress,
        'price': price,
        'meetingAddress': meetingAddress,
        'meetingTime': meetingTime?.toUtc().toIso8601String(),
      },
    );

    if (response.statusCode! == 503) {
      throw Exception('Fonctionnalité indisponlibe pour l\'instant');
    } else if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return Transport.fromJson(response.data);
    } else {
      throw Exception('Échec de la création du transport');
    }
  }

  Future<void> delete(int tripId, int transportId) async {
    final response = await api.delete(
      '/trips/$tripId/transports/$transportId',
    );

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return;
    } else {
      throw Exception('Échec de la suppression du transport');
    }
  }
}
