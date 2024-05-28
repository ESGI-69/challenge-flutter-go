import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/images/voyage.jpeg'),
              const SizedBox(height: 20), //spacing
              const Text('Planifie ton voyage !'),
              const SizedBox(height: 20), //spacing
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
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
                    SizedBox(width: 10), // spacing
                    Text('Continuer avec Apple'),
                  ],
                ),
              ),
              const SizedBox(height: 10), // spacing
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
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
                    SizedBox(width: 10), // spacing
                    Text('Continuer avec Google'),
                  ],
                ),
              ),
              const SizedBox(height: 10), // spacing
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
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
                    SizedBox(width: 10), // spacing
                    Text('Continuer avec Facebook'),
                  ],
                ),
              ),
              const SizedBox(height: 10), // Add some spacing
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
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
                    SizedBox(width: 10), // spacing
                    Text('Continuer avec e-mail'),
                  ],
                ),
              ),
              const SizedBox(height: 15), // Add some spacing
              const Text('OR'),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
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
                    SizedBox(width: 10), // spacing
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
