import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CoolDateTimePicker extends StatefulWidget {
  final String hintText;
  final IconData prefixIcon;
  final Function(DateTime)? onDateTimeChanged;
  final Function()? onDateTimeCleared;

  const CoolDateTimePicker({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.onDateTimeChanged,
    this.onDateTimeCleared,
  });

  @override
  State<CoolDateTimePicker> createState() => _CoolDateTimePickerState();
}

class _CoolDateTimePickerState extends State<CoolDateTimePicker> {
  late DateTime _selectedDate = DateTime.fromMicrosecondsSinceEpoch(0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
      ).then((value) {
        if (value != null) {
          setState(() {
            _selectedDate = value;
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
                    _Text(hintText: widget.hintText, selectedDate: _selectedDate),
                  ],
                ),
              ),
              _selectedDate != DateTime.fromMicrosecondsSinceEpoch(0)
                ? GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = DateTime.fromMicrosecondsSinceEpoch(0);
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
        DateFormat.yMMMd().format(selectedDate),
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
      );
    }
  }
}