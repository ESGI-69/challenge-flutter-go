import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/core/models/note.dart';
import 'package:move_together_app/core/services/api.dart';

class NoteService {
  final api = Api().dio;
  final AuthProvider authProvider;

  NoteService(
    this.authProvider,
  );

  Future<List<Note>> getAll(int tripId) async {
    final response = await api.get(
      '/trips/$tripId/notes',
    );

    if (response.statusCode! == 503) {
      throw Exception('Fonctionnalité indisponlibe pour l\'instant');
    } else if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return (response.data as List)
          .map((note) => Note.fromJson(note))
          .toList();
    } else {
      throw Exception('Échec de l\'obtention de l\'utilisateur');
    }
  }

  Future<Note> create({
    required int tripId,
    required String title,
    required String content,
  }) async {
    final response = await api.post(
      '/trips/$tripId/notes',
      data: {
        'title': title,
        'content': content,
      },
    );

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return Note.fromJson(response.data);
    } else {
      throw Exception('Échec de la création de la note');
    }
  }

  Future<void> delete(int tripId, int noteId) async {
    final response = await api.delete(
      '/trips/$tripId/notes/$noteId',
    );

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return;
    } else {
      throw Exception('Échec de la suppression de la note');
    }
  }
}
