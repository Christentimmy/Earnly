import 'package:earnly/app/controllers/auth_controller.dart';
import 'package:earnly/app/routes/app_routes.dart';
import 'package:earnly/app/widgets/custom_button.dart';
import 'package:earnly/app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'forget_password_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background_2.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Login Account",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 40),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      hintText: "Email",
                      controller: emailController,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      hintText: "Password",
                      controller: passwordController,
                      isObscure: true,
                    ),
                  ],
                ),
              ), // Forget password link
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ForgetPasswordScreen(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(50, 20),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    "Forget password",
                    style: TextStyle(color: Color(0xFF3D5AFE), fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Login button
              CustomButton(
                isLoading: authController.isloading,
                child: Text(
                  "Login",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                ontap: () async {
                  if (!formKey.currentState!.validate()) return;
                  await authController.login(
                    email: emailController.text,
                    password: passwordController.text,
                  );
                },
              ),

              const SizedBox(height: 20),

              // Bottom Register text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don’t have an account? ",
                    style: TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.registerScreen);
                    },
                    child: const Text(
                      "Register account",
                      style: TextStyle(
                        color: Color(0xFF36D986),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
