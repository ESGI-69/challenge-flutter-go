import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
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

  Future<Photo> create(int tripId, XFile image) async {
    final formData = FormData.fromMap({
      'title': image.name,
      'photo': await MultipartFile.fromFile(image.path),
    });

    final response = await api.post(
      '/trips/$tripId/photos',
      data: formData,
    );

    if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
      return Photo.fromJson(response.data);
    } else {
      throw Exception('Failed to create photo');
    }
  }
}