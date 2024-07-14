enum LogLevel {
  INFO,
  WARN,
  ERROR,
}
class Log {
  final int id;
  final LogLevel level;
  final String message;
  final DateTime timestamp;
  final String ip;
  final String path;
  final String method;
  final String username;

  Log({
    required this.id,
    required this.level,
    required this.message,
    required this.timestamp,
    this.ip = '', // Valeur par défaut si non spécifié
    this.path = '', // Valeur par défaut si non spécifié
    this.method = '', // Valeur par défaut si non spécifié
    this.username = '', // Valeur par défaut si non spécifié
  });

  factory Log.fromJson(Map<String, dynamic> json) {
    return Log(
      id: json['id'],
      level: LogLevel.values.firstWhere((e) => e.toString().split('.').last == json['level']),
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
      ip: json['ip'] ?? '', // Utilisez ?? pour fournir une valeur par défaut
      path: json['path'] ?? '', // Utilisez ?? pour fournir une valeur par défaut
      method: json['method'] ?? '', // Utilisez ?? pour fournir une valeur par défaut
      username: json['username'] ?? '', // Utilisez ?? pour fournir une valeur par défaut
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'level': level.toString().split('.').last, // Pour rendre le JSON plus propre
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'ip': ip,
      'path': path,
      'method': method,
      'username': username,
    };
  }
}