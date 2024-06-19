import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/core/models/transport.dart';
import 'package:move_together_app/core/services/api.dart';

class TransportService {
  final api = Api().dio;
  final AuthProvider authProvider;

  TransportService(
    this.authProvider,
  );

  Future<List<Transport>> getAll(String tripId) async {
    final response = await api.get(
      '/trips/$tripId/transports/',
    );

    if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
      return (response.data as List).map((transport) => Transport.fromJson(transport)).toList();
    } else {
      throw Exception('Failed to get user');
    }
  }
}