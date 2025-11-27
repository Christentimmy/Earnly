
import 'package:flutter/material.dart';


class DicePainter extends CustomPainter {
  final int number;

  DicePainter(this.number);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
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