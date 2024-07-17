import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/Widgets/Input/cool_date_time_picker.dart';
import 'package:move_together_app/Widgets/Input/cool_text_field.dart';
import 'package:move_together_app/core/models/transport.dart';
import 'package:move_together_app/core/services/transport_service.dart';
import 'package:move_together_app/Widgets/Input/cool_number_field.dart';

import 'package:move_together_app/Widgets/button.dart';
import 'package:move_together_app/utils/exception_to_string.dart';

Map<TransportType, String> transportTypeString = {
  TransportType.car: 'car',
  TransportType.plane: 'plane',
  TransportType.bus: 'bus',
};

class TransportCreateModal extends StatefulWidget {
  final Function(Transport) onTransportCreated;
  final int tripId;

  const TransportCreateModal({
    super.key,
    required this.onTransportCreated,
    required this.tripId,
  });

  @override
  State<TransportCreateModal> createState() => _TransportCreateModalState();
}

class _TransportCreateModalState extends State<TransportCreateModal> {
  TransportType _selectedTransportType = TransportType.car;
  final TextEditingController _startAddressController = TextEditingController();
  final TextEditingController _endAddressController = TextEditingController();
  DateTime _startDateTime = DateTime.fromMillisecondsSinceEpoch(0);
  DateTime _endDateTime = DateTime.fromMillisecondsSinceEpoch(0);
  final TextEditingController _meetingAddressController =
      TextEditingController();
  DateTime _meetingDateTime = DateTime.fromMillisecondsSinceEpoch(0);
  final TextEditingController _priceController = TextEditingController();

  void createTransport() async {
    if (_startAddressController.text.isEmpty ||
        _endAddressController.text.isEmpty ||
        _startDateTime == DateTime.fromMillisecondsSinceEpoch(0) ||
        _endDateTime == DateTime.fromMillisecondsSinceEpoch(0) ||
        _priceController.text.isEmpty) {
      return;
    }

    try {
      final createdTransport =
          await TransportService(context.read<AuthProvider>()).create(
        tripId: widget.tripId,
        transportType: _selectedTransportType,
        startDate: _startDateTime,
        endDate: _endDateTime,
        startAddress: _startAddressController.text,
        endAddress: _endAddressController.text,
        price: double.parse(_priceController.text),
        meetingAddress: _meetingAddressController.text,
        meetingTime: _meetingDateTime,
      );
      widget.onTransportCreated(createdTransport);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(exceptionToString(error)),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        margin: const EdgeInsets.only(bottom: 32),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const _Header(),
            Row(
              children: [
                Expanded(
                  child: CupertinoSlidingSegmentedControl<TransportType>(
                    groupValue: _selectedTransportType,
                    onValueChanged: (value) => {
                      if (value != null)
                        {
                          setState(() {
                            _selectedTransportType = value;
                          })
                        }
                    },
                    children: const <TransportType, Widget>{
                      TransportType.car: Text('Voiture'),
                      TransportType.plane: Text('Avion'),
                      TransportType.bus: Text('Bus'),
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            CoolTextField(
              controller: _startAddressController,
              hintText: 'Adresse de départ',
              prefixIcon: Icons.flight_takeoff,
            ),
            const SizedBox(height: 8),
            CoolDateTimePicker(
              hintText: 'Date de départ',
              prefixIcon: Icons.calendar_today,
              onDateTimeChanged: (DateTime dateTime) {
                setState(() {
                  _startDateTime = dateTime;
                });
              },
              onDateTimeCleared: () {
                setState(() {
                  _startDateTime = DateTime.fromMillisecondsSinceEpoch(0);
                });
              },
            ),
            const SizedBox(height: 8),
            CoolTextField(
              controller: _endAddressController,
              hintText: 'Adresse d\'arrivée',
              prefixIcon: Icons.flight_land,
            ),
            const SizedBox(height: 8),
            CoolDateTimePicker(
              hintText: 'Date d\'arrivée',
              prefixIcon: Icons.calendar_today,
              onDateTimeChanged: (DateTime dateTime) {
                setState(() {
                  _endDateTime = dateTime;
                });
              },
              onDateTimeCleared: () {
                setState(() {
                  _endDateTime = DateTime.fromMillisecondsSinceEpoch(0);
                });
              },
            ),
            const SizedBox(height: 8),
            CoolTextField(
              controller: _meetingAddressController,
              hintText: 'Adresse de rendez-vous',
              prefixIcon: Icons.groups,
            ),
            const SizedBox(height: 8),
            CoolDateTimePicker(
              hintText: 'Date de rendez-vous',
              prefixIcon: Icons.calendar_today,
              onDateTimeChanged: (DateTime dateTime) {
                setState(() {
                  _meetingDateTime = dateTime;
                });
              },
              onDateTimeCleared: () {
                setState(() {
                  _meetingDateTime = DateTime.fromMillisecondsSinceEpoch(0);
                });
              },
            ),
            const SizedBox(height: 8),
            CoolNumberField(
              controller: _priceController,
              hintText: 'Prix',
              prefixIcon: Icons.euro,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: createTransport,
              style: _startAddressController.text.isEmpty ||
                      _endAddressController.text.isEmpty ||
                      _startDateTime ==
                          DateTime.fromMillisecondsSinceEpoch(0) ||
                      _endDateTime == DateTime.fromMillisecondsSinceEpoch(0)
                  ? ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all<Color>(Colors.grey),
                    )
                  : ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                          Theme.of(context).primaryColor),
                    ),
              child: const Text(
                'Créer',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 16,
      ),
      child: Column(
        children: [
          const SizedBox(height: 4),
          Container(
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 4),
          const Row(
            children: [
              Expanded(
                child: Text(
                  'Créer un moyen de transport',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
