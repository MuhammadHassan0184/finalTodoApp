import 'package:finaltodoapp/view/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';

class AuthCheck extends StatelessWidget {
  // ignore: use_super_parameters
  const AuthCheck({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // User logged in
        if (snapshot.hasData) {
          return HomeScreen();
        }

        // User NOT logged in
        return Splash();
      },
    );
  }
}
