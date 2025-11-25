import 'package:earnly/app/controllers/auth_controller.dart';
import 'package:earnly/app/resources/colors.dart';
import 'package:earnly/app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'login_screen.dart';

class OtpScreen extends StatelessWidget {
  final String email;
  final VoidCallback? whatNext;
  OtpScreen({super.key, required this.email, this.whatNext});

  final pinController = TextEditingController();
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // make sure background covers status bar
      body: Stack(
        children: [
          /// Background Image (fills full screen)
          Positioned.fill(
            child: Image.asset(
              'assets/images/background_2.png',
              fit: BoxFit.cover,
            ),
          ),

          /// Transparent overlay (optional)
          Container(color: Colors.white.withOpacity(0.0)),

          /// Main Content
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "OTP Verification",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 33,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),

                const Text(
                  "An OTP will be sent to your email address. Enter the 6 digit code below",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 40),

                /// 6 Digit Code Input Boxes
                Center(
                  child: Pinput(
                    controller: pinController,
                    keyboardType: TextInputType.number,
                    length: 6,
                    closeKeyboardWhenCompleted: true,
                    onCompleted: (value) {
                      
                    },
                    defaultPinTheme: PinTheme(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6F6F6),
                        borderRadius: BorderRadius.circular(10),
                        // border: Border.all(color: Colors.grey),
                      ),
                    ),
                    focusedPinTheme: PinTheme(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6F6F6),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.primaryColor),
                      ),
                    ),
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: List.generate(6, (index) {
                //     return SizedBox(
                //       width: 48,
                //       height: 55,
                //       child: TextField(
                //         controller: _controllers[index],
                //         focusNode: _focusNodes[index],
                //         keyboardType: TextInputType.number,
                //         textAlign: TextAlign.center,
                //         maxLength: 1,
                //         style: const TextStyle(
                //           fontSize: 22,
                //           fontWeight: FontWeight.bold,
                //         ),
                //         decoration: InputDecoration(
                //           counterText: '',
                //           filled: true,
                //           fillColor: const Color(0xFFF6F6F6),
                //           border: OutlineInputBorder(
                //             borderRadius: BorderRadius.circular(10),
                //             borderSide: BorderSide.none,
                //           ),
                //         ),
                //         onChanged: (value) => _onDigitChanged(value, index),
                //       ),
                //     );
                //   }),
                // ),
                const SizedBox(height: 50),

                /// Continue Button
                CustomButton(
                  ontap: () async {},
                  isLoading: authController.isloading,
                  child: Text(
                    "Continue",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                /// Back to Login
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
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
