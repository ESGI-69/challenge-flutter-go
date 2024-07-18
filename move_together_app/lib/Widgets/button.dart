import 'package:flutter/material.dart';

enum ButtonType {
  primary,
  classic,
  destructive,
  disabled,
}

class Button extends StatelessWidget {
  final String? text;
  final Function() onPressed;
  final double? width;
  final BorderRadius? borderRadius;
  final ButtonType type;
  final IconData? icon;

  const Button({
    super.key,
    this.text,
    required this.onPressed,
    this.width,
    this.borderRadius,
    this.type = ButtonType.classic,
    this.icon,
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
      } else if (type == ButtonType.disabled) {
        return Colors.grey;
      } else {
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) Icon(icon, color: textColor()),
              if (icon != null) const SizedBox(width: 5),
              Flexible(
                child: Text(
                  text ?? '',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textColor(),
                
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
