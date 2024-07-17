import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ButtonBack extends StatelessWidget {
  const ButtonBack({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pop();
      },
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Icon(
          Icons.arrow_back_ios_new,
          color: Theme.of(context).primaryColor,
          size: 20,
        ),
      ),
    );
  }
}
