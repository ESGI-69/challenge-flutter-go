import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:move_together_app/core/models/transport.dart';

class TransportRow extends StatelessWidget {
  final Transport transport;

  const TransportRow({
    super.key, 
    required this.transport
  });


  @override
  Widget build(BuildContext context) {
    final tranportIcon = {
      TransportType.car: Icons.directions_car,
      TransportType.bus: Icons.directions_bus,
      TransportType.plane: Icons.airplanemode_active,
    };
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black12,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 8,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              tranportIcon[transport.transportType],
              color: Theme.of(context).primaryColor,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Wrap(
                children: [
                  Text(
                    "${transport.startAddress} - ${transport.endAddress}, ${DateFormat.yMMMd().format(transport.startDate)}",
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.black38, size: 16)
          ],
        ),
      ),
    );
  }
}