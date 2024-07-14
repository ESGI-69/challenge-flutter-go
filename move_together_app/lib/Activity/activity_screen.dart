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
  ActivityScreen({super.key});

  final _activityNameController = TextEditingController();
  final _activityDescriptionController = TextEditingController();
  final _activityLocationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final activity = GoRouterState.of(context).extra as Activity;
    _activityNameController.text = activity.name;
    _activityDescriptionController.text = activity.description;
    _activityLocationController.text = activity.location;

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
                    onConfirmEdition: () async {
                      await ActivityService(context.read<AuthProvider>()).update(
                        tripId,
                        activity.id,
                        name: _activityNameController.text,
                        description: _activityDescriptionController.text,
                        location: _activityLocationController.text,
                      );
                      context.pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Activité modifiée avec succès'),
                        ),
                      );
                    },
                    items: [
                      DetailItem(title: 'Nom', controller: _activityNameController, isEditable: true),
                      DetailItem(title: 'Date et heure de début', value: activity.startDate),
                      DetailItem(title: 'Date et heure de fin', value: activity.endDate),
                      DetailItem(title: 'Prix', value: '${activity.price.toStringAsFixed(2)}€'),
                      DetailItem(title: 'Lieu', controller: _activityLocationController, isEditable: true),
                      DetailItem(title: 'Créé par', value: activity.owner.formattedUsername),
                      DetailItem(title: 'Déscription', controller: _activityDescriptionController, isEditable: true),
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
