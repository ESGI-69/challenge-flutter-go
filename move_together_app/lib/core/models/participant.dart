import '../../Provider/auth_provider.dart';

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
  
  bool isMe(context) {
    final userId = context.read<AuthProvider>().userId;
    if (userId == null) return false;
    return userId == id;
  }

  @override
  String toString() {
    return 'Participant{id: $id, username: $username, tripRole: $tripRole}';
  }
}