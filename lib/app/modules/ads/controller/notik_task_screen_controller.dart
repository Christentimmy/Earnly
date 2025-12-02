import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotikTaskScreenController extends GetxController {
  final List<Color> gradientColors = [
    const Color(0xFF6A11CB),
    const Color(0xFF2575FC),
    const Color(0xFFFF416C),
    const Color(0xFFFF4B2B),
    Colors.deepOrangeAccent,
    Colors.orange,
    Colors.pinkAccent,
    Colors.tealAccent,
    const Color(0xFF00B09B), // teal/green
    const Color(0xFF96C93D), // lime/green
    const Color(0xFF11998E), // green
    const Color(0xFF38EF7D), // light green
    const Color(0xFFee0979), // magenta
    const Color(0xFFFF6A00), // orange
    const Color(0xFF7F00FF), // violet
    const Color(0xFF00C6FF), // cyan
  ];

  List<Color> getGradient() {
    if (gradientColors.length < 2) return [Colors.blue, Colors.purple];
    final random = Random();
    int firstIndex = random.nextInt(gradientColors.length);
    int secondIndex = random.nextInt(gradientColors.length - 1);
    if (secondIndex >= firstIndex) {
      secondIndex += 1;
    }
    return [gradientColors[firstIndex], gradientColors[secondIndex]];
  }
}
