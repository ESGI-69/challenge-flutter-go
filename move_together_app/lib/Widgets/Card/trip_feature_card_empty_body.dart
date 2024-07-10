import 'package:flutter/material.dart';

class TripFeatureCardEmptyBody extends StatelessWidget {
  final String message;

  const TripFeatureCardEmptyBody({
    super.key, 
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Text(
          message,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}