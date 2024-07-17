import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:move_together_app/core/models/accommodation.dart';

class AccommodationRow extends StatelessWidget {
  final Accommodation accommodation;
  final void Function() onTap;

  const AccommodationRow({
    super.key,
    required this.accommodation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final accommodationIcon = {
      AccommodationType.hotel: Icons.hotel,
      AccommodationType.airbnb: Icons.home_work_rounded,
      AccommodationType.other: Icons.houseboat,
    };
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black12,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 8,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                accommodationIcon[accommodation.accommodationType],
                color: Theme.of(context).primaryColor,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Wrap(
                  children: [
                    Text(
                      "${accommodation.address}, ${DateFormat.yMMMd().format(accommodation.startDate)}",
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios,
                  color: Colors.black38, size: 16)
            ],
          ),
        ),
      ),
    );
  }
}
