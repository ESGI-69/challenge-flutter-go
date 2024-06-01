import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/images/voyage.jpeg'),
              const SizedBox(height: 20),
              const Text('Planifie ton voyage !'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.go('/login');
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
                  foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.apple),
                    SizedBox(width: 10),
                    Text('Continuer avec Apple'),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  context.go('/login');
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
                  foregroundColor: WidgetStateProperty.all<Color>(const Color(0xFF55C0A8)),
                  side: WidgetStateProperty.all<BorderSide>(const BorderSide(color: Color(0xFF55C0A8))),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.apple),
                    SizedBox(width: 10),
                    Text('Continuer avec Google'),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  context.go('/login');
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
                  foregroundColor: WidgetStateProperty.all<Color>(const Color(0xFF55C0A8)),
                  side: WidgetStateProperty.all<BorderSide>(const BorderSide(color: Color(0xFF55C0A8))),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.facebook),
                    SizedBox(width: 10),
                    Text('Continuer avec Facebook'),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  context.go('/login');
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
                  foregroundColor: WidgetStateProperty.all<Color>(const Color(0xFF55C0A8)),
                  side: WidgetStateProperty.all<BorderSide>(const BorderSide(color: Color(0xFF55C0A8))),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.email),
                    SizedBox(width: 10),
                    Text('Continuer avec e-mail'),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              const Text('OR'),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  context.go('/register');
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
                  foregroundColor: WidgetStateProperty.all<Color>(const Color(0xFF55C0A8)),
                  side: WidgetStateProperty.all<BorderSide>(const BorderSide(color: Color(0xFF55C0A8))),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.email),
                    SizedBox(width: 10),
                    Text('Nouvel utilisateur'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
