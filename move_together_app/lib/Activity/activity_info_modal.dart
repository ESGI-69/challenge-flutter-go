import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/Widgets/details_list.dart';
import 'package:move_together_app/core/models/activity.dart';
import 'package:move_together_app/core/services/activity_service.dart';

class ActivityInfoModal extends StatelessWidget {
  final Activity activity;
  final bool hasTripEditPermission;
  final bool isTripOwner;
  final Function(Activity) onActivityDeleted;
  final int tripId;

  const ActivityInfoModal({
    super.key,
    required this.activity,
    required this.hasTripEditPermission,
    required this.isTripOwner,
    required this.onActivityDeleted,
    required this.tripId,
  });


  @override
  Widget build(BuildContext context) {

    void deleteActivity() async {
      await ActivityService(context.read<AuthProvider>()).delete(tripId, activity.id);
      onActivityDeleted(activity);
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
              DetailsList(
                items: [
                  DetailItem(title: 'Nom', value: activity.name),
                  DetailItem(title: 'Date et heure de début', value: activity.startDate),
                  DetailItem(title: 'Date et heure de fin', value: activity.endDate),
                  DetailItem(title: 'Prix', value: '${activity.price}€'),
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
                  'Informations de l\'activité',
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