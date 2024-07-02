import 'package:flutter/cupertino.dart';
import 'package:move_together_app/core/models/transport.dart';

class TransportRow extends StatelessWidget {
  final Transport transport;

  const TransportRow({
    super.key, 
    required this.transport
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(transport.startAddress),
        Text(transport.endAddress),
      ],
    );
  }
}