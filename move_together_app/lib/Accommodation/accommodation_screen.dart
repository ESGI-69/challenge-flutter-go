import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/Widgets/Button/button_back.dart';
import 'package:move_together_app/Widgets/details_list.dart';
import 'package:move_together_app/core/models/accommodation.dart';
import 'package:move_together_app/core/services/accommodation_service.dart';
import 'package:move_together_app/utils/exception_to_string.dart';
import 'package:move_together_app/utils/map.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:move_together_app/Widgets/button.dart';

Map<AccommodationType, String> accommodationTypeString = {
  AccommodationType.hotel: 'Hotel',
  AccommodationType.airbnb: 'airbnb',
  AccommodationType.other: 'autre',
};

class AccommodationScreen extends StatelessWidget {
  const AccommodationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final accommodation = GoRouterState.of(context).extra as Accommodation;

    final tripId =
        int.parse(GoRouterState.of(context).pathParameters['tripId']!);

    final hasTripEditPermission = GoRouterState.of(context)
            .uri
            .queryParameters['hasTripEditPermission'] ==
        'true';
    final isTripOwner =
        GoRouterState.of(context).uri.queryParameters['isTripOwner'] == 'true';

    void deleteAccommodation() async {
      try {
        await AccommodationService(context.read<AuthProvider>())
            .delete(tripId, accommodation.id);
        context.pop();
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(exceptionToString(error)),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }

    Uri urlParsed;
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
                accommodations: [accommodation],
                activities: const [],
                transports: const [],
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
                      DetailItem(
                          title: 'Type',
                          value: accommodationTypeString[
                              accommodation.accommodationType]),
                      DetailItem(title: 'Name', value: accommodation.name),
                      DetailItem(
                          title: 'Adresse', value: accommodation.address),
                      DetailItem(
                          title: 'Date de début',
                          value: accommodation.startDate),
                      DetailItem(
                          title: 'Date de fin', value: accommodation.endDate),
                      DetailItem(
                          title: 'URL de réservation',
                          value: accommodation.bookingUrl),
                      DetailItem(
                          title: 'Prix',
                          value: '${accommodation.price.toStringAsFixed(2)}€'),
                    ],
                  ),
                  (accommodation.bookingUrl != null &&
                          accommodation.bookingUrl!.isNotEmpty)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.link,
                              color: Colors.green,
                            ),
                            TextButton(
                              onPressed: () {
                                if (accommodation.bookingUrl != null) {
                                  urlParsed =
                                      Uri.parse(accommodation.bookingUrl!);
                                  launchUrl(urlParsed);
                                }
                              },
                              child: Text(
                                'Lien de réservation',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),
                  const SizedBox(height: 16),
                  (hasTripEditPermission) || isTripOwner
                      ? Button(
                          onPressed: deleteAccommodation,
                          type: ButtonType.destructive,
                          text: 'Supprimer',
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
