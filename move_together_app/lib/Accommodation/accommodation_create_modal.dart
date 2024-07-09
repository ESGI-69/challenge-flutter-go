import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/Widgets/Input/cool_date_time_picker.dart';
import 'package:move_together_app/Widgets/Input/cool_text_field.dart';
import 'package:move_together_app/core/models/accommodation.dart';
import 'package:move_together_app/core/services/accommodation_service.dart';

Map<AccommodationType, String> accommodationTypeString = {
  AccommodationType.hotel: 'hotel',
  AccommodationType.airbnb: 'airbnb',
  AccommodationType.other: 'other',
};

class AccommodationCreateModal extends StatefulWidget {
  final Function(Accommodation) onAccommodationCreated;
  final int tripId;

  const AccommodationCreateModal({
    super.key,
    required this.onAccommodationCreated,
    required this.tripId,
  });

  @override
  State<AccommodationCreateModal> createState() => _AccommodationCreateModalState();
}

class _AccommodationCreateModalState extends State<AccommodationCreateModal> {
  AccommodationType _selectedAccommodationType = AccommodationType.hotel;
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bookingUrlController = TextEditingController();
  DateTime _startDateTime = DateTime.fromMillisecondsSinceEpoch(0);
  DateTime _endDateTime = DateTime.fromMillisecondsSinceEpoch(0);

  void createAccommodation() async {
    if (_addressController.text.isEmpty || _startDateTime == DateTime.fromMillisecondsSinceEpoch(0) || _endDateTime == DateTime.fromMillisecondsSinceEpoch(0)) {
      return;
    }
    final createdAccommodation = await AccommodationService(context.read<AuthProvider>()).create(
      tripId: widget.tripId,
      accommodationType: _selectedAccommodationType,
      startDate: _startDateTime,
      endDate: _endDateTime,
      address: _addressController.text,
      name: _nameController.text,
      bookingUrl: _bookingUrlController.text,
    );
    widget.onAccommodationCreated(createdAccommodation);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _Header(),
              Row(
                children: [
                  Expanded(
                    child: CupertinoSlidingSegmentedControl<AccommodationType>(
                      groupValue: _selectedAccommodationType,
                      onValueChanged: (value) => {
                        if (value != null) {
                          setState(() {
                            _selectedAccommodationType = value;
                          })
                        }
                      },
                      children: const <AccommodationType, Widget>{
                        AccommodationType.hotel: Text('Hotel'),
                        AccommodationType.airbnb: Text('Airbnb'),
                        AccommodationType.other: Text('Other'),
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CoolTextField(
                controller: _addressController,
                hintText: 'Adresse du lieu',
                prefixIcon: Icons.location_pin,
              ),
              const SizedBox(height: 8),
              CoolDateTimePicker(
                hintText: 'Date d\'arrivée',
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
              CoolDateTimePicker(
                hintText: 'Date de départ',
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
              const SizedBox(height: 36),
                CoolTextField(
                controller: _nameController,
                hintText: "Nom de l'hébergement",
                prefixIcon: Icons.tag,
              ),
              const SizedBox(height: 8),
              CoolTextField(
                controller: _bookingUrlController,
                hintText: "Url de l'établissement",
                prefixIcon: Icons.link,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: createAccommodation,
                style: _addressController.text.isEmpty || _startDateTime == DateTime.fromMillisecondsSinceEpoch(0) || _endDateTime == DateTime.fromMillisecondsSinceEpoch(0)
                  ? ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(Colors.grey),
                  )
                  : ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(Theme.of(context).primaryColor),
                  ),
                child: const Text(
                  'Créer',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ]
          ),
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
              Expanded(child: 
                Text(
                  'Créer un hébergement',
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