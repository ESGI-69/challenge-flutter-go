import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:move_together_app/Photo/photo_info.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/core/models/photo.dart';

class PhotoItem extends StatelessWidget {
  final int tripId;
  final Photo photo;
  final Function(Photo) onDeleteSuccess;

  const PhotoItem({
    super.key,
    required this.tripId,
    required this.photo,
    required this.onDeleteSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showCupertinoModalBottomSheet(
          context: context,
          builder: (context) => PhotoInfo(
            tripId: tripId,
            photo: photo,
            onDeleteSuccess: onDeleteSuccess,
          )
        );
      },
      child: Image.network(
        '${dotenv.env['API_ADDRESS']}${photo.uri}',
        fit: BoxFit.cover,
        headers: {
          'Authorization': context.read<AuthProvider>().getAuthorizationHeader(),
        },
      ),
    );
  }
}