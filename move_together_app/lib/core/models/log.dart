enum LogLevel {
  // ignore: constant_identifier_names
  INFO,
  // ignore: constant_identifier_names
  WARN,
  // ignore: constant_identifier_names
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
    this.ip = '',
    this.path = '',
    this.method = '',
    this.username = '',
  });

  factory Log.fromJson(Map<String, dynamic> json) {
    return Log(
      id: json['id'],
      level: LogLevel.values
          .firstWhere((e) => e.toString().split('.').last == json['level']),
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
      ip: json['ip'] ?? '',
      path: json['path'] ?? '',
      method: json['method'] ?? '',
      username: json['username'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'level': level.toString().split('.').last,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'ip': ip,
      'path': path,
      'method': method,
      'username': username,
    };
  }
}
