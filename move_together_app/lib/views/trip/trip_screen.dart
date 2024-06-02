import 'package:flutter/material.dart';

class TripScreen extends StatelessWidget {
  const TripScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip'),
      ),
      body: Center(
        child: const Text(
          'Welcome to the trip!(placeholder page)',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}