import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:move_together_app/core/models/document.dart';

class DocumentRow extends StatelessWidget {
  final Document document;
  final void Function() onTap;

  const DocumentRow({
    super.key,
    required this.document,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
                Icons.description,
                color: Theme.of(context).primaryColor,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Wrap(
                  children: [
                    Text(
                      "${document.title} - ${DateFormat.yMMMd().format(document.createdAt)}",
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.black38, size: 16)
            ],
          ),
        ),
      ),
    );
  }
}