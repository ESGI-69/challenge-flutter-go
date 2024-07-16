import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'button.dart';
import 'buttons_group.dart';

class BottomSheetButtons extends StatelessWidget {
  final List<Button> buttons;

  const BottomSheetButtons({
    super.key,
    required this.buttons
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 200,
      color: Colors.transparent,
      child: Column(
        children: [
          ButtonsGroup(buttons: buttons.map((button) => Button(
              text: button.text,
              onPressed: () {
                button.onPressed();
                context.pop();
              },
              isDestructive: button.isDestructive,
              width: double.infinity,
            )).toList(),
          ),
          const SizedBox(
            height: 16,
          ),
          Button(
            onPressed: () {
              context.pop();
            },
            width: double.infinity,
            text: 'Annuler',
            isDestructive: true,
          )
        ]
      ),
    );
  }
}

Future showBottomSheetButtons(BuildContext context, List<Button> buttons) {
  return showCupertinoModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    elevation: 0,
    builder: (context) => BottomSheetButtons(buttons: buttons),
  );
}
