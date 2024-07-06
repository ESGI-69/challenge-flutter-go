import 'package:flutter/material.dart';

class TripRow extends StatelessWidget {
  final int tripId;
  final String name;
  final String country;
  final String city;
  final int nbParticipants;
  final Function() onDelete;

  const TripRow({
    super.key,
    required this.tripId,
    required this.name,
    required this.country,
    required this.city,
    required this.nbParticipants,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Row(
              children: [
                Text(name),
              ],
            ),
            const SizedBox(width: 20),
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Colors.blue,
                ),
                Text(country),
              ],
            ),
            const SizedBox(width: 20),
            Row(
              children: [
                const Icon(
                  Icons.location_city,
                  color: Colors.blue,
                ),
                Text(city),
              ],
            ),
            const SizedBox(width: 20),
            Row(
              children: [
                const Icon(
                  Icons.account_circle,
                  color: Colors.blue,
                ),
                Text(nbParticipants.toString()),
              ],
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              style: ButtonStyle(
                iconColor: WidgetStateProperty.all(Colors.red),
                padding: WidgetStateProperty.all(const EdgeInsets.all(0)),
              ),
              onPressed: () {
                onDelete();
              },
              child: const Icon(Icons.delete),
            ),
          ]
        ),
      ),
    );
  }
}