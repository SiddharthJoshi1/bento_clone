import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UltraBackground extends StatefulWidget {
  final Widget child;

  const UltraBackground({super.key, required this.child});

  @override
  State<UltraBackground> createState() => _UltraBackgroundState();
}

class _UltraBackgroundState extends State<UltraBackground> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(painter: BackgroundPainter(), child: Container()),
        widget.child,
      ],
    );
  }
}

class BackgroundPainter extends CustomPainter {
  void paintBackground(Canvas canvas, Size size) {
    Paint paintVariant1 = Paint()
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 200);
    paintVariant1.color = Color((0xFFFAAA).toInt()).withValues(alpha: 0.5);
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.5),
        width: size.width,
        height: size.height,
      ),
      paintVariant1,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    paintBackground(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
