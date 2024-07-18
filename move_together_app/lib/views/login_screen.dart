import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/Widgets/button.dart';
import 'package:move_together_app/Widgets/logo_area.dart';
import 'package:move_together_app/core/services/auth_service.dart';
import 'package:move_together_app/Widgets/Input/cool_text_field.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
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
        context.goNamed('feature');
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
                "Connecte toi à ton compte pour continuer",
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
                  text: 'Login',
                  onPressed: _login,
                  type: ButtonType.primary,
                ),
              ),
              if (errorMessage != null)
                Text(errorMessage!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              ...kIsWeb
                  ? []
                  : [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account?",
                            style: TextStyle(
                              color: Colors.grey,
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
            ],
          ),
        ),
      ),
    );
  }
}
