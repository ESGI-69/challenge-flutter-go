import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/core/models/message.dart';
import 'package:move_together_app/core/services/api.dart';

class ChatService {
  final api = Api().dio;
  final AuthProvider authProvider;

  ChatService(
    this.authProvider,
  );

  Future<List<Message>> getChatMessages(String tripId) async {
    final response = await api.get('/trips/$tripId/chatMessages');

    if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
      return (response.data as List).map((message) => Message.fromJson(message)).toList();
    } else {
      throw Exception('Failed to get chat messages');
    }
  }
}
