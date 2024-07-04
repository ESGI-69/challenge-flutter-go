import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/Widgets/Button/button_back.dart';
import 'package:move_together_app/Widgets/Dialog/edit_trip_name.dart';
import 'package:move_together_app/Widgets/Button/button_chat.dart';
import 'package:move_together_app/Widgets/Participant/participant_icons.dart';
import 'package:move_together_app/Trip/trip_quick_info.dart';
import 'package:move_together_app/core/models/participant.dart';
import 'package:move_together_app/core/services/trip_service.dart';

class TripAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final List<Participant> participants;
  final bool isLoading;
  final Function(String) onNameUpdate;
  final Function(DateTime, DateTime) onDateUpdate;
  final Function() onParticipantsTap;
  final String imageUrl;
  final int tripId;
  final bool userHasEditRights;

  const TripAppBar({
    super.key,
    this.isLoading = false,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.participants,
    required this.onNameUpdate,
    required this.onDateUpdate,
    required this.onParticipantsTap,
    required this.imageUrl,
    required this.tripId,
    this.userHasEditRights = false,
  });

  @override
  Widget build(BuildContext context) {
    void nameEdit(String name) async {
      await TripService(context.read<AuthProvider>()).edit(
        tripId,
        name: name,
      );
      onNameUpdate(name);
    }

    void dateEdit(DateTime startDate, DateTime endDate) async {
      await TripService(context.read<AuthProvider>()).edit(
        tripId,
        startDate: startDate,
        endDate: endDate,
      );
      onDateUpdate(startDate, endDate);
    }

    if (isLoading) {
      return AppBar(
        forceMaterialTransparency: true,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Row(
            children: [
              ButtonBack(),
            ],
          ),
        ),
        title: const CircularProgressIndicator.adaptive(),
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.centerLeft,
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: TripQuickInfo(
                  isLoading: true,
                  name: '',
                  startDate: DateTime.now(),
                  endDate: DateTime.now(),
                  onNameTap: () {},
                  onDateTap: () {},
                ),
              )
            ],
          ),
        ),
      );
    } else {
      return AppBar(
        forceMaterialTransparency: true,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Row(
            children: [
              ButtonBack(),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ButtonChat(
              tripId: tripId,
              tripName: name,
            ),
          ),
        ],
        title: ParticipantIcons(
          participants: participants,
          onTap: onParticipantsTap,
        ),
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.centerLeft,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 35),
                child: Image(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: TripQuickInfo(
                  name: name,
                  startDate: startDate,
                  endDate: endDate,
                  onNameTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => EditTripNameDialog(
                          onNameUpdate: nameEdit,
                        )
                    );
                  },
                  onDateTap: () async {
                    final DateTimeRange? newDateRange = await showDateRangePicker(
                      context: context,
                      initialDateRange: DateTimeRange(
                        start: startDate.toLocal(),
                        end: endDate.toLocal(),
                      ),
                      firstDate: DateTime(DateTime.now().year - 5).toLocal(),
                      lastDate: DateTime(DateTime.now().year + 5).toLocal(),
                    );
                    if (newDateRange != null) {
                      dateEdit(newDateRange.start, newDateRange.end);
                    }
                  },
                  userHasEditRights: userHasEditRights,
                ),
              )
            ],
          ),
        ),
      );
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 90);
}
