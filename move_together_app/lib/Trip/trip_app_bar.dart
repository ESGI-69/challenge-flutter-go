import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:move_together_app/Widgets/Button/button_back.dart';
import 'package:move_together_app/Widgets/Dialog/edit_trip_name.dart';
import 'package:move_together_app/Widgets/Participant/participant_icons.dart';
import 'package:move_together_app/Trip/trip_quick_info.dart';
import 'package:move_together_app/core/models/participant.dart';

class TripAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final List<Participant> participants;
  final bool isLoading;
  final Function(String) onNameUpdate;
  final String imageUrl;

  const TripAppBar({
    super.key, 
    this.isLoading = false,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.participants,
    required this.onNameUpdate,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
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
        title: ParticipantIcons(participants: participants),
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
                        onNameUpdate: onNameUpdate,
                      )
                    );
                  }
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