import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showUnifiedDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String cancelButtonText,
  required String okButtonText,
  required Function() onCancelPressed,
  required Function() onOkPressed,
  TextStyle? cancelButtonTextStyle = const TextStyle(),
  TextStyle? okButtonTextStyle = const TextStyle(),
}) {
  final isIos = Theme.of(context).platform == TargetPlatform.iOS;

  if (isIos) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              CupertinoDialogAction(
                onPressed: onCancelPressed,
                isDefaultAction: true,
                textStyle: cancelButtonTextStyle,
                child: Text(cancelButtonText),
              ),
              CupertinoDialogAction(
                onPressed: onOkPressed,
                isDefaultAction: true,
                textStyle: okButtonTextStyle,
                child: Text(okButtonText),
              ),
            ],
          );
        });
  } else {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: onCancelPressed,
              child: Text(
                cancelButtonText,
                style: cancelButtonTextStyle,
              ),
            ),
            TextButton(
              onPressed: onOkPressed,
              child: Text(
                okButtonText,
                style: cancelButtonTextStyle,
              ),
            ),
          ],
        );
      },
    );
  }
}
