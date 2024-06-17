import 'package:flutter/material.dart';

class ButtonDelete extends StatelessWidget {
  final Function() onTap;

  const ButtonDelete({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: Colors.black.withOpacity(0.2),
        child: const Icon(Icons.delete_forever, color: Colors.white),
      ),
    );
  }
}