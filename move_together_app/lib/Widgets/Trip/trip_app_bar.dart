import 'package:flutter/material.dart';
import 'package:move_together_app/Widgets/Button/button_back.dart';
import 'package:move_together_app/Widgets/Participant/participant_icons.dart';
import 'package:move_together_app/Widgets/Trip/trip_quick_info.dart';
import 'package:move_together_app/core/models/participant.dart';

class TripAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String city;
  final String date;
  final List<Participant> participants;

  const TripAppBar({
    super.key, 
    required this.city,
    required this.date,
    required this.participants,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
                city: city,
                date: date,
              )
            ),
          ],
        )
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 100);
}