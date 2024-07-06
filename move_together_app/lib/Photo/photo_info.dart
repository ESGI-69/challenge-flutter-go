import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/Provider/auth_provider.dart';

class PhotoInfo extends StatelessWidget {
  final String photoUrl;

  const PhotoInfo({
    super.key,
    required this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Image.network(
          photoUrl,
          fit: BoxFit.contain,
          headers: {
            'Authorization': context.read<AuthProvider>().getAuthorizationHeader(),
          },
        ),
      ),
    );
  }
}