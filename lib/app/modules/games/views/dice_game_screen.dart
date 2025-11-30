import 'package:earnly/app/modules/games/controllers/dice_game_controller.dart';
import 'package:earnly/app/modules/games/models/game_history_model.dart';
import 'package:earnly/app/modules/games/widgets/dice_painter.dart';
import 'package:earnly/app/resources/colors.dart';
import 'package:earnly/app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';

class DiceGameScreen extends StatelessWidget {
  DiceGameScreen({super.key});

  final diceGameController = Get.put(DiceGameController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildDiceArea(),
                    const SizedBox(height: 10),
                    _buildStakeInput(),
                    const SizedBox(height: 20),
                    _buildPredictionSelector(),
                    const SizedBox(height: 20),
                    _buildStatsCard(),
                    const SizedBox(height: 20),
                    _buildRollButton(),
                    const SizedBox(height: 20),
                    _buildHistory(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.3),
        border: Border(
          bottom: BorderSide(color: AppColors.primaryColor.withOpacity(0.5)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '🎲 Dice Game',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Obx(
              () => Text(
                diceGameController.balance.value.toStringAsFixed(2),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiceArea() {
    return SizedBox(
      height: Get.height * 0.17,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: diceGameController.diceController,
            builder: (context, child) {
              return Transform.scale(
                scale: diceGameController.diceScale.value,
                child: Transform.rotate(
                  angle: diceGameController.diceRotation.value,
                  child: Obx(
                    () =>
                        _buildDice(diceGameController.rolledNumber.value ?? 1),
                  ),
                ),
              );
            },
          ),
          Obx(() {
            if (diceGameController.lastWin.value == null) {
              return SizedBox.shrink();
            }
            return AnimatedBuilder(
              animation: diceGameController.resultController,
              builder: (context, child) {
                return Transform.scale(
                  scale: diceGameController.resultScale.value,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color:
                          diceGameController.lastWin.value == true
                              ? Colors.green.withValues(alpha: 0.9)
                              : Colors.red.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      diceGameController.lastWin.value == true
                          ? '🎉 WIN!'
                          : '❌ LOSE',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDice(int number) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: CustomPaint(painter: DicePainter(number)),
    );
  }

  Widget _buildStakeInput() {
    return Obx(() {
      if (diceGameController.balance.value <= 0) return SizedBox.shrink();
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primaryColor.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Stake Amount',
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: // In _buildStakeInput method
                      Obx(() {
                    final balance = diceGameController.balance.value;
                    final maxStake = balance > 0 ? balance : 1.0;
                    final currentStake = diceGameController.stake.value;

                    // Ensure stake is within bounds
                    if (currentStake > maxStake) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        diceGameController.stake.value = maxStake;
                      });
                    }

                    return Slider(
                      value: currentStake.clamp(1.0, maxStake),
                      min: 1.0,
                      max: maxStake,
                      divisions: (maxStake - 1).toInt(),
                      activeColor: AppColors.primaryColor,
                      inactiveColor: Colors.grey.withOpacity(0.3),
                      onChanged: (value) {
                        if (diceGameController.isRolling.value) return;
                        diceGameController.stake.value = value;
                      },
                    );
                  }),
                ),
                const SizedBox(width: 12),
                Obx(() {
                  return Text(
                    diceGameController.stake.value.toStringAsFixed(2),
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildPredictionSelector() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Obx(() {
                  return GestureDetector(
                    onTap: () {
                      if (diceGameController.isRolling.value) return;
                      diceGameController.isOver.value = true;
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color:
                            diceGameController.isOver.value
                                ? AppColors.primaryColor
                                : AppColors.primaryColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'OVER',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Obx(() {
                  return GestureDetector(
                    onTap: () {
                      if (diceGameController.isRolling.value) return;
                      diceGameController.isOver.value = false;
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color:
                            !diceGameController.isOver.value
                                ? AppColors.primaryColor
                                : AppColors.primaryColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'UNDER',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() {
            return Text(
              'Predict ${diceGameController.isOver.value ? 'Over' : 'Under'}',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            );
          }),
          const SizedBox(height: 8),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                final number = index + 1;
                final isSelected =
                    diceGameController.predictedNumber.value == number;
                return GestureDetector(
                  onTap: () {
                    if (diceGameController.isRolling.value) return;
                    diceGameController.predictedNumber.value = number;
                  },
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? AppColors.primaryColor
                              : Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color:
                            isSelected
                                ? Colors.white
                                : AppColors.primaryColor.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$number',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
      ),
      child: Obx(
        () => Row(
          children: [
            Expanded(
              child: _buildStatItem(
                'Win Chance',
                '${diceGameController.winChance.value.toStringAsFixed(1)}%',
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: AppColors.primaryColor.withValues(alpha: 0.3),
            ),
            Expanded(
              child: _buildStatItem(
                'Multiplier',
                '${diceGameController.multiplier.value.toStringAsFixed(2)}x',
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: AppColors.primaryColor.withOpacity(0.3),
            ),
            Expanded(
              child: _buildStatItem(
                'Potential Win',
                '\$${diceGameController.potentialWin.value.toStringAsFixed(2)}',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildRollButton() {
    return Obx(() {
      // final isRolling = diceGameController.isRolling.value;
      final stake = diceGameController.stake.value;
      final balance = diceGameController.balance.value;
      final canRoll = !diceGameController.isRolling.value && stake <= balance;
      return CustomButton(
        ontap: canRoll ? diceGameController.rollDice : () {},
        isLoading: diceGameController.isRolling,
        bgColor: canRoll ? AppColors.primaryColor : Colors.grey,
        child: Text(
          'ROLL DICE',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      );
    });
  }

  Widget _buildHistory() {
    return Obx(() {
      if (diceGameController.history.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Rolls',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...diceGameController.history.take(10).map((game) => _buildHistoryItem(game)),
        ],
      );
    });
  }

  Widget _buildHistoryItem(GameHistory game) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              game.won
                  ? Colors.green.withOpacity(0.3)
                  : Colors.red.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color:
                  game.won
                      ? Colors.green.withOpacity(0.2)
                      : Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              '${game.result}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  game.won ? 'Won' : 'Lost',
                  style: TextStyle(
                    color: game.won ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Stake: ${game.stake.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            game.won
                ? '+${(game.payout - game.stake).toStringAsFixed(2)}'
                : '-${game.stake.toStringAsFixed(2)}',
            style: TextStyle(
              color: game.won ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
