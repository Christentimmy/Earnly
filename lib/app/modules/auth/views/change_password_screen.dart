import 'package:earnly/app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:earnly/app/controllers/auth_controller.dart';
import 'package:earnly/app/widgets/custom_button.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  final authController = Get.find<AuthController>();

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

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
                  "Change Password",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 33,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 50),
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Email Input
                      CustomTextField(
                        hintText: "Old Password",
                        controller: oldPasswordController,
                        isObscure: true,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        hintText: "New Password",
                        controller: newPasswordController,
                        isObscure: true,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        hintText: "Confirm New Password",
                        controller: confirmNewPasswordController,
                        isObscure: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter your password";
                          }
                          if (value != newPasswordController.text) {
                            return "Passwords do not match";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                /// Continue Button
                CustomButton(
                  ontap: () async {
                    if (!formKey.currentState!.validate()) return;
                    await authController.changePassword(
                      oldPassword: oldPasswordController.text,
                      newPassword: newPasswordController.text,
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
