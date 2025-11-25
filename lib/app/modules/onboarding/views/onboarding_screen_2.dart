import 'package:earnly/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class OnboardingScreen2 extends StatefulWidget {
  const OnboardingScreen2({super.key});

  @override
  State<OnboardingScreen2> createState() => _OnboardingScreen2State();
}

class _OnboardingScreen2State extends State<OnboardingScreen2> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      // Navigator.pushReplacement(
      //   context,
      //   PageRouteBuilder(
      //     pageBuilder: (_, __, ___) => const WelcomeScreen(),
      //     transitionDuration: const Duration(milliseconds: 800),
      //     transitionsBuilder:
      //         (_, animation, __, child) =>
      //             FadeTransition(opacity: animation, child: child),
      //   ),
      // );
      Get.toNamed(AppRoutes.welcomeScreen);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/images/logo_2.png',
          width: 200,
          height: 200,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
