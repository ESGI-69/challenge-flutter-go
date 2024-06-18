import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:move_together_app/Widgets/Button/button_back.dart';
import 'package:move_together_app/core/models/trip.dart';
import 'package:move_together_app/Trip/blocs/trip_bloc.dart';

class CreateTripScreen extends StatefulWidget {
  const CreateTripScreen({super.key});

  @override
  _CreateTripScreenState createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TripBloc _tripBloc = TripBloc();

  var dateTimeStart = DateTime.now();
  var dateTimeEnd = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Row(
            children: [
              ButtonBack(),
            ],
          ),
        ),
      ),
      body: 
      BlocProvider(
        create: (context) => _tripBloc,
        child: BlocListener<TripBloc, TripState>(
          listener: (context, state) {
            if (state is TripDataLoadingSuccess) {
              context.push('/trip/${state.trip.id}', extra: state.trip);
            }
          },
          child: BlocBuilder<TripBloc, TripState>(
            builder: (context, state) {
              if (state is TripDataLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is TripDataLoadingError) {
                return Center(
                  child: Text(state.errorMessage),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Nouveau Voyage', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 20),
                            const Text('Où veux-tu aller ?', style: TextStyle(fontWeight: FontWeight.bold)),
                            TextField(
                              controller: _destinationController,
                              decoration: const InputDecoration(
                                hintText: 'Ville, pays, région...',
                                prefixIcon: Icon(Icons.place, color: Color(0xFF79D0BF)),
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text('Nom du voyage ?', style: TextStyle(fontWeight: FontWeight.bold)),
                            TextField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                hintText: 'Paris 2024, JO Tokyo...',
                                prefixIcon: Icon(Icons.tag, color: Color(0xFF79D0BF)),
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text('Plus d\'infos', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            flex: 10,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final DateTimeRange? selectedDateRange = await showDateRangePicker(
                                  context: context,
                                  firstDate: DateTime(DateTime.now().month - 1),
                                  lastDate: DateTime(DateTime.now().year + 1),
                                );

                                if (selectedDateRange != null) {
                                  setState(() {
                                    dateTimeStart = selectedDateRange.start;
                                    dateTimeEnd = selectedDateRange.end;
                                    _dateController.text = '${selectedDateRange.start.day}/${selectedDateRange.start.month} - ${selectedDateRange.end.day}/${selectedDateRange.end.month}';
                                  });
                                 }
                              },
                              icon: const Icon(Icons.calendar_month),
                              label: Text(_dateController.text.isNotEmpty ? _dateController.text : 'Date', style: TextStyle(fontWeight: FontWeight.bold)),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const Expanded(
                            flex: 1,
                            child: SizedBox(width: 5),
                          ),
                          Expanded(
                            flex: 10,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                //removed the old showDialog to pick users, might be used later so we keep it fornow
                              },
                              icon: const Icon(Icons.person),
                              label: const Text('Voyageur (1)', style: TextStyle(fontWeight: FontWeight.bold)),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      ElevatedButton(
                        onPressed: () {
                          if(_destinationController.text.isEmpty || _dateController.text.isEmpty || _nameController.text.isEmpty) {
                            return;
                          }
                          final String destination = _destinationController.text;
                          final String nameTrip = _nameController.text;
                          //TODO coté backend, on recuperera le pays/ville selon la destination
                          final Trip newTrip = Trip(
                            id: 0,
                            name: nameTrip,
                            country: destination,
                            city: destination,
                            startDate: dateTimeStart,
                            endDate: dateTimeEnd,
                            participants: [],
                            inviteCode: "null",
                          );
                          context.read<TripBloc>().add(TripDataCreateTrip(newTrip));
                            setState(() {});
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                            _destinationController.text.isEmpty || _dateController.text.isEmpty || _nameController.text.isEmpty
                                ? Colors.grey
                                : const Color(0xFF79D0BF),
                          ),
                          foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.symmetric(vertical: 10.0)
                          ),
                          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                          minimumSize: WidgetStateProperty.all<Size>(const Size(double.infinity, 0)),
                        ),
                        child: const Text('Ajoute un voyage'),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        )
      )
    );
  }
}
