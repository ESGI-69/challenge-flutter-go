import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/Widgets/Input/cool_date_time_picker.dart';
import 'package:move_together_app/Widgets/Input/cool_number_field.dart';
import 'package:move_together_app/Widgets/Input/cool_text_field.dart';
import 'package:move_together_app/core/models/activity.dart';
import 'package:move_together_app/core/services/activity_service.dart';

import 'package:move_together_app/Widgets/button.dart';

class ActivityCreateModal extends StatefulWidget {
  final Function(Activity) onActivityCreated;
  final int tripId;

  const ActivityCreateModal({
    super.key,
    required this.onActivityCreated,
    required this.tripId,
  });

  @override
  State<ActivityCreateModal> createState() => _ActivityCreateModalState();
}

class _ActivityCreateModalState extends State<ActivityCreateModal> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _startDateTime = DateTime.fromMillisecondsSinceEpoch(0);
  DateTime _endDate = DateTime.fromMillisecondsSinceEpoch(0);
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  bool cantPost() {
    return _nameController.text.isEmpty ||
        _startDateTime == DateTime.fromMillisecondsSinceEpoch(0) ||
        _endDate == DateTime.fromMillisecondsSinceEpoch(0) ||
        _priceController.text.isEmpty;
  }

  void createActivity() async {
    if (cantPost()) {
      return;
    }
    final createdActivity =
        await ActivityService(context.read<AuthProvider>()).create(
      tripId: widget.tripId,
      name: _nameController.text,
      description: _descriptionController.text,
      endDate: _endDate,
      startDate: _startDateTime,
      location: _locationController.text,
      price: double.parse(_priceController.text),
    );
    widget.onActivityCreated(createdActivity);
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
            const SizedBox(height: 8),
            CoolTextField(
              controller: _nameController,
              hintText: 'Titre',
              prefixIcon: Icons.title,
            ),
            const SizedBox(height: 8),
            CoolTextField(
              controller: _descriptionController,
              hintText: 'Description',
              prefixIcon: Icons.description,
            ),
            const SizedBox(height: 8),
            CoolDateTimePicker(
              hintText: 'Date de début',
              prefixIcon: Icons.calendar_today,
              onDateTimeChanged: (dateTime) {
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
              hintText: 'Date de fin',
              prefixIcon: Icons.calendar_today,
              onDateTimeChanged: (dateTime) {
                setState(() {
                  _endDate = dateTime;
                });
              },
              onDateTimeCleared: () {
                setState(() {
                  _endDate = DateTime.fromMillisecondsSinceEpoch(0);
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
            CoolTextField(
              controller: _locationController,
              hintText: 'Lieu',
              prefixIcon: Icons.location_on,
            ),
            const SizedBox(height: 8),
            Button(
              onPressed: createActivity,
              type: cantPost() ? ButtonType.disabled : ButtonType.primary,
              text: 'Créer',
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
                  'Créer une activité',
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
