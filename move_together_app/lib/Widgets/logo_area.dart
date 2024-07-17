import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class LogoArea extends StatelessWidget {
  const LogoArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 350,
          child: ExtendedImage.asset(
            'assets/images/fond_couleurs_flou.png',
            fit: BoxFit.cover,
          ),
        ),
        const Align(
          alignment: Alignment.center,
          child: Icon(
            Icons.luggage,
            size: 100,
          ),
        ),
      ],
    );
  }
}
