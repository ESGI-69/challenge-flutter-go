import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:move_together_app/Photo/photo_info.dart';
import 'package:move_together_app/Provider/auth_provider.dart';

class PhotoItem extends StatelessWidget {
  final String photoUrl;

  const PhotoItem({
    super.key,
    required this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showCupertinoModalBottomSheet(
          context: context,
          builder: (context) => PhotoInfo(photoUrl: photoUrl)
        );
      },
      child: Image.network(
        photoUrl,
        fit: BoxFit.cover,
        headers: {
          'Authorization': context.read<AuthProvider>().getAuthorizationHeader(),
        },
      ),
    );
  }
}