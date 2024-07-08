import 'dart:io';
import 'package:dio/dio.dart';
import 'package:move_together_app/core/services/api.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/core/models/document.dart';

class DocumentService {
  final api = Api().dio;
  final AuthProvider authProvider;

  DocumentService(
      this.authProvider,
      );

  Future<List<Document>> getAll(int tripId) async {
    final response = await api.get(
      '/trips/$tripId/documents',
    );

    if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
      return (response.data as List).map((document) => Document.fromJson(document)).toList();
    } else {
      throw Exception('Failed to get documents');
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
      'document': await MultipartFile.fromFile(document!.path, filename: document.path.split('/').last),
    });

    final response = await api.post(
      '/trips/$tripId/documents',
      data: formData,
    );

    if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
      return Document.fromJson(response.data);
    } else {
      throw Exception('Failed to create document');
    }
  }

  Future<void> delete(int tripId, int documentId) async {
    final response = await api.delete(
      '/trips/$tripId/documents/$documentId',
    );

    if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
      return;
    } else {
      throw Exception('Failed to delete document');
    }
  }

  Future<String> download(int tripId, int documentId) async {
    final documentPath = '${Directory.systemTemp.path}/${documentId}_moove_together.pdf';
    final response = await api.download(
      '/trips/$tripId/documents/$documentId/download',
      documentPath,
    );

    if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
      return documentPath;
    } else {
      throw Exception('Failed to download document');
    }
  }
}
