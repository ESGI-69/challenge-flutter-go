import 'package:flutter/cupertino.dart';

import 'button.dart';

class ButtonsGroup extends StatelessWidget {
  final List<Button> buttons;

  const ButtonsGroup({
    super.key,
    required this.buttons,
  });

  @override
  Widget build(BuildContext context) {
    int buttonLength = buttons.length;
    return Column(
      children: [
        ...buttons.asMap().entries.map(
          (entry) {
            int index = entry.key;
            Button button = entry.value;
            BorderRadius borderRadius = BorderRadius.circular(10.0);

            if ( index == 0 && buttonLength > 1) {
              borderRadius = const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              );
            } else if (index == buttonLength - 1 && buttonLength > 1) {
              borderRadius = const BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              );
            }
            return Button(
              width: double.infinity,
              onPressed: button.onPressed,
              text: button.text,
              borderRadius: borderRadius,
            );
          }
        ),
      ],

    );
  }
}
