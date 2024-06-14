import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:move_together_app/Widgets/Button/button_leave.dart';
import 'package:move_together_app/Widgets/Participant/participant_icons.dart';
import 'package:move_together_app/Widgets/Trip/trip_quick_info.dart';
import 'package:move_together_app/core/models/participant.dart';
import 'package:move_together_app/core/services/api_services.dart';
import 'package:move_together_app/utils/show_unified_dialog.dart';

class TripCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final List<Participant> participants;
  final Function() onTap;
  final Function() onRemove;
  final bool isCurrentUserOwner;

  TripCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.participants,
    required this.onTap,
    required this.onRemove,
    required this.isCurrentUserOwner,
  });

  final apiServices = ApiServices();

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
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Row(
                  children: [
                    ParticipantIcons(participants: participants),
                    ...isCurrentUserOwner ? [
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
                            onRemove();
                          },
                        ),
                      ),
                    ] : [],
                  ],
                ),
              ),
              Center(
                heightFactor: BorderSide.strokeAlignCenter,
                child: TripQuickInfo(
                  name: name,
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