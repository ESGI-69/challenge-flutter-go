import 'package:flutter/material.dart';
import 'package:move_together_app/app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:move_together_app/Provider/auth_provider.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: const App(),
    ),
  );
}
