import 'package:flutter/material.dart';
import 'package:move_together_app/router.dart';

class Backoffice extends StatefulWidget {
  const Backoffice({super.key});

  @override
  State<Backoffice> createState() => _BackofficeState();
}

class _BackofficeState extends State<Backoffice> {

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
          surface: Colors.white,
          inverseSurface: Colors.black,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Color(0xFF55C0A8),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      routerDelegate: backOfficeRouter.routerDelegate,
      routeInformationParser: backOfficeRouter.routeInformationParser,
      routeInformationProvider: backOfficeRouter.routeInformationProvider,
      builder: (context, child) {
        return Scaffold(
          body: child,
        );
      },
    );
  }
}
