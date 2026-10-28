import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(const HauntedMansionApp());
}

// 🧛 The oldest resident — never changes
class HauntedMansionApp extends StatelessWidget {
  const HauntedMansionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Haunted Signup Mansion',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}