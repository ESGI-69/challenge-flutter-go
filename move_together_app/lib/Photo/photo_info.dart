import 'package:flutter/material.dart';

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
        ),
      ),
    );
  }
}