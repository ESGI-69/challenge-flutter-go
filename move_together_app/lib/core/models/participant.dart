import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:move_together_app/router.dart';

class Participant {
  final int id;
  final String username;
  final String tripRole;

  Participant({
    required this.id,
    required this.username,
    required this.tripRole,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['id'],
      username: json['username'],
      tripRole: json['tripRole'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'tripRole': tripRole,
    };
  }
  
  Future<bool> isMe() async {
    final token = await secureStorage.read(key: 'jwt');
    if (token == null) return false;
    final Map<String, dynamic> payload = JwtDecoder.decode(token);
    return payload['id'] == id;
  }

  @override
  String toString() {
    return 'Participant{id: $id, username: $username, tripRole: $tripRole}';
  }
}