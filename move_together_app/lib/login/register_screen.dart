import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:move_together_app/core/services/api_services.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}


class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? errorMessage;

  Future<void> _register() async {
    try {
      final user = await ApiServices.registerUser(
        _usernameController.text,
        _passwordController.text,
      );
      setState(() {
        errorMessage = null;
      });
      Navigator.pushReplacementNamed(context, '/');
    } catch (e) {
      print(e);
      setState(() {
        errorMessage = 'Registration failed';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _register,
                child: const Text('Register'),
              ),
              if (errorMessage != null)
                Text(errorMessage!, style: const TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ),
    );
  }
}
