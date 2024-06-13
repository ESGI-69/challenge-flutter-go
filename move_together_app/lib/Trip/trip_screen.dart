import 'package:flutter/material.dart';
import 'package:move_together_app/Widgets/Trip/trip_app_bar.dart';
import 'package:move_together_app/core/models/trip.dart';

class TripScreen extends StatelessWidget {
  final Trip trip;

  const TripScreen({
    super.key,
    required this.trip,
  });

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: TripAppBar(
        city: trip.city,
        date: trip.startDate.toString(),
        participants: trip.participants,
      ),
      body: const Text(
        'Welcome to the trip!(placeholder page)',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
