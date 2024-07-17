import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:move_together_app/Provider/auth_provider.dart';

import 'package:move_together_app/Widgets/Button/button_back.dart';
import 'package:move_together_app/core/services/trip_service.dart';

import '../Widgets/button.dart';

class JoinTripScreen extends StatefulWidget {
  const JoinTripScreen({ super.key });

  @override
  JoinTripScreenState createState() => JoinTripScreenState();
}

class JoinTripScreenState extends State<JoinTripScreen> {
  final TextEditingController _tripCodeController = TextEditingController();
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _tripCodeController.addListener(_handleTextChanged);
  }

  @override
  void dispose() {
    _tripCodeController.removeListener(_handleTextChanged);
    _tripCodeController.dispose();
    super.dispose();
  }

  void _handleTextChanged() {
    setState(() {
    });
  }

  Future<void> _joinTrip() async {
    try {
      final tripServices = TripService(context.read<AuthProvider>());
      await tripServices.join(
        _tripCodeController.text,
      );
      context.pushNamed('home');
    } catch (e) {
      setState(() {
        errorMessage = 'Joining trip failed';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
        padding: EdgeInsets.only(left: 16.0),
         child: Row(
          children: [
            ButtonBack(),
          ],
        ),
      ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text('Tu as été invité?'),
              const Text('S\'il te plait, entre le code PIN ci-dessous'),
              const Icon(Icons.groups_rounded, size: 100, color: Color(0xFF79D0BF)),
              TextField(
                controller: _tripCodeController,
                decoration: const InputDecoration(
                  counterText: '',
                   enabledBorder: OutlineInputBorder(
                            borderSide:  BorderSide(color: Colors.pinkAccent),
                          ),
                    focusedBorder: OutlineInputBorder(
                            borderSide:  BorderSide(color: Colors.pinkAccent),
                          ),
                ),
                textAlign: TextAlign.center,
                maxLength: 10,
                style: const TextStyle(color: Colors.black,
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: Button(
                  onPressed: _joinTrip,
                  type: _tripCodeController.text.length >= 8
                      ? ButtonType.primary
                      : ButtonType.disabled,
                  text: 'Rejoindre Maintenant',
                ),
              ),
              const SizedBox(height: 16),
              if (errorMessage != null)
                Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }



}
      

