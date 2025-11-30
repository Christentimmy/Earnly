import 'package:earnly/app/routes/app_routes.dart';
import 'package:earnly/app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background_1.png',
              fit: BoxFit.cover,
            ),
          ),

          // Floating crypto coins
          Positioned(
            top: 50,
            left: 30,
            child: Opacity(
              opacity: 0.9,
              child: Image.asset('assets/images/crypto_coin.png', width: 60),
            ),
          ),
          Positioned(
            top: 60,
            right: 40,
            child: Opacity(
              opacity: 0.7,
              child: Image.asset('assets/images/crypto_coin.png', width: 70),
            ),
          ),
          Positioned(
            bottom: 200,
            left: 20,
            child: Opacity(
              opacity: 0.5,
              child: Image.asset('assets/images/crypto_coin.png', width: 85),
            ),
          ),
          Positioned(
            bottom: 130,
            right: 60,
            child: Opacity(
              opacity: 0.8,
              child: Image.asset('assets/images/crypto_coin.png', width: 45),
            ),
          ),

          // Main content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 130), // Push text towards top
                const Text(
                  "Welcome to Earnly",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Lorem ipsum dolor sit amet consectetur. "
                  "Pretium sit rutrum nunc pulvinar facilisis. "
                  "Sit eget hac velit id quis vitae sit in mauris.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
                const Spacer(),
                CustomButton(
                  isLoading: false.obs,
                  ontap: () {
                    Get.toNamed(AppRoutes.registerScreen);
                  },
                  child: Text(
                    "Continue",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
