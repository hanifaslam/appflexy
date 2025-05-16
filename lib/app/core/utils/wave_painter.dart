import 'package:flutter/material.dart';

class WavePainter extends CustomPainter {
  final List<Color> colors;
  final bool reverse;

  WavePainter({required this.colors, this.reverse = false});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..shader = LinearGradient(
        begin: reverse ? Alignment.bottomLeft : Alignment.topLeft,
        end: reverse ? Alignment.topRight : Alignment.bottomRight,
        colors: colors,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final Path path = Path();
    if (!reverse) {
      path.moveTo(0, size.height * 0.4);
      path.quadraticBezierTo(
          size.width * 0.35, size.height * 0.15, size.width * 0.7, size.height * 0.35);
      path.quadraticBezierTo(
          size.width * 0.95, size.height * 0.55, size.width, size.height * 0.2);
      path.lineTo(size.width, 0);
      path.lineTo(0, 0);
      path.close();
    } else {
      path.moveTo(size.width * 0.1, size.height);
      path.quadraticBezierTo(
          size.width * 0.5, size.height * 0.7, size.width * 0.85, size.height * 0.95);
      path.quadraticBezierTo(
          size.width * 1.1, size.height * 1.1, size.width, size.height * 0.5);
      path.lineTo(size.width, size.height);
      path.close();
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) => false;
}