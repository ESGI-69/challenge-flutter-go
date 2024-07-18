import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/Widgets/logo_area.dart';
import 'package:move_together_app/core/services/auth_service.dart';
import 'package:move_together_app/Widgets/button.dart';
import 'package:move_together_app/Widgets/Input/cool_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? errorMessage;

  Future<void> _register() async {
    final authServices = AuthService(context.read<AuthProvider>());
    try {
      await authServices.register(
        _usernameController.text,
        _passwordController.text,
      );
      if (mounted) {
        setState(() {
          errorMessage = null;
        });
        context.goNamed('login');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = 'Enregistrement échoué';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LogoArea(),
              const Text(
                "Bienvenue sur MoveTogether",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Inscris toi pour continuer",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              CoolTextField(
                controller: _usernameController,
                hintText: 'Nom d\'utilisateur',
              ),
              const SizedBox(height: 16),
              CoolTextField(
                controller: _passwordController,
                hintText: 'Mot de passe',
                obscureText: true,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: Button(
                  onPressed: _register,
                  text: 'Register',
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
                    "Already have an account?",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.goNamed('login');
                    },
                    child: const Text('Login'),
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
