import 'package:flutter/material.dart';
import 'package:move_together_app/core/models/activity.dart';

class ActivityRow extends StatelessWidget {
  final Activity activity;
  final void Function() onTap;

  const ActivityRow({
    super.key,
    required this.activity,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const activityIcon = Icons.hiking;
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
                activityIcon,
                color: Theme.of(context).primaryColor,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Wrap(
                  children: [
                    Text(
                      activity.name,
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
