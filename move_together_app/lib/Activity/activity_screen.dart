import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/Widgets/Button/button_back.dart';
import 'package:move_together_app/Widgets/details_list.dart';
import 'package:move_together_app/core/models/activity.dart';
import 'package:move_together_app/core/services/activity_service.dart';
import 'package:move_together_app/utils/map.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activity = GoRouterState.of(context).extra as Activity;

    final tripId = int.parse(GoRouterState.of(context).pathParameters['tripId']!);

    final hasTripEditPermission = GoRouterState.of(context).uri.queryParameters['hasTripEditPermission'] == 'true';
    final isTripOwner = GoRouterState.of(context).uri.queryParameters['isTripOwner'] == 'true';

    void deleteActivity() async {
      await ActivityService(context.read<AuthProvider>()).delete(tripId, activity.id);
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
                activities: [activity],
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
                      DetailItem(title: 'Nom', value: activity.name),
                      DetailItem(title: 'Date et heure de début', value: activity.startDate),
                      DetailItem(title: 'Date et heure de fin', value: activity.endDate),
                      DetailItem(title: 'Prix', value: '${activity.price.toStringAsFixed(2)}€'),
                      DetailItem(title: 'Lieu', value: activity.location),
                      DetailItem(title: 'Créé par', value: activity.owner.formattedUsername),
                      DetailItem(title: 'Déscription', value: activity.description),
                    ]
                  ),
                  const SizedBox(height: 16),
                  (hasTripEditPermission && activity.owner.isMe(context)) || isTripOwner
                    ? ElevatedButton(
                      onPressed: deleteActivity,
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
                        'Vous n\'avez pas la permission de supprimer cette activité car vous ne pouvez pas modifier le voyage',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).hintColor,
                        ),
                      )
                      : !activity.owner.isMe(context)
                        ? Text(
                          'Vous ne pouvez pas supprimer cette activité car vous n\'êtes pas son créateur',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).hintColor,
                          ),
                        )
                        : const SizedBox(),
                ],
              ),
            ),
        ]),
      ),
    );
  }
}
