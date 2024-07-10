import 'package:flutter/material.dart';
import 'package:move_together_app/Backoffice/Widgets/navigation_bar_backoffice.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: NavigationBarBackoffice(),
      body: Center(
        child: Text('Users Screen for Backoffice'),
      ),
    );
  }
}