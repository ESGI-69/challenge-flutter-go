import 'package:flutter/material.dart';
import 'package:move_together_app/router.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {

  int _currentIndex = 0;

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
      builder: (context, child) {
        return Overlay(
          initialEntries: [
            OverlayEntry(
              builder: (context) {
                return Scaffold(
                  body: child,
                  bottomNavigationBar: BottomNavigationBar(
                    currentIndex: _currentIndex,
                    selectedItemColor: Theme.of(context).primaryColor,
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.flight),
                        label: 'Voyages',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.account_circle),
                        label: 'Profile',
                      ),
                    ],
                    onTap: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                      if (index == 0) {
                        router.replaceNamed('home');
                      } else if (index == 1) {
                        router.replace('/profile');
                      }
                    },
                  )
                );
              },
            ),
          ],
        );
      }
    );
  }
}
