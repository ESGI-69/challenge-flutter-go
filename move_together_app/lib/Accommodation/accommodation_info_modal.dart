import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/core/models/accommodation.dart';
import 'package:move_together_app/core/services/accommodation_service.dart';

Map<AccommodationType, String> accommodationTypeString = {
  AccommodationType.hotel: 'Hotel',
  AccommodationType.airbnb: 'airbnb',
  AccommodationType.other: 'autre',
};

class AccommodationInfoModal extends StatelessWidget {
  final Accommodation accommodation;
  final bool hasTripEditPermission;
  final bool isTripOwner;
  final Function(Accommodation) onAccommodationDeleted;
  final int tripId;

  const AccommodationInfoModal({
    super.key,
    required this.accommodation,
    required this.hasTripEditPermission,
    required this.isTripOwner,
    required this.onAccommodationDeleted,
    required this.tripId,
  });


  @override
  Widget build(BuildContext context) {

    void deleteAccommodation() async {
      await AccommodationService(context.read<AuthProvider>()).delete(tripId, accommodation.id);
      onAccommodationDeleted(accommodation);
    }

    return Container(
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
              'Type d\'hébergement : ${accommodationTypeString[accommodation.accommodationType]}',
            ),
            const SizedBox(height: 8),
            Text(
              'Arrivée : ${accommodation.address} le ${DateFormat.yMMMd().format(accommodation.startDate.toLocal())}',
            ),
            Text(
              'Départ : le ${DateFormat.yMMMd().format(accommodation.endDate.toLocal())}',
            ),
            //ajoute un bloc rouge (qui sera remplacé par une carte)
            Container(color: Colors.red, height: 250, width: double.infinity),
            const SizedBox(height: 8),
            const SizedBox(height: 16),
              (hasTripEditPermission) || isTripOwner
              ? ElevatedButton(
                onPressed: deleteAccommodation,
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
                  'Vous n\'avez pas la permission de supprimer ce accommodation car vous ne pouvez pas modifier le voyage',
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
                  'Informations de l\'hébergement',
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