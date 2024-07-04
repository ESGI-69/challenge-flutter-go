import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/core/models/participant.dart';
import 'package:move_together_app/core/services/api.dart';

class ParticipantResponseData {
  final Map<String, dynamic> participants;

  ParticipantResponseData({
    required this.participants,
  });
} 

class ParticipantService {
  final api = Api().dio;
  final AuthProvider authProvider;

  ParticipantService(
    this.authProvider,
  );

  Future<List<Participant>> getAll(int tripId) async {
    final response = await api.get(
      '/trips/$tripId/participants/',
    );

    if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
      return (response.data['participants'] as List).map((e) => Participant.fromJson(e)).toList();
    } else {
      throw Exception('Failed to get trip participants');
    }
  }

  Future<void> changeRole(int tripId, int participantId, ParticipantTripRole role) async {
    if (role == ParticipantTripRole.OWNER) {
      throw Exception('Cannot change role to owner');
    }
    final response = await api.patch(
      '/trips/$tripId/participants/$participantId/role',
      queryParameters: {
        'role': role.toString().split('.').last,
      },
    );

    if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
      return;
    } else {
      throw Exception('Failed to change participant role');
    }
  }

  Future<void> remove(int tripId, int participantId) async {
    final response = await api.delete(
      '/trips/$tripId/participants/$participantId/',
    );

    if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
      return;
    } else {
      throw Exception('Failed to remove participant');
    }
  }
}