import 'package:earnly/app/controllers/auth_controller.dart';
import 'package:earnly/app/controllers/storage_controller.dart';
import 'package:earnly/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () async {
      final storageController = Get.find<StorageController>();
      final token = await storageController.getToken();
      if (token == null) {
        Get.toNamed(AppRoutes.welcomeScreen);
        return;
      }
      final authController = Get.find<AuthController>();
      authController.validateToken(token: token);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF36D986),
      body: Stack(
        children: [
          // Center Logo
          Center(
            child: Image.asset(
              'assets/images/logo_1.png',
              width: 120,
              height: 120,
              fit: BoxFit.contain,
            ),
          ),

          // Bottom White Circular Shapes
          Positioned(
            bottom: -120,
            right: -120,
            child: Container(
              width: 260,
              height: 260,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -90,
            right: -90,
            child: Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 163, 162, 162),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
