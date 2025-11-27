import 'dart:math' as math;

import 'package:earnly/app/controllers/earn_controller.dart';
import 'package:earnly/app/controllers/user_controller.dart';
import 'package:earnly/app/modules/games/widgets/reward_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WheelSpinController extends GetxController
    with GetTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  final isSpinning = false.obs;
  final hasSpunToday = false.obs;
  final lastReward = 0.obs;
  final earnController = Get.find<EarnController>();
  final userController = Get.find<UserController>();

  final RxList<int> rewards = <int>[].obs;
  final List<Color> segmentColors = [
    const Color.fromARGB(255, 32, 70, 39), // Primary green
    const Color.fromARGB(255, 52, 90, 59), // Lighter shade of primary green
    const Color.fromARGB(255, 32, 70, 39),
    const Color.fromARGB(255, 52, 90, 59),
    const Color.fromARGB(255, 32, 70, 39),
    const Color.fromARGB(255, 52, 90, 59),
    const Color.fromARGB(255, 32, 70, 39),
    const Color.fromARGB(255, 52, 90, 59),
  ];

  @override
  void onInit() {
    super.onInit();
    init();
  }

  init() async {
    if (earnController.wheelSpinRewards.isEmpty) {
      earnController.getWheelSpinRewards();
    }
    rewards.value = earnController.wheelSpinRewards;
    controller = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );

    animation = Tween<double>(
      begin: 0,
      end: 0,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.linear));
    checkIfSpunToday();
  }

  void checkIfSpunToday() {
    final userModel = userController.userModel.value;
    hasSpunToday.value = userModel?.hasSpunToday ?? false;
  }

  Future<void> spinWheel() async {
    if (isSpinning.value || hasSpunToday.value) return;
    isSpinning.value = true;

    final random = math.Random();
    final rewardIndex = random.nextInt(rewards.length);
    final reward = rewards[rewardIndex];

    final segmentAngle = 360.0 / rewards.length;
    final targetAngle = (rewardIndex + 1) * segmentAngle;
    final endAngle = targetAngle - segmentAngle;
    final middleAngle = (targetAngle + endAngle) / 2;

    final adjustedAngle = 360 - middleAngle;

    final fullRotations = 360 * (random.nextInt(6) + 1);
    final totalRotation = (fullRotations) + adjustedAngle;

    animation = Tween<double>(
      begin: 0,
      end: totalRotation,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutCubic));

    controller.forward(from: 0).then((_) async {
      isSpinning.value = false;
      hasSpunToday.value = true;
      lastReward.value = reward;
      _showRewardPopup(reward);
      await earnController.claimWheelSpin(reward: reward);
      controller.reset();
    });
  }

  void _showRewardPopup(int reward) {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => RewardPopup(reward: reward),
    );
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }
}
