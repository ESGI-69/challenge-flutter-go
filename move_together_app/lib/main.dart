import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:move_together_app/app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/Provider/feature_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:move_together_app/backoffice.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  initializeDateFormatting('fr_FR');
  Intl.defaultLocale = 'fr_FR';
  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => FeatureProvider()),
      ],
      child: kIsWeb ? const Backoffice() : const App(),
    ),
  );
}
