import 'package:flutter/material.dart';
import 'package:move_together_app/Widgets/bottom_sheet_buttons.dart';
import 'package:image_picker/image_picker.dart';

Future<XFile?> pickPhoto(
  BuildContext context,
) async {
  XFile? image;
  final ImagePicker picker = ImagePicker();

  await showBottomSheetButtons(
    context,
    List.from([
      BottomSheetButton(
        text: 'Prendre une photo',
        onPressed: () async {
          image = await picker.pickImage(source: ImageSource.camera);
        },
      ),
      BottomSheetButton(
        text: 'Choisir existante',
        onPressed: () async {
          image = await picker.pickImage(source: ImageSource.gallery);
        },
      )
    ]),
  );

  return image;
}
