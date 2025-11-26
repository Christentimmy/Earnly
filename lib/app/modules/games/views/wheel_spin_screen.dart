import 'package:flutter/material.dart';
import 'dart:math' as math;

class WheelSpinScreen extends StatefulWidget {
  const WheelSpinScreen({super.key});

  @override
  State<WheelSpinScreen> createState() => _WheelSpinScreenState();
}

class _WheelSpinScreenState extends State<WheelSpinScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isSpinning = false;
  bool _hasSpunToday = false;
  int? _lastReward;

  final List<int> _rewards = [250, 5, 10, 20, 50, 70, 90, 150];
  final List<Color> _segmentColors = [
    const Color(0xFF2D3142),
    const Color(0xFF4F5D75),
    const Color(0xFF2D3142),
    const Color(0xFF4F5D75),

    const Color(0xFF2D3142),
    const Color(0xFF4F5D75),
    const Color(0xFF2D3142),
    const Color(0xFF4F5D75),
  ];

  static final Map<int, double> eachSegmentAngle = {
    250: 22,
    5: 67,
    10: 112,
    20: 157,
    50: 202,
    70: 247,
    90: 292,
    150: 337,
  };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    // _checkIfSpunToday();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _checkIfSpunToday() {
    setState(() {
      _hasSpunToday = false;
    });
  }

  void _spinWheel() {
    if (_isSpinning || _hasSpunToday) return;

    setState(() {
      _isSpinning = true;
    });

    final random = math.Random();
    final rewardIndex = random.nextInt(_rewards.length);
    final reward = _rewards[rewardIndex];
    print("Reward: $reward");
    print("Reward Index: $rewardIndex");

    final segmentAngle = 360.0 / _rewards.length;
    // Calculate the angle to the middle of the target segment
    // final targetAngle = (rewardIndex * segmentAngle) + (segmentAngle / 2);
    final targetAngle = eachSegmentAngle[reward] ?? 0;
    print("Target Angle: $targetAngle");
    // Convert to negative for clockwise rotation and adjust for the starting position
    final adjustedAngle = 360 - targetAngle;
    // print("Adjusted Angle: $adjustedAngle");

    // final fullRotations = 5 + random.nextDouble() * 2;
    final fullRotations = 360 * (random.nextInt(6) + 1);
    final totalRotation = (fullRotations) + adjustedAngle;
    // final totalRotation = adjustedAngle;

    _animation = Tween<double>(
      begin: 0,
      end: totalRotation,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward(from: 0).then((_) {
      setState(() {
        _isSpinning = false;
        // _hasSpunToday = true;
        _lastReward = reward;
      });
      _showRewardPopup(reward);
      _controller.reset();
    });
  }

  void _showRewardPopup(int reward) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => RewardPopup(reward: reward),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      body: SafeArea(
        child: Column(
          children: [
            // Minimalist Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF2D3142),
                        width: 1,
                      ),
                      image: const DecorationImage(
                        image: AssetImage("assets/images/profile.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1D2E),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF2D3142),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.circle, color: Color(0xFFBFA26C), size: 8),
                        SizedBox(width: 8),
                        Text(
                          "1,250",
                          style: TextStyle(
                            color: Color(0xFFE8E8E8),
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: const Color(0xFFBFA26C).withOpacity(0.3),
                    width: 1,
                  ),
                ),
              ),
              child: Text(
                _hasSpunToday ? "COMPLETED TODAY" : "ONE SPIN AVAILABLE",
                style: TextStyle(
                  color:
                      _hasSpunToday
                          ? const Color(0xFF6B7280)
                          : const Color(0xFFBFA26C),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
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
                        // color: Colors.red,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFFBFA26C,
                            ).withValues(alpha: 0.15),
                            blurRadius: 60,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                    ),

                    // Wheel
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _animation.value * math.pi / 180,
                          child: CustomPaint(
                            size: const Size(260, 260),
                            painter: WheelPainter(
                              rewards: _rewards,
                              colors: _segmentColors,
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
                            color: Colors.black.withOpacity(0.5),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                _hasSpunToday && _lastReward != null
                    ? "You earned $_lastReward coins today"
                    : "Win between 5 and 70 coins",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.3,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Spin button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: GestureDetector(
                onTap: _spinWheel,
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    color:
                        (_isSpinning || _hasSpunToday)
                            ? const Color(0xFF1A1D2E)
                            : const Color(0xFFBFA26C),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          (_isSpinning || _hasSpunToday)
                              ? const Color(0xFF2D3142)
                              : const Color(0xFFBFA26C),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child:
                        _isSpinning
                            ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    color: Color(0xFFBFA26C),
                                    strokeWidth: 2,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  "SPINNING",
                                  style: TextStyle(
                                    color: Color(0xFFBFA26C),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ],
                            )
                            : Text(
                              _hasSpunToday ? "RETURN TOMORROW" : "SPIN WHEEL",
                              style: TextStyle(
                                color:
                                    (_isSpinning || _hasSpunToday)
                                        ? const Color(0xFF6B7280)
                                        : const Color(0xFF0A0E27),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 2,
                              ),
                            ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

// Custom Wheel Painter
class WheelPainter extends CustomPainter {
  final List<int> rewards;
  final List<Color> colors;

  WheelPainter({required this.rewards, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final segmentAngle = 2 * math.pi / rewards.length;

    for (int i = 0; i < rewards.length; i++) {
      // Draw segment
      final paint =
          Paint()
            ..color = colors[i]
            ..style = PaintingStyle.fill;

      final startAngle = -math.pi / 2 + (i * segmentAngle);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        segmentAngle,
        true,
        paint,
      );

      // Draw subtle border
      final borderPaint =
          Paint()
            ..color = const Color(0xFF0A0E27)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        segmentAngle,
        true,
        borderPaint,
      );

      // Draw text
      final textAngle = startAngle + segmentAngle / 2;
      final textRadius = radius * 0.7;
      final textX = center.dx + textRadius * math.cos(textAngle);
      final textY = center.dy + textRadius * math.sin(textAngle);

      final textPainter = TextPainter(
        text: TextSpan(
          text: rewards[i].toString(),
          style: const TextStyle(
            color: Color(0xFFBFA26C),
            fontSize: 22,
            fontWeight: FontWeight.w300,
            letterSpacing: 1,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      canvas.save();
      canvas.translate(textX, textY);
      canvas.rotate(textAngle + math.pi / 2);
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );
      canvas.restore();
    }

    // Draw outer circle border
    final outerBorderPaint =
        Paint()
          ..color = const Color(0xFFBFA26C)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

    canvas.drawCircle(center, radius, outerBorderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Triangle Pointer Painter
class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = const Color(0xFFBFA26C)
          ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width / 2, size.height);
    path.lineTo(0, 0);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Refined Reward Popup
class RewardPopup extends StatefulWidget {
  final int reward;

  const RewardPopup({super.key, required this.reward});

  @override
  State<RewardPopup> createState() => _RewardPopupState();
}

class _RewardPopupState extends State<RewardPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOut,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeIn,
    );

    _scaleController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: const Color(0xFF0A0E27),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFBFA26C).withOpacity(0.5),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFBFA26C),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.star_border,
                    color: Color(0xFFBFA26C),
                    size: 40,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  "Reward Claimed",
                  style: TextStyle(
                    color: Color(0xFFE8E8E8),
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.circle, color: Color(0xFFBFA26C), size: 8),
                    const SizedBox(width: 12),
                    Text(
                      "${widget.reward}",
                      style: const TextStyle(
                        color: Color(0xFFBFA26C),
                        fontSize: 48,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                const Text(
                  "Return tomorrow for another spin",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 32),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    // TODO: Call your endpoint here to update balance
                    // await updateBalance(widget.reward);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFBFA26C),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        "CONTINUE",
                        style: TextStyle(
                          color: Color(0xFF0A0E27),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
