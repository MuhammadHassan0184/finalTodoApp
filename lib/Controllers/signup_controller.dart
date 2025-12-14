import 'package:finaltodoapp/view/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class SignupController {
  final AuthService _authService = AuthService();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();

  bool isLoading = false;

  Future<void> signup(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final fullName = fullNameController.text.trim();

    if (email.isEmpty || password.isEmpty || fullName.isEmpty) {
      _showSnack(context, "Please fill all fields.");
      return;
    }

    try {
      isLoading = true;

      // Create user
      User? user = await _authService.signUp(
        email,
        password,
        fullName,
      );

      isLoading = false;

      if (user != null) {
        _showSnack(context, "Signup successful!");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        _showSnack(context, "Signup failed. Try again.");
      }
    } catch (e) {
      isLoading = false;
      _showSnack(context, e.toString());
    }
  }

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }
}
