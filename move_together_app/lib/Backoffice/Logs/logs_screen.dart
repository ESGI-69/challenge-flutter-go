import 'package:flutter/material.dart';
import 'package:move_together_app/Backoffice/Widgets/navigation_bar_backoffice.dart';

class LogsScreen extends StatelessWidget {
  const LogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: NavigationBarBackoffice(),
      body: Center(
        child: Text('Logs Screen for Backoffice'),
      ),
    );
  }
}
