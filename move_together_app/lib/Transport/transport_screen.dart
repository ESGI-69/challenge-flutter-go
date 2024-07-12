import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/Widgets/Button/button_back.dart';
import 'package:move_together_app/Widgets/details_list.dart';
import 'package:move_together_app/core/models/transport.dart';
import 'package:move_together_app/core/services/transport_service.dart';
import 'package:move_together_app/utils/map.dart';

Map<TransportType, String> transportTypeString = {
  TransportType.car: 'Voiture',
  TransportType.plane: 'Avion',
  TransportType.bus: 'Bus',
};

class TransportScreen extends StatelessWidget {
  const TransportScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final transport = GoRouterState.of(context).extra as Transport;

    final tripId = int.parse(GoRouterState.of(context).pathParameters['tripId']!);

    final hasTripEditPermission = GoRouterState.of(context).uri.queryParameters['hasTripEditPermission'] == 'true';
    final isTripOwner = GoRouterState.of(context).uri.queryParameters['isTripOwner'] == 'true';

    void deleteTransport() async {
      await TransportService(context.read<AuthProvider>()).delete(tripId, transport.id);
      context.pop();
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Colors.transparent,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Row(
            children: [
              ButtonBack(),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 400,
              child: RefinedGoogleMap(
                accommodations: const [],
                activities: const [],
                transports: [transport],
                type: RefinedGoogleMapType.appBar,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 16.0,
                left: 16.0,
                right: 16.0,
                bottom: MediaQuery.of(context).padding.bottom + 16.0,
              ),
              child: Column(
                children: [
                  DetailsList(
                    items: [
                      DetailItem(title: 'Type de transport', value: transportTypeString[transport.transportType]),
                      DetailItem(title: 'Date et heure de RDV', value: transport.meetingTime),
                      DetailItem(title: 'Date et heure de départ', value: transport.startDate),
                      DetailItem(title: 'Date et heure d\'arrivée', value: transport.endDate),
                      DetailItem(title: 'Adresse du RDV', value: transport.meetingAddress),
                      DetailItem(title: 'Adresse de départ', value: transport.startAddress),
                      DetailItem(title: 'Adresse d\'arrivée', value: transport.endAddress),
                      DetailItem(title: 'Créé par', value: transport.author.formattedUsername),
                      DetailItem(title: 'Prix', value: '${transport.price.toStringAsFixed(2)}€'),
                    ],
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
