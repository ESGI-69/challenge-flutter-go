import 'dart:io';

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
      throw Exception('Failed to get user');
    }
  }

  Future<Document> create({
    required int tripId,
    required String title,
    required String description,
    // TODO: Check if this is the correct type
    required File document,
  }) async {
    final response = await api.post(
      '/trips/$tripId/documents',
      data: {
        'title': title,
        'description': description,
        'document': document,
      },
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

}