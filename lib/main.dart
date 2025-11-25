import 'package:earnly/app/bindings/app_bindings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/onboarding_screen_1.dart';

void main() {
  runApp(const EarnlyApp());
}

class EarnlyApp extends StatelessWidget {
  const EarnlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Earnly",
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      debugShowCheckedModeBanner: false,
      initialBinding: AppBindings(),
      home: const OnboardingScreen1(),
    );
  }
}
