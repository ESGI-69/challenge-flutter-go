import 'dart:io';
import 'package:dio/dio.dart';
import 'package:move_together_app/core/services/api.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/core/models/document.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class DocumentService {
  final api = Api().dio;
  final AuthProvider authProvider;

  DocumentService(this.authProvider);

  Future<List<Document>> getAll(int tripId) async {
    final response = await api.get(
      '/trips/$tripId/documents',
    );

    if (response.statusCode! == 503) {
      throw Exception('Fonctionnalité indisponlibe pour l\'instant');
    } else if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return (response.data as List)
          .map((document) => Document.fromJson(document))
          .toList();
    } else {
      throw Exception('Échec de l\'obtention des documents');
    }
  }

  Future<Document> create({
    required int tripId,
    required String title,
    required String description,
    required File? document,
  }) async {
    FormData formData = FormData.fromMap({
      'title': title,
      'description': description,
      'document': await MultipartFile.fromFile(document!.path,
          filename: document.path.split('/').last),
    });

    final response = await api.post(
      '/trips/$tripId/documents',
      data: formData,
    );

    if (response.statusCode! == 503) {
      throw Exception('Fonctionnalité indisponlibe pour l\'instant');
    } else if (response.statusCode == 413) {
      throw Exception('Fichier trop lourd, doit être > 5Mo');
    } else if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return Document.fromJson(response.data);
    } else {
      throw Exception('Échec de la création du document');
    }
  }

  Future<void> delete(int tripId, int documentId) async {
    final response = await api.delete(
      '/trips/$tripId/documents/$documentId',
    );

    if (response.statusCode! == 503) {
      throw Exception('Fonctionnalité indisponlibe pour l\'instant');
    } else if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return;
    } else {
      throw Exception('Échec de la suppression du document');
    }
  }

  Future<String> download(
      int tripId, int documentId, String documentName) async {
    Directory? directory;
    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
    } else if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    }

    final documentPath = path.join(
        directory!.path, '${documentId}_${documentName}_moove_together.pdf');
    final response = await api.download(
      '/trips/$tripId/documents/$documentId/download',
      documentPath,
    );

    if (response.statusCode! == 503) {
      throw Exception('Fonctionnalité indisponlibe pour l\'instant');
    } else if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return documentPath;
    } else {
      throw Exception('Échec du téléchargement du document');
    }
  }
}
