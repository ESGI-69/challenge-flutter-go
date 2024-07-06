import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/core/models/photo.dart';

class PhotoInfo extends StatelessWidget {
  final Photo photo;

  const PhotoInfo({
    super.key,
    required this.photo
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Image.network(
          '${dotenv.env['API_ADDRESS']}${photo.uri}',
          fit: BoxFit.contain,
          headers: {
            'Authorization': context.read<AuthProvider>().getAuthorizationHeader(),
          },
        ),
      ),
    );
  }
}