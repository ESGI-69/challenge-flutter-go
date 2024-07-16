import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../Widgets/button.dart';

class EmptyHome extends StatelessWidget {
  const EmptyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 40.0),
            child: Text(
              'Bienvenue sur Moove Together !',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Column(
            children: [
              Image.asset('assets/images/empty_bg.png'),
              SizedBox(
                width: double.infinity,
                child: Button(
                  onPressed: () {
                    context.pushNamed('create');
                  },
                  text: 'Créer un voyage',
                  type: ButtonType.primary,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: Button(
                  onPressed: () {
                    context.pushNamed('join');
                  },
                  text: 'Rejoindre un voyage',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}