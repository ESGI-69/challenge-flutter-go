import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/Widgets/button.dart';
import 'package:move_together_app/core/services/auth_service.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  LandingScreenState createState() => LandingScreenState();
}

class LandingScreenState extends State<LandingScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  String? errorMessage;

  Future<void> _login() async {
    final authServices = AuthService(context.read<AuthProvider>());
    try {
      final token = await authServices.login(
        _usernameController.text,
        _passwordController.text,
      );
      await _secureStorage.write(key: 'jwt', value: token);
      setState(() {
        errorMessage = null;
      });
      if (!mounted) return;
      if (!kIsWeb) {
        context.goNamed('home');
      } else {
        context.goNamed('dashboard');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = 'Login failed';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Landing'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                fit: StackFit.loose,
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 250,
                    child: Image.asset(
                      'assets/images/fond_couleurs_transparent.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.luggage,
                      size: 100,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              const Text(
                "Welcome to MoveTogether",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Planifie ton voyage avec tes amis",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
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
              SizedBox(
                width: double.infinity,
                child: Button(
                  text: 'Login',
                  onPressed: _login,
                  type: ButtonType.primary,
                ),
              ),
              if (errorMessage != null)
                Text(errorMessage!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.goNamed('register');
                    },
                    child: const Text('Register'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
