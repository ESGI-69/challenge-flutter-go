import 'package:flutter/material.dart';
import '../../core/models/trip.dart';

class TripsTable extends StatelessWidget {
  final List<Trip> trips;
  final Function deleteTrip;

  const TripsTable({
    super.key,
    required this.trips,
    required this.deleteTrip,
  });

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(
        color: const Color(0xFF81C784),
        width: 2,
        borderRadius: const BorderRadius.all(Radius.elliptical(10, 10))
      ),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        const TableRow(
          decoration: BoxDecoration(
            color: Color(0xFFB9F6CA),
          ),
          children: [
            TableCell(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.title),
                      SizedBox(width: 8),
                      Text(
                        'Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF263238),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            TableCell(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Color(0xFF55C0A8),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Country",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF263238),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            TableCell(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_city,
                        color: Color(0xFF55C0A8),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "City",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF263238),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            TableCell(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.account_circle,
                        color: Color(0xFF55C0A8),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Participants",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF263238),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            TableCell(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Actions",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF263238),
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ] +
      trips.map((trip) {
        return TableRow(
          decoration: const BoxDecoration(
            color: Color(0xFFE8F5E9),
          ),
          children: [
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  trip.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF263238),
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  trip.country,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF263238),
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  trip.city,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF263238),
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  trip.participants.length.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF263238),
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            TableCell(
              child: Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all(Colors.red),
                    padding: WidgetStateProperty.all(const EdgeInsets.all(0)),
                  ),
                  onPressed: () {
                    deleteTrip(trip);
                  },
                  child: const Icon(Icons.delete),
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}