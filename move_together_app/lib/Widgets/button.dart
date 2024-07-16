import 'package:flutter/material.dart';

enum ButtonType {
  primary,
  classic,
  destructive,
}

class Button extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final double? width;
  final BorderRadius? borderRadius;
  final ButtonType type;

  const Button({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.borderRadius,
    this.type = ButtonType.classic,
  });

  @override
  Widget build(BuildContext context) {
    Color textColor() {
      if (type == ButtonType.classic) {
        return Colors.black;
      } else if (type == ButtonType.destructive) {
        return Colors.red;
      } else {
        return Colors.white;
      }
    }

    Color backgroundColor() {
      if (type == ButtonType.classic || type == ButtonType.destructive) {
        return Colors.white;
      }else {
        return Theme.of(context).primaryColor;
      }
    }

    return SizedBox(
      width: width,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            backgroundColor: WidgetStateProperty.all<Color>(backgroundColor()),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: borderRadius ?? BorderRadius.circular(10.0),
              ),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: textColor(),
            )
          )
      ),
    );
  }
}
