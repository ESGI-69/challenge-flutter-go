import 'dart:convert';

import 'package:move_together_app/core/models/message.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  final WebSocketChannel _channel;

  WebSocketService(String url) : _channel = WebSocketChannel.connect(Uri.parse(url));

  Stream get stream => _channel.stream;

  void send(Message message) {
    var messageMap = (message);
    var jsonMessage = jsonEncode(messageMap);
    _channel.sink.add(jsonMessage);}

  void close() {
    _channel.sink.close();
  }
}