import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  final WebSocketChannel _channel;

  WebSocketService(String url, String route, String roomId, String token)
      : _channel = WebSocketChannel.connect(
      Uri.parse('$url/$route?roomId=$roomId&token=$token'));

  Stream get stream => _channel.stream;

  void close() {
    _channel.sink.close();
  }
}
