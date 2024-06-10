import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
        primaryColor: const Color(0xFF55C0A8),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF55C0A8),
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
                        router.go('/home');
                      } else if (index == 1) {
                        router.go('/profile');
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
