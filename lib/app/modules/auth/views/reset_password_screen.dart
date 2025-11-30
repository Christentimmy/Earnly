import 'package:earnly/app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:earnly/app/controllers/auth_controller.dart';
import 'package:earnly/app/widgets/custom_button.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String email;
  ResetPasswordScreen({super.key, required this.email});

  final authController = Get.find<AuthController>();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background_2.png',
              fit: BoxFit.cover,
            ),
          ),

          /// Transparent overlay (optional for readability)
          Container(color: Colors.white.withOpacity(0.0)),

          /// Main Content
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Reset Password",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 33,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 50),

                /// Email Input
                CustomTextField(
                  hintText: "Password",
                  controller: passwordController,
                  isObscure: true,
                ),
                const SizedBox(height: 40),

                /// Continue Button
                CustomButton(
                  ontap: () async {
                    if (passwordController.text.isEmpty) return;
                    await authController.resetPassword(
                      email: email,
                      password: passwordController.text,
                    );
                  },
                  isLoading: authController.isloading,
                  child: Text(
                    "Continue",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
