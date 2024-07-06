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
        border: Border.all(color: const Color(0xFFB9F6CA), width: 1),
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFFE8F5E9),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Flex(
              direction: Axis.horizontal,
              children: [
                SizedBox(
                  width: constraints.maxWidth * 0.2,
                  child: Row(
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF263238),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: constraints.maxWidth * 0.2,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Color(0xFF55C0A8),
                      ),
                      Text(
                        country,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF263238),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: constraints.maxWidth * 0.2,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_city,
                        color: Color(0xFF55C0A8),
                      ),
                      Text(
                        city,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF263238),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: constraints.maxWidth * 0.2,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.account_circle,
                        color: Color(0xFF55C0A8),
                      ),
                      Text(
                        nbParticipants.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF263238),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        iconColor: WidgetStateProperty.all(Colors.red),
                        padding: WidgetStateProperty.all(const EdgeInsets.all(0)),
                      ),
                      onPressed: () {
                        onDelete();
                      },
                      child: const Icon(Icons.delete),
                    ),
                  ),
                ),
              ]
            );
          }
        ),
      ),
    );
  }
}