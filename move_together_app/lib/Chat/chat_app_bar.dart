import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:move_together_app/Widgets/Button/button_back.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String tripName;

  const ChatAppBar({
    super.key,
    required this.tripName,
  });

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey, // Change this color to match your design
            width: 1.0, // Change this width to match your design
          ),
        ),
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: ButtonBack(),
        ),
        title: Text(tripName),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(40.0); // Change this value to adjust the height
}
