import 'dart:async';
import 'package:earnly/app/controllers/auth_controller.dart';
import 'package:earnly/app/resources/colors.dart';
import 'package:earnly/app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatelessWidget {
  final String email;
  final VoidCallback? whatNext;
  OtpScreen({super.key, required this.email, this.whatNext});

  final pinController = TextEditingController();
  final authController = Get.find<AuthController>();
  final RxInt resendOtpTimer = 60.obs;

  void startResendOtpTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendOtpTimer.value > 0) {
        resendOtpTimer.value--;
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    startResendOtpTimer();
    return Scaffold(
      extendBodyBehindAppBar: true,
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
                    fontSize: 25,
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
                    onCompleted: (value) async {
                      await authController.verifyOtp(
                        email: email,
                        otp: value,
                        whatNext: whatNext,
                      );
                    },
                    defaultPinTheme: PinTheme(
                      height: 55,
                      width: 55,
                      textStyle: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6F6F6),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                      ),
                    ),
                    focusedPinTheme: PinTheme(
                      height: 55,
                      width: 55,
                      textStyle: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6F6F6),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.primaryColor),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),

                /// Continue Button
                CustomButton(
                  ontap: () async {
                    if (authController.isloading.value) return;
                    if (pinController.text.isEmpty) return;
                    await authController.verifyOtp(
                      email: email,
                      otp: pinController.text,
                      whatNext: whatNext,
                    );
                  },
                  isLoading: authController.isOtpVerifyLoading,
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

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Didn’t receive OTP? "),
                    Obx(
                      () => InkWell(
                        onTap: () async {
                          if (resendOtpTimer.value > 0) return;
                          await authController.sendOtp(email: email);
                        },
                        child: Text(
                          resendOtpTimer.value > 0
                              ? "${resendOtpTimer.value}s"
                              : "Resend",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
