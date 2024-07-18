import 'dart:io';

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

    if (response.statusCode! == 503) {
      throw Exception('Fonctionnalité indisponlibe pour l\'instant');
    } else if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return (response.data as List).map((e) => Photo.fromJson(e)).toList();
    } else {
      throw Exception('Échec de l\'obtention des photos');
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

    if (response.statusCode! == 503) {
      throw Exception('Fonctionnalité indisponlibe pour l\'instant');
    } else if (response.statusCode == 413) {
      throw Exception('Fichier trop lourd, doit être > 5Mo');
    } else if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return Photo.fromJson(response.data);
    } else {
      throw Exception('Échec de la création de la photo');
    }
  }

  Future<String> download(int tripId, int photoId) async {
    final imagePath =
        '${Directory.systemTemp.path}/${photoId}_moove_together.jpg';
    final response = await api.download(
      '/trips/$tripId/photos/$photoId/download',
      imagePath,
    );
    if (response.statusCode! == 503) {
      throw Exception('Fonctionnalité indisponlibe pour l\'instant');
    } else if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return imagePath;
    } else {
      throw Exception('Échec du téléchargement de la photo');
    }
  }

  Future<void> delete(int tripId, int photoId) async {
    final response = await api.delete(
      '/trips/$tripId/photos/$photoId',
    );

    if (response.statusCode! == 503) {
      throw Exception('Fonctionnalité indisponlibe pour l\'instant');
    } else if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return;
    } else {
      throw Exception('Échec de la suppression de la photo');
    }
  }
}
