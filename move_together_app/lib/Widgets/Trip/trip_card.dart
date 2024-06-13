import 'package:flutter/material.dart';
import 'package:move_together_app/Widgets/Trip/trip_quick_info.dart';
import 'package:move_together_app/core/models/participant.dart';

class TripCard extends StatelessWidget {
  final String imageUrl;
  final String city;
  final String date;
  final List<Participant> participants;
  final Function() onTap;

  const TripCard({
    super.key,
    required this.imageUrl,
    required this.city,
    required this.date,
    required this.participants,
    required this.onTap,
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
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Row(
                  children: [
                    Row(
                      children: participants.map((participant) {
                        return Container(
                          margin: const EdgeInsets.only(right: 4),
                          child: CircleAvatar(
                            child: Center(
                              child: Text(
                                participant.username[0].toUpperCase(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
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
                    CircleAvatar(
                      backgroundColor: Colors.black.withOpacity(0.2),
                      child: const Icon(Icons.exit_to_app, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Center(
                heightFactor: BorderSide.strokeAlignCenter,
                child: TripQuickInfo(
                  city: city,
                  date: date,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}