import 'package:earnly/app/controllers/auth_controller.dart';
import 'package:earnly/app/routes/app_routes.dart';
import 'package:earnly/app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({super.key});

  final authController = Get.find<AuthController>();
  final emailController = TextEditingController();

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
                  "Password Recovery",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 33,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),

                const Text(
                  "Enter your email to reset password",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 40),

                /// Email Input
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "Enter your email",
                    filled: true,
                    fillColor: const Color(0xFFF6F6F6),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                /// Continue Button
                CustomButton(
                  ontap: () async {
                    if (emailController.text.isEmpty) return;
                    Get.toNamed(
                      AppRoutes.otpScreen,
                      arguments: {
                        'email': emailController.text,
                        'whatNext':
                            () => Get.toNamed(
                              AppRoutes.resetPasswordScreen,
                              arguments: {"email": emailController.text},
                            ),
                      },
                    );
                    await authController.sendOtp(email: emailController.text);
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
                const SizedBox(height: 25),

                /// Back to Login
                GestureDetector(
                  onTap: () => Get.back(),
                  child: const Text(
                    "Back to Login",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
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
