import 'package:flutter/material.dart';

class ButtonLeave extends StatelessWidget {
  final Function() onTap;

  const ButtonLeave({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: Colors.black.withOpacity(0.2),
        child: const Icon(Icons.exit_to_app, color: Colors.white),
      ),
    );
  }
}
