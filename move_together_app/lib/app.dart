import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:move_together_app/router.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        debugShowCheckedModeBanner: true,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.grey[50],
          primaryColor: const Color(0xFF55C0A8),
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF55C0A8),
            inversePrimary: Color(0xFFBF7054),
            secondary: Color(0xFF54BF6B),
            tertiary: Color(0xFF526A65),
            error: Color(0xFFD32F2F),
            surface: Color(0xFFF5F5F5),
            inverseSurface: Colors.black,
          ),
          snackBarTheme: const SnackBarThemeData(
            backgroundColor: Color(0xFF55C0A8),
            contentTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          textTheme: const TextTheme(
            displayLarge: TextStyle(
              color: Color(0xFF55C0A8),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        routerDelegate: router.routerDelegate,
        routeInformationParser: router.routeInformationParser,
        routeInformationProvider: router.routeInformationProvider,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('fr'),
        ],
        builder: (context, child) {
          return Overlay(
            initialEntries: [
              OverlayEntry(
                builder: (context) {
                  return Scaffold(
                    body: child,
                  );
                },
              ),
            ],
          );
        });
  }
}
