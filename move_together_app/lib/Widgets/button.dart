import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final bool isDestructive;
  final double? width;
  final BorderRadius? borderRadius;

  const Button({
    super.key,
    required this.text,
    required this.onPressed,
    this.isDestructive = false,
    this.width,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: borderRadius ?? BorderRadius.circular(10.0),
              ),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isDestructive ? Colors.red : Colors.black,
            )
          )
      ),
    );
  }
}
