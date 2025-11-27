import 'dart:math' as math;

import 'package:earnly/app/controllers/earn_controller.dart';
import 'package:earnly/app/controllers/user_controller.dart';
import 'package:earnly/app/modules/games/models/game_history_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DiceGameController extends GetxController
    with GetTickerProviderStateMixin {
  RxDouble balance = 0.0.obs;
  RxDouble stake = 10.0.obs;
  RxInt predictedNumber = 4.obs;
  RxBool isOver = true.obs;
  RxBool isRolling = false.obs;
  RxnInt rolledNumber = RxnInt(1);
  RxnBool lastWin = RxnBool();

  late AnimationController diceController;
  late AnimationController resultController;
  late Animation<double> diceRotation;
  late Animation<double> diceScale;
  late Animation<double> resultScale;

  RxList<GameHistory> history = <GameHistory>[].obs;
  final userController = Get.find<UserController>();
  final earnController = Get.find<EarnController>();

  @override
  void onInit() {
    initializeControllers();
    super.onInit();
  }

  initializeControllers() {
    balance.value = userController.userModel.value?.credits?.toDouble() ?? 0.0;
    diceController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    resultController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    diceRotation = Tween<double>(begin: 0, end: 8 * math.pi).animate(
      CurvedAnimation(parent: diceController, curve: Curves.easeOutCubic),
    );

    diceScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 0.9), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.0), weight: 30),
    ]).animate(
      CurvedAnimation(parent: diceController, curve: Curves.easeInOut),
    );

    resultScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: resultController, curve: Curves.elasticOut),
    );
  }

  RxDouble get winChance {
    if (isOver.value) {
      return RxDouble(((6 - predictedNumber.value) / 6) * 100);
    } else {
      return RxDouble((predictedNumber.value / 6) * 100);
    }
  }

  RxDouble get multiplier {
    return RxDouble(100 / winChance.value);
  }

  RxDouble get potentialWin {
    if (stake.value > balance.value) {
      return RxDouble(0);
    }
    return RxDouble(stake.value * multiplier.value);
  }

  void rollDice() async {
    if (isRolling.value || balance.value <= 0 || stake.value > balance.value) {
      return;
    }

    isRolling.value = true;
    lastWin.value = null;
    rolledNumber.value = null;

    diceController.forward(from: 0);

    await Future.delayed(const Duration(milliseconds: 1200));

    final random = math.Random();
    final result = random.nextInt(6) + 1;

    bool won =
        isOver.value
            ? result > predictedNumber.value
            : result < predictedNumber.value;

    rolledNumber.value = result;
    lastWin.value = won;
    final amount =
        won
            ? balance.value + (potentialWin.value - stake.value)
            : balance.value - stake.value;
    balance.value = amount;

    history.insert(
      0,
      GameHistory(
        stake: stake.value,
        result: result,
        won: won,
        payout: won ? potentialWin.value : 0,
      ),
    );

    if (history.length > 10) history.removeLast();

    await Future.delayed(const Duration(milliseconds: 600));
    resultController.forward(from: 0);

    isRolling.value = false;
    await Future.delayed(const Duration(milliseconds: 500));
    resultController.reset();

    await earnController.dice(
      stake: stake.value,
      balance: balance.value,
      win: won,
      amount: amount,
    );
  }

  @override
  void onClose() {
    diceController.dispose();
    resultController.dispose();
    userController.getUserDetails();
    super.onClose();
  }
}
