import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/core/models/transport.dart';
import 'package:move_together_app/core/services/transport_service.dart';

Map<TransportType, String> transportTypeString = {
  TransportType.car: 'Voiture',
  TransportType.plane: 'Avion',
  TransportType.bus: 'Bus',
};

class TransportInfoModal extends StatelessWidget {
  final Transport transport;
  final bool hasTripEditPermission;
  final bool isTripOwner;
  final Function(Transport) onTransportDeleted;
  final int tripId;

  const TransportInfoModal({
    super.key,
    required this.transport,
    required this.hasTripEditPermission,
    required this.isTripOwner,
    required this.onTransportDeleted,
    required this.tripId,
  });


  @override
  Widget build(BuildContext context) {

    void deleteTransport() async {
      await TransportService(context.read<AuthProvider>()).delete(tripId, transport.id);
      onTransportDeleted(transport);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      margin: const EdgeInsets.only(bottom: 32),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _Header(),
            const SizedBox(height: 16),
            Text(
              'Type de transport : ${transportTypeString[transport.transportType]}',
            ),
            const SizedBox(height: 8),
            Text(
              'Départ : ${transport.startAddress} le ${DateFormat.yMMMd().format(transport.startDate.toLocal())}',
            ),
            const SizedBox(height: 8),
            Text(
              'Arrivée : ${transport.endAddress} le ${DateFormat.yMMMd().format(transport.endDate.toLocal())}',
            ),
            const SizedBox(height: 8),
            Text(
              'Prix : ${transport.price}€',
            ),
            const SizedBox(height: 16),
              (hasTripEditPermission && transport.author.isMe(context)) || isTripOwner
              ? ElevatedButton(
                onPressed: deleteTransport,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Theme.of(context).colorScheme.error),
                ),
                child: const Text(
                  'Supprimer',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
              : !hasTripEditPermission
                ? Text(
                  'Vous n\'avez pas la permission de supprimer ce transport car vous ne pouvez pas modifier le voyage',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).hintColor,
                  ),
                )
                : !transport.author.isMe(context)
                  ? Text(
                    'Vous ne pouvez pas supprimer ce transport car vous n\'êtes pas son créateur',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).hintColor,
                    ),
                  )
                  : const SizedBox(),
          ]
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 16,
      ),
      child: Column(
        children: [
          const SizedBox(height: 4),
          Container(
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 4),
          const Row(
            children: [
              Expanded(child: 
                Text(
                  'Informations du transport',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}