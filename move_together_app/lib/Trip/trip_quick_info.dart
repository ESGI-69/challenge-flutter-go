import 'package:flutter/material.dart';

class TripQuickInfo extends StatelessWidget {
  final String name;
  final String country;
  final String city;
  final DateTime startDate;
  final DateTime endDate;
  final bool isLoading;
  final Function()? onNameTap;
  final Function()? onDateTap;
  final bool userHasEditRights;

  const TripQuickInfo({
    super.key,
    this.isLoading = false,
    this.userHasEditRights = false,
    required this.name,
    required this.country,
    required this.city,
    required this.startDate,
    required this.endDate,
    this.onNameTap,
    this.onDateTap,
  });

  void onNameTapHandler() {
    if (onNameTap == null) return;
    if (!userHasEditRights) return;
    onNameTap!();
  }

  void onDateTapHandler() {
    if (onDateTap == null) return;
    if (!userHasEditRights) return;
    onDateTap!();
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.7,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4), // Adjust vertical padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: isLoading
              ? [
            const Text(
              'Chargement...',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2), // Adjust vertical spacing
            const CircularProgressIndicator.adaptive(),
          ]
              : [
            GestureDetector(
              onTap: onNameTapHandler,
              child: Text(
                name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Reduced font size
              ),
            ),
            const SizedBox(height: 2), // Adjust vertical spacing
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_on, size: 14), // Reduced icon size
                const SizedBox(width: 2), // Adjust horizontal spacing
                Text(
                  '$city, $country',
                  style: const TextStyle(
                    fontSize: 14, // Reduced font size
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2), // Adjust vertical spacing
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.calendar_month, size: 14), // Reduced icon size
                const SizedBox(width: 2), // Adjust horizontal spacing
                GestureDetector(
                  onTap: onDateTapHandler,
                  child: Text(
                    '${startDate.toLocal().toString().replaceAll('-', '/').split(' ')[0]} - ${endDate.toLocal().toString().replaceAll('-', '/').split(' ')[0]}',
                    style: const TextStyle(
                      fontSize: 14, // Reduced font size
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
