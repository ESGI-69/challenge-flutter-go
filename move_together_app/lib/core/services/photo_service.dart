import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/core/models/photo.dart';
import 'package:move_together_app/core/services/api.dart';

class PhotoService {
  final api = Api().dio;
  final AuthProvider authProvider;

  PhotoService(
    this.authProvider,
  );

  Future<List<Photo>> getAll(int userId) async {
    final response = await api.get(
      '/trips/$userId/photos',
    );

    if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
      return (response.data as List).map((e) => Photo.fromJson(e)).toList();
    } else {
      throw Exception('Failed to get photos');
    }
  }
}