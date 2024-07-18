import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/core/models/user.dart';
import 'package:move_together_app/core/services/api.dart';

class UserService {
  final api = Api().dio;
  final AuthProvider authProvider;

  UserService(
    this.authProvider,
  );

  Future<User> get(String userId) async {
    final response = await api.get(
      '/users/$userId',
    );

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return User.fromJson(response.data);
    } else {
      throw Exception('Failed to get user');
    }
  }

  Future<User> uploadProfilePicture(XFile image) async {
    final formData =
        FormData.fromMap({'photo': await MultipartFile.fromFile(image.path)});
    final response = await api.patch(
      '/users/photo',
      data: formData,
    );

    if (response.statusCode == 413) {
      throw Exception('Fichier trop lourd, doit être > 5Mo');
    } else if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return User.fromJson(response.data);
    } else {
      throw Exception('Failed to upload profile picture');
    }
  }

  Future<User> update(int userId, String newPassword) async {
    final response = await api.patch(
      '/users/$userId',
      data: {
        'password': newPassword,
      },
    );

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return User.fromJson(response.data);
    } else {
      throw Exception('Failed to update user');
    }
  }
}
