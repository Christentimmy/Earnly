import 'package:flutter/material.dart';
import 'screens/onboarding_screen_1.dart';

void main() {
  runApp(const EarnlyApp());
}

class EarnlyApp extends StatelessWidget {
  const EarnlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const OnboardingScreen1(),
    );
  }
}
