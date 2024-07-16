import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/Trip/trip_cost_tag.dart';
import 'package:move_together_app/Widgets/Button/button_leave.dart';
import 'package:move_together_app/Widgets/Button/button_delete.dart';
import 'package:move_together_app/Widgets/Participant/participant_icons.dart';
import 'package:move_together_app/Trip/trip_quick_info.dart';
import 'package:move_together_app/core/models/participant.dart';
import 'package:move_together_app/utils/show_unified_dialog.dart';

class TripCard extends StatelessWidget {
  final int tripId;
  final String imageUrl;
  final String name;
  final String country;
  final String city;
  final DateTime startDate;
  final DateTime endDate;
  final String inviteCode;
  final List<Participant> participants;
  final Function() onTap;
  final Function() onLeave;
  final Function() onDelete;
  final bool isCurrentUserOwner;
  final Function() onParticipantsTap;
  final double totalPrice;

  const TripCard({
    super.key,
    required this.tripId,
    required this.imageUrl,
    required this.name,
    required this.country,
    required this.city,
    required this.startDate,
    required this.endDate,
    required this.inviteCode,
    required this.participants,
    required this.onTap,
    required this.onLeave,
    required this.onDelete,
    required this.isCurrentUserOwner,
    required this.onParticipantsTap,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          margin: const EdgeInsets.only(bottom: 40),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Image.network(
                  imageUrl,
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  headers: {
                    'Authorization': context.read<AuthProvider>().getAuthorizationHeader(),
                  },
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: TripCostTag(
                  totalCost: totalPrice,
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Row(
                  children: [
                    ParticipantIcons(
                      participants: participants,
                      onTap: onParticipantsTap,
                    ),
                    ...!isCurrentUserOwner ? [
                      const SizedBox(width: 10),
                      Container(
                        height: 40,
                        width: 4,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius: const BorderRadius.all(Radius.circular(2)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ButtonLeave(
                        onTap: () => showUnifiedDialog(
                          context: context,
                          title: 'Quitter $name?',
                          content: 'Etes-vous sûr de vouloir quitter ce voyage?',
                          cancelButtonText: 'Annuler',
                          okButtonText: 'Quitter',
                          okButtonTextStyle: TextStyle(color: Theme.of(context).colorScheme.error),
                          onCancelPressed: () {
                            context.pop();
                          },
                          onOkPressed: () async {
                            context.pop();
                            onLeave();
                          },
                        ),
                      ),
                    ] : [
                      const SizedBox(width: 10),
                      Container(
                        height: 40,
                        width: 4,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius: const BorderRadius.all(Radius.circular(2)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ButtonDelete(
                        onTap: () => showUnifiedDialog(
                          context: context,
                          title: 'Supprimer $name?',
                          content: 'Etes-vous sûr de vouloir supprimer ce voyage?',
                          cancelButtonText: 'Annuler',
                          okButtonText: 'Supprimer',
                          okButtonTextStyle: TextStyle(color: Theme.of(context).colorScheme.error),
                          onCancelPressed: () {
                            context.pop();
                          },
                          onOkPressed: () async {
                            context.pop();
                            onDelete();
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Center(
                heightFactor: BorderSide.strokeAlignCenter,
                child: TripQuickInfo(
                  name: name,
                  country: country,
                  city: city,
                  startDate: startDate,
                  endDate: endDate,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}