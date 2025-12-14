// ignore_for_file: avoid_print

import 'package:finaltodoapp/firebase_options.dart';
import 'package:finaltodoapp/view/claender_screen.dart';
import 'package:finaltodoapp/view/login_screen.dart';
import 'package:finaltodoapp/view/note_pad_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print("Starting Firebase init...");

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase initialized SUCCESSFULLY!");
  } catch (e) {
    print("Firebase Init Error: $e");
  }

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: LoginScreen(),
      // home: HomeScreen(),
      // home: CalendarScreen(),
      // home: NotePadScreen(),
      // home: AddNotes(),

      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    );
  }
}


