import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'button.dart';
import 'buttons_group.dart';

class BottomSheetButton {
  final String text;
  final Future Function() onPressed;

  const BottomSheetButton({
    required this.text,
    required this.onPressed,
  });
}

class BottomSheetButtons extends StatelessWidget {
  final List<BottomSheetButton> buttons;

  const BottomSheetButtons({super.key, required this.buttons});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 16.0,
        left: 16.0,
        right: 16.0,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      height: 200,
      color: Colors.transparent,
      child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        ButtonsGroup(
          buttons: buttons
              .map((button) => Button(
                    text: button.text,
                    onPressed: () async {
                      await button.onPressed();
                      context.pop();
                    },
                    width: double.infinity,
                  ))
              .toList(),
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
          type: ButtonType.destructive,
        ),
      ]),
    );
  }
}

Future showBottomSheetButtons(
    BuildContext context, List<BottomSheetButton> buttons) {
  return showMaterialModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    elevation: 0,
    builder: (context) => BottomSheetButtons(buttons: buttons),
  );
}
