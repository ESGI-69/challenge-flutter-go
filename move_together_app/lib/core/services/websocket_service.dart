import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  final WebSocketChannel _channel;

  WebSocketService(String url, String roomId)
      : _channel = WebSocketChannel.connect(Uri.parse('$url?roomId=$roomId'));

  Stream get stream => _channel.stream;

  void close() {
    _channel.sink.close();
  }
}
