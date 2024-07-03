import 'package:flutter/material.dart';
import 'package:move_together_app/app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:move_together_app/backoffice.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: kIsWeb ? const Backoffice() : const App(),
    ),
  );
}
