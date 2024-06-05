import 'package:flutter/material.dart';

class TripScreen extends StatelessWidget {
  const TripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip'),
      ),
      body: const Center(
        child: Text(
          'Welcome to the trip!(placeholder page)',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}