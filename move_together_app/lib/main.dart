import 'dart:io';

import 'package:flutter/material.dart';
import 'package:move_together_app/app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(const App());
}
