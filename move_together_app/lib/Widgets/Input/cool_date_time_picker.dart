import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CoolDateTimePicker extends StatefulWidget {
  final String hintText;
  final IconData prefixIcon;
  final Function(DateTime)? onDateTimeChanged;
  final Function()? onDateTimeCleared;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const CoolDateTimePicker({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.onDateTimeChanged,
    this.onDateTimeCleared,
    this.initialDate,
    this.firstDate,
    this.lastDate,
  });

  @override
  State<CoolDateTimePicker> createState() => _CoolDateTimePickerState();
}

class _CoolDateTimePickerState extends State<CoolDateTimePicker> {
  late DateTime _selectedDateTime = DateTime.fromMicrosecondsSinceEpoch(0);

  @override
  Widget build(BuildContext context) {
    Future<DateTime?> showDateTimePicker({
      required DateTime? initialDate,
      required DateTime? firstDate,
      required DateTime? lastDate,
    }) async {
      initialDate ??= DateTime.now();
      firstDate ??= initialDate.subtract(const Duration(days: 365 * 100));
      lastDate ??= firstDate.add(const Duration(days: 365 * 200));

      final DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
      );

      print('Selected date $selectedDate');

      if (selectedDate == null) return null;

      if (!context.mounted) return selectedDate;

      final TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      print('Selected time $selectedTime');

      return selectedTime == null
        ? selectedDate
        : DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
    }
    
    return GestureDetector(
      onTap: () => showDateTimePicker(
        initialDate: widget.initialDate,
        firstDate: widget.firstDate,
        lastDate: widget.lastDate,
      ).then((value) {
        print(value);
        if (value != null) {
          setState(() {
            _selectedDateTime = value;
          });
          widget.onDateTimeChanged?.call(value);
        }
      }),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(widget.prefixIcon, color: Theme.of(context).primaryColor),
                    const SizedBox(width: 12),
                    _Text(hintText: widget.hintText, selectedDate: _selectedDateTime),
                  ],
                ),
              ),
              _selectedDateTime != DateTime.fromMicrosecondsSinceEpoch(0)
                ? GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDateTime = DateTime.fromMicrosecondsSinceEpoch(0);
                    });
                    widget.onDateTimeCleared?.call();
                  },
                  child: Icon(
                    Icons.clear_rounded,
                    color: Theme.of(context).hintColor,
                    size: 16,
                  ),
                )
                : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Text extends StatelessWidget {
  final String hintText;
  final DateTime selectedDate;

  const _Text({
    required this.hintText,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedDate == DateTime.fromMicrosecondsSinceEpoch(0)) {
      return Text(
        hintText,
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).hintColor,
          fontWeight: FontWeight.w500,
        ),
      );
    } else {
      return Text(
        DateFormat.yMMMd().add_Hm().format(selectedDate.toLocal()),
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
      );
    }
  }
}