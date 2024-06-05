import 'package:flutter/material.dart';
import 'package:move_together_app/core/services/api_services.dart';
import 'package:go_router/go_router.dart';


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
      final apiServices = ApiServices();
      await apiServices.joinTrip(
        _tripCodeController.text,
      );
      if (mounted) {
        setState(() {
          errorMessage = null;
        });
        context.go('/trip');
      }
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
        title: const Text('Join Trip'),
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
              ElevatedButton(
                onPressed: _joinTrip,
                style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                      if (_tripCodeController.text.length >= 8) {
                        return const Color(0xFF79D0BF);
                      }
                      return const Color(0xFFb2e4da);
                    },
                  ),                  
                  foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                  padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.symmetric(horizontal: 70.0),
                  ),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
                child: const Text('Rejoindre Maintenant'),
              ),
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
      

