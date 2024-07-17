import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Widgets/button.dart';
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
                          fontSize: 10,
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
                          fontSize: 10,
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
                          fontSize: 10,
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
                        "Owner",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF263238),
                          fontSize: 10,
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
                          fontSize: 10,
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
                        Icons.date_range,
                        color: Color(0xFF55C0A8),
                      ),
                      SizedBox(width: 8),
                      Column(
                        children: [
                          Text(
                            "Start-End",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF263238),
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            "Date",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF263238),
                              fontSize: 10,
                            ),
                          ),
                        ],
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
                        Icons.date_range,
                        color: Color(0xFF55C0A8),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Created At",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF263238),
                          fontSize: 10,
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
                        Icons.date_range,
                        color: Color(0xFF55C0A8),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Updated At",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF263238),
                          fontSize: 10,
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
                      fontSize: 10,
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
                    fontSize: 10,
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
                    fontSize: 10,
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
                    fontSize: 10,
                  ),
                ),
              ),
            ),
            TableCell(
              child: Table(
                children: [
                  const TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'ID',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF263238),
                                  fontSize: 10,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Name',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF263238),
                                  fontSize: 10,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                trip.owner!.id.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF263238),
                                  fontSize: 10,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                trip.owner!.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF263238),
                                  fontSize: 10,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ]
                  )
                ],
              ),
            ),
            TableCell(
              child: Table(
                children: [
                  const TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'ID',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF263238),
                                  fontSize: 12,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Name',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF263238),
                                  fontSize: 12,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ]+trip.participants.map((participant) {
                  return TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                participant.id.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF263238),
                                  fontSize: 10,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                participant.username,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF263238),
                                  fontSize: 10,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
            TableCell(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('kk:mm dd-MM-yyyy').format(trip.startDate),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF263238),
                          fontSize: 10,
                        ),
                      ),
                      const Text(
                        "-",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF263238),
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        DateFormat('kk:mm dd-MM-yyyy').format(trip.endDate),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF263238),
                          fontSize: 10,
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
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('kk:mm dd-MM-yyyy').format(trip.createdAt??DateTime.now()),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF263238),
                          fontSize: 10,
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
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('kk:mm dd-MM-yyyy').format(trip.updatedAt??DateTime.now()),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF263238),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            TableCell(
              child: Align(
                alignment: Alignment.center,
                child: Button(
                  type: ButtonType.destructive,
                  onPressed: () {
                    deleteTrip(trip);
                  },
                  icon: Icons.delete,
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}