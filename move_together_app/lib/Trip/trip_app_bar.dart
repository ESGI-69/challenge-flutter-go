import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:move_together_app/Widgets/Button/button_back.dart';
import 'package:move_together_app/Widgets/Participant/participant_icons.dart';
import 'package:move_together_app/Trip/trip_quick_info.dart';
import 'package:move_together_app/core/models/participant.dart';

class TripAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final List<Participant> participants;
  final bool isLoading;

  const TripAppBar({
    super.key, 
    this.isLoading = false,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.participants,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        title: const CircularProgressIndicator.adaptive(),
        // Ajoutez des styles ou des widgets personnalisés ici
        flexibleSpace: SizedBox(
          height: preferredSize.height + 10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Center(
                heightFactor: BorderSide.strokeAlignCenter,
                child: TripQuickInfo(
                  isLoading: true,
                  name: '',
                  startDate: DateTime.now(),
                  endDate: DateTime.now(),
                )
              ),
            ],
          )
        ),
      );
    } else {
      return AppBar(
        backgroundColor: Colors.transparent,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Row(
            children: [
              ButtonBack(),
            ],
          ),
        ),
        title: ParticipantIcons(participants: participants),
        // Ajoutez des styles ou des widgets personnalisés ici
        flexibleSpace: Container(
          height: preferredSize.height + 10,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/a/a8/Tour_Eiffel_Wikimedia_Commons.jpg/260px-Tour_Eiffel_Wikimedia_Commons.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Center(
                heightFactor: BorderSide.strokeAlignCenter,
                child: TripQuickInfo(
                  name: name,
                  startDate: startDate,
                  endDate: endDate,
                )
              ),
            ],
          )
        ),
      );
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 100);
}