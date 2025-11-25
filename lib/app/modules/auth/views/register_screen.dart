import 'package:earnly/app/controllers/auth_controller.dart';
import 'package:earnly/app/routes/app_routes.dart';
import 'package:earnly/app/widgets/custom_button.dart';
import 'package:earnly/app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final formKey = GlobalKey<FormState>();
  final authController = Get.find<AuthController>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background_2.png',
              fit: BoxFit.cover,
            ),
          ),

          // Main content
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Register Account",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 30),
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Username or Email
                      CustomTextField(
                        hintText: "Username",
                        bgColor: const Color(0xFFF6F6F6),
                        controller: nameController,
                      ),
                      const SizedBox(height: 10),

                      // Password
                      CustomTextField(
                        hintText: "Email",
                        bgColor: const Color(0xFFF6F6F6),
                        controller: emailController,
                      ),
                      const SizedBox(height: 10),

                      // Confirm Password
                      CustomTextField(
                        hintText: "Password",
                        isObscure: true,
                        bgColor: const Color(0xFFF6F6F6),
                        controller: passwordController,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),

                // Register Button → Navigates to LoginScreen
                CustomButton(
                  ontap: () async {
                    if (authController.isloading.value) return;
                    if (!formKey.currentState!.validate()) return;
                    await authController.register(
                      name: nameController.text,
                      email: emailController.text,
                      password: passwordController.text,
                    );
                  },
                  isLoading: authController.isloading,
                  child: Text(
                    "Register",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Divider with OR
                Row(
                  children: const [
                    Expanded(child: Divider(thickness: 1, color: Colors.grey)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("OR", style: TextStyle(color: Colors.grey)),
                    ),
                    Expanded(child: Divider(thickness: 1, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 20),

                // Continue with Apple
                _socialButton(
                  color: Colors.black,
                  icon: Icons.apple,
                  text: "Continue with Apple",
                  textColor: Colors.white,
                  context: context,
                ),
                const SizedBox(height: 16),

                // Continue with Google
                _socialButton(
                  color: const Color(0xFFDB4437),
                  icon: Icons.g_mobiledata,
                  text: "Continue with Google",
                  textColor: Colors.white,
                  context: context,
                ),
                const SizedBox(height: 16),

                // Continue with Discord
                _socialButton(
                  color: const Color(0xFF5865F2),
                  icon: Icons.discord,
                  text: "Continue with Discord",
                  textColor: Colors.white,
                  context: context,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Custom Text Field Widget
  // Widget _buildTextField({
  //   required String hintText,
  //   required bool obscureText,
  // }) {
  //   return TextField(
  //     obscureText: obscureText,
  //     decoration: InputDecoration(
  //       hintText: hintText,
  //       filled: true,
  //       fillColor: const Color(0xFFF6F6F6),
  //       contentPadding: const EdgeInsets.symmetric(
  //         vertical: 16,
  //         horizontal: 16,
  //       ),
  //       border: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(10),
  //         borderSide: BorderSide.none,
  //       ),
  //     ),
  //   );
  // }

  // Social Button Widget
  Widget _socialButton({
    required Color color,
    required IconData icon,
    required String text,
    required Color textColor,
    required BuildContext context,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
        icon: Icon(icon, color: textColor, size: 26),
        onPressed: () {
          Get.toNamed(AppRoutes.loginScreen);
        },
        label: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
