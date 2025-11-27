import 'package:earnly/app/controllers/user_controller.dart';
import 'package:earnly/app/modules/games/controllers/wheel_spin_controller.dart';
import 'package:earnly/app/modules/games/widgets/triangle_pointer.dart';
import 'package:earnly/app/modules/games/widgets/wheel_painter.dart';
import 'package:earnly/app/resources/colors.dart';
import 'package:earnly/app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class WheelSpinScreen extends StatelessWidget {
  WheelSpinScreen({super.key});

  final wheelSpinController = Get.put(WheelSpinController());
  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            children: [
              // Minimalist Header
              buildHeader(),

              const SizedBox(height: 40),

              // Title
              const Text(
                "Daily Fortune",
                style: TextStyle(
                  color: Color(0xFFE8E8E8),
                  fontSize: 28,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: 8),

              // Subtitle
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: const Color(0xFFBFA26C).withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                ),
                child: Obx(() {
                  final hasSpunToday = wheelSpinController.hasSpunToday.value;
                  return Text(
                    hasSpunToday ? "COMPLETED TODAY" : "ONE SPIN AVAILABLE",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                    ),
                  );
                }),
              ),

              const SizedBox(height: 60),

              // Wheel container
              Expanded(
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Subtle glow
                      Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryColor.withValues(
                                alpha: 0.15,
                              ),
                              blurRadius: 60,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                      ),

                      // Wheel
                      AnimatedBuilder(
                        animation: wheelSpinController.animation,
                        builder: (context, child) {
                          final animationValue =
                              wheelSpinController.animation.value;
                          return Transform.rotate(
                            angle: animationValue * math.pi / 180,
                            child: CustomPaint(
                              size: const Size(260, 260),
                              painter: WheelPainter(
                                rewards: wheelSpinController.rewards,
                                colors: wheelSpinController.segmentColors,
                              ),
                            ),
                          );
                        },
                      ),

                      // Center circle
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF0A0E27),
                          border: Border.all(
                            color: const Color(0xFFBFA26C),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.5),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.star_border,
                          color: Color(0xFFBFA26C),
                          size: 32,
                        ),
                      ),

                      // Pointer at top
                      Positioned(
                        top: -5,
                        child: CustomPaint(
                          painter: TrianglePainter(),
                          size: const Size(24, 32),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Info text
              Obx(() {
                final hasSpunToday = wheelSpinController.hasSpunToday.value;
                final lastReward = wheelSpinController.lastReward.value;
                return Text(
                  hasSpunToday && lastReward != 0
                      ? "You earned $lastReward coins today"
                      : "Win between ${wheelSpinController.rewards.first} and ${wheelSpinController.rewards.last} coins",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.3,
                  ),
                );
              }),

              const SizedBox(height: 32),

              // Spin button
              Obx(() {
                if (wheelSpinController.hasSpunToday.value) {
                  return SizedBox.shrink();
                }
                return CustomButton(
                  ontap: () async {
                  await  wheelSpinController.spinWheel();
                  },
                  isLoading: false.obs,
                  child: Text(
                    "SPIN WHEEL",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
                  ),
                );
              }),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF2D3142), width: 1),
            image: const DecorationImage(
              image: AssetImage("assets/images/profile.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 3, 37, 10),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF2D3142), width: 1),
          ),
          child: Row(
            children: [
              Icon(Icons.circle, color: Colors.white, size: 8),
              SizedBox(width: 8),
              Obx(() {
                final userModel = userController.userModel.value;
                return Text(
                  userModel?.credits.toString() ?? "0",
                  style: TextStyle(
                    color: Color(0xFFE8E8E8),
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    letterSpacing: 0.5,
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
