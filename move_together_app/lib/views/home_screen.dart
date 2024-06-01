import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes voyages'),
      ),
      body: Center(
        child:
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/images/voyage.jpeg'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(const Color(0xFF55C0A8)),
                  foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                  side: WidgetStateProperty.all<BorderSide>(const BorderSide(color: Color(0xFF55C0A8))),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Créer un voyage'),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Rejoindre un voyage'),
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
