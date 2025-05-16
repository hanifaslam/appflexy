import 'package:flutter/material.dart';

class CloudPainter extends CustomPainter {
  final Color color;
  final double opacity;

  CloudPainter({this.color = Colors.white, this.opacity = 0.5});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(opacity)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width * 0.2, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.1, size.height * 0.3, size.width * 0.35, size.height * 0.3);
    path.quadraticBezierTo(size.width * 0.4, 0, size.width * 0.65, size.height * 0.2);
    path.quadraticBezierTo(size.width * 0.9, 0, size.width * 0.85, size.height * 0.4);
    path.quadraticBezierTo(size.width, size.height * 0.5, size.width * 0.8, size.height * 0.7);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CloudPainter oldDelegate) => false;
}