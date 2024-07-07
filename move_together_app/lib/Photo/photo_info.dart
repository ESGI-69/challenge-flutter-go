import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/Widgets/modal_bottom_sheet_header.dart';
import 'package:move_together_app/core/models/photo.dart';
import 'package:gal/gal.dart';

class PhotoInfo extends StatelessWidget {
  final Photo photo;

  const PhotoInfo({
    super.key,
    required this.photo
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ModalBottomSheetHeader(
          title: 'Détails',
          actions: [
            BottomShitHeaderAction(
              label: 'Enrigistrer dans la galerie',
              onPressed: () async {
                final imagePath = '${Directory.systemTemp.path}/${photo.id}_moove_together.jpg';
                await Dio().download(
                  '${dotenv.env['API_ADDRESS']}${photo.uri}',
                  imagePath,
                  options: Options(
                    headers: {
                      'Authorization': context.read<AuthProvider>().getAuthorizationHeader(),
                    },
                  ),
                );
                await Gal.putImage(imagePath);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Photo enregistrée dans la galerie'),
                  ),
                );
              },
            ),
            BottomShitHeaderAction(
              label: 'Supprimer',
              onPressed: () {},
              desctructive: true,
            ),
          ],
        ),
        Expanded(
          child: Center(
            child: Image.network(
              '${dotenv.env['API_ADDRESS']}${photo.uri}',
              fit: BoxFit.contain,
              headers: {
                'Authorization': context.read<AuthProvider>().getAuthorizationHeader(),
              },
            ),
          ),
        ),
      ],
    );
  }
}