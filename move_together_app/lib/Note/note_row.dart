import 'package:flutter/material.dart';
import 'package:move_together_app/core/models/note.dart';

class NoteRow extends StatelessWidget {
  final Note note;
  final void Function() onTap;

  const NoteRow({
    super.key,
    required this.note,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const noteIcon = Icons.note;
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
                noteIcon,
                color: Theme.of(context).primaryColor,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Wrap(
                  children: [
                    Text(
                      note.title,
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
