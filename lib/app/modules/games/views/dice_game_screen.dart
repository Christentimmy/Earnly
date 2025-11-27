import 'package:flutter/material.dart';
import 'dart:math' as math;

class AppColors {
  static const Color primaryColor = Color.fromARGB(255, 32, 70, 39);
  static const Color backgroundColor = Color(0xFF0A1A0C);
}

class DiceGameScreen extends StatefulWidget {
  const DiceGameScreen({super.key});

  @override
  State<DiceGameScreen> createState() => _DiceGameScreenState();
}

class _DiceGameScreenState extends State<DiceGameScreen>
    with TickerProviderStateMixin {
  double balance = 1000.0;
  double stake = 10.0;
  int predictedNumber = 4;
  bool isOver = true;
  bool isRolling = false;
  int? rolledNumber;
  bool? lastWin;

  late AnimationController _diceController;
  late AnimationController _resultController;
  late Animation<double> _diceRotation;
  late Animation<double> _diceScale;
  late Animation<double> _resultScale;

  List<GameHistory> history = [];

  @override
  void initState() {
    super.initState();
    _diceController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _resultController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _diceRotation = Tween<double>(begin: 0, end: 8 * math.pi).animate(
      CurvedAnimation(parent: _diceController, curve: Curves.easeOutCubic),
    );

    _diceScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 0.9), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.0), weight: 30),
    ]).animate(CurvedAnimation(parent: _diceController, curve: Curves.easeInOut));

    _resultScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _resultController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _diceController.dispose();
    _resultController.dispose();
    super.dispose();
  }

  double get winChance {
    if (isOver) {
      return ((6 - predictedNumber) / 6) * 100;
    } else {
      return (predictedNumber / 6) * 100;
    }
  }

  double get multiplier {
    return 100 / winChance;
  }

  double get potentialWin {
    return stake * multiplier;
  }

  void rollDice() async {
    if (isRolling || stake > balance) return;

    setState(() {
      isRolling = true;
      lastWin = null;
      rolledNumber = null;
    });

    _diceController.forward(from: 0);

    await Future.delayed(const Duration(milliseconds: 1200));

    final random = math.Random();
    final result = random.nextInt(6) + 1;

    bool won = isOver ? result > predictedNumber : result < predictedNumber;

    setState(() {
      rolledNumber = result;
      lastWin = won;
      balance = won ? balance + (potentialWin - stake) : balance - stake;
      
      history.insert(0, GameHistory(
        stake: stake,
        result: result,
        won: won,
        payout: won ? potentialWin : 0,
      ));
      
      if (history.length > 10) history.removeLast();
    });

    await Future.delayed(const Duration(milliseconds: 300));
    _resultController.forward(from: 0);

    await Future.delayed(const Duration(milliseconds: 2000));

    setState(() {
      isRolling = false;
    });
  }

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
                    const SizedBox(height: 30),
                    _buildStakeInput(),
                    const SizedBox(height: 20),
                    _buildPredictionSelector(),
                    const SizedBox(height: 20),
                    _buildStatsCard(),
                    const SizedBox(height: 20),
                    _buildRollButton(),
                    const SizedBox(height: 30),
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
          const Text(
            '🎲 Dice Game',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '\$${balance.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiceArea() {
    return Container(
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _diceController,
            builder: (context, child) {
              return Transform.scale(
                scale: _diceScale.value,
                child: Transform.rotate(
                  angle: _diceRotation.value,
                  child: _buildDice(rolledNumber ?? 1),
                ),
              );
            },
          ),
          if (lastWin != null)
            AnimatedBuilder(
              animation: _resultController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _resultScale.value,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: lastWin!
                          ? Colors.green.withOpacity(0.9)
                          : Colors.red.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      lastWin! ? '🎉 WIN!' : '❌ LOSE',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
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
      child: CustomPaint(
        painter: DicePainter(number),
      ),
    );
  }

  Widget _buildStakeInput() {
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
          const Text(
            'Stake Amount',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: stake,
                  min: 1,
                  max: math.min(balance, 100),
                  divisions: 99,
                  activeColor: AppColors.primaryColor,
                  inactiveColor: AppColors.primaryColor.withOpacity(0.3),
                  onChanged: isRolling
                      ? null
                      : (value) {
                          setState(() {
                            stake = value;
                          });
                        },
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '\$${stake.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
                child: GestureDetector(
                  onTap: isRolling
                      ? null
                      : () {
                          setState(() {
                            isOver = true;
                          });
                        },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isOver
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
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: isRolling
                      ? null
                      : () {
                          setState(() {
                            isOver = false;
                          });
                        },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: !isOver
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
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Predict ${isOver ? 'Over' : 'Under'}',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(6, (index) {
              final number = index + 1;
              final isSelected = predictedNumber == number;
              return GestureDetector(
                onTap: isRolling
                    ? null
                    : () {
                        setState(() {
                          predictedNumber = number;
                        });
                      },
                child: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryColor
                        : Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? Colors.white
                          : AppColors.primaryColor.withOpacity(0.3),
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
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              'Win Chance',
              '${winChance.toStringAsFixed(1)}%',
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: AppColors.primaryColor.withOpacity(0.3),
          ),
          Expanded(
            child: _buildStatItem(
              'Multiplier',
              '${multiplier.toStringAsFixed(2)}x',
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
              '\$${potentialWin.toStringAsFixed(2)}',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
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
    final canRoll = !isRolling && stake <= balance;
    return GestureDetector(
      onTap: canRoll ? rollDice : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          gradient: canRoll
              ? LinearGradient(
                  colors: [
                    AppColors.primaryColor,
                    AppColors.primaryColor.withGreen(100),
                  ],
                )
              : null,
          color: canRoll ? null : Colors.grey,
          borderRadius: BorderRadius.circular(12),
          boxShadow: canRoll
              ? [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          isRolling ? 'ROLLING...' : 'ROLL DICE',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildHistory() {
    if (history.isEmpty) return const SizedBox.shrink();

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
        ...history.map((game) => _buildHistoryItem(game)).toList(),
      ],
    );
  }

  Widget _buildHistoryItem(GameHistory game) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: game.won ? Colors.green.withOpacity(0.3) : Colors.red.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: game.won ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
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
                  'Stake: \$${game.stake.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            game.won ? '+\$${(game.payout - game.stake).toStringAsFixed(2)}' : '-\$${game.stake.toStringAsFixed(2)}',
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

class DicePainter extends CustomPainter {
  final int number;

  DicePainter(this.number);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final dotRadius = size.width * 0.08;

    switch (number) {
      case 1:
        canvas.drawCircle(center, dotRadius, paint);
        break;
      case 2:
        canvas.drawCircle(
          Offset(size.width * 0.3, size.height * 0.3),
          dotRadius,
          paint,
        );
        canvas.drawCircle(
          Offset(size.width * 0.7, size.height * 0.7),
          dotRadius,
          paint,
        );
        break;
      case 3:
        canvas.drawCircle(
          Offset(size.width * 0.3, size.height * 0.3),
          dotRadius,
          paint,
        );
        canvas.drawCircle(center, dotRadius, paint);
        canvas.drawCircle(
          Offset(size.width * 0.7, size.height * 0.7),
          dotRadius,
          paint,
        );
        break;
      case 4:
        canvas.drawCircle(
          Offset(size.width * 0.3, size.height * 0.3),
          dotRadius,
          paint,
        );
        canvas.drawCircle(
          Offset(size.width * 0.7, size.height * 0.3),
          dotRadius,
          paint,
        );
        canvas.drawCircle(
          Offset(size.width * 0.3, size.height * 0.7),
          dotRadius,
          paint,
        );
        canvas.drawCircle(
          Offset(size.width * 0.7, size.height * 0.7),
          dotRadius,
          paint,
        );
        break;
      case 5:
        canvas.drawCircle(
          Offset(size.width * 0.3, size.height * 0.3),
          dotRadius,
          paint,
        );
        canvas.drawCircle(
          Offset(size.width * 0.7, size.height * 0.3),
          dotRadius,
          paint,
        );
        canvas.drawCircle(center, dotRadius, paint);
        canvas.drawCircle(
          Offset(size.width * 0.3, size.height * 0.7),
          dotRadius,
          paint,
        );
        canvas.drawCircle(
          Offset(size.width * 0.7, size.height * 0.7),
          dotRadius,
          paint,
        );
        break;
      case 6:
        canvas.drawCircle(
          Offset(size.width * 0.3, size.height * 0.25),
          dotRadius,
          paint,
        );
        canvas.drawCircle(
          Offset(size.width * 0.7, size.height * 0.25),
          dotRadius,
          paint,
        );
        canvas.drawCircle(
          Offset(size.width * 0.3, size.height * 0.5),
          dotRadius,
          paint,
        );
        canvas.drawCircle(
          Offset(size.width * 0.7, size.height * 0.5),
          dotRadius,
          paint,
        );
        canvas.drawCircle(
          Offset(size.width * 0.3, size.height * 0.75),
          dotRadius,
          paint,
        );
        canvas.drawCircle(
          Offset(size.width * 0.7, size.height * 0.75),
          dotRadius,
          paint,
        );
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class GameHistory {
  final double stake;
  final int result;
  final bool won;
  final double payout;

  GameHistory({
    required this.stake,
    required this.result,
    required this.won,
    required this.payout,
  });
}