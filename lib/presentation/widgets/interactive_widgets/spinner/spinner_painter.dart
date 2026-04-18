import 'dart:math';
import 'package:flutter/material.dart';

/// Fixed colour palette for the spinner segments.
/// Hardcoded so colours are stable across repaints — no flicker.
const List<Color> _kSegmentColours = [
  Color(0xFF5C6BC0), // indigo
  Color(0xFF26A69A), // teal
  Color(0xFFEF5350), // red
  Color(0xFFFFA726), // orange
  Color(0xFF66BB6A), // green
  Color(0xFFAB47BC), // purple
];

class SpinnerPainter extends CustomPainter {
  final List<String> items;
  final double currentAngle;

  SpinnerPainter({
    required this.items,
    required this.currentAngle,
  }) : super(repaint: PaintingBinding.instance.systemFonts);

  @override
  void paint(Canvas canvas, Size size) {
    final centre = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: centre, radius: radius);
    final count = items.length;
    final sweep = (2 * pi) / count;

    for (var i = 0; i < count; i++) {
      final startAngle = currentAngle + (sweep * i) - (pi / 2);
      final paint = Paint()
        ..color = _kSegmentColours[i % _kSegmentColours.length]
        ..style = PaintingStyle.fill;

      canvas.drawArc(rect, startAngle, sweep, true, paint);

      // Divider line
      final dividerPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.3)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;
      final lineEnd = Offset(
        centre.dx + radius * cos(startAngle),
        centre.dy + radius * sin(startAngle),
      );
      canvas.drawLine(centre, lineEnd, dividerPaint);

      // Label
      _drawLabel(canvas, centre, radius, startAngle, sweep, items[i]);
    }
  }

  void _drawLabel(Canvas canvas, Offset centre, double radius,
      double startAngle, double sweep, String text) {
    final midAngle = startAngle + sweep / 2;
    final labelRadius = radius * 0.62;
    final labelOffset = Offset(
      centre.dx + labelRadius * cos(midAngle),
      centre.dy + labelRadius * sin(midAngle),
    );

    final span = TextSpan(
      text: text.length > 10 ? '${text.substring(0, 9)}…' : text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
    );
    final painter = TextPainter(
      text: span,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: radius * 0.6);

    canvas.save();
    canvas.translate(labelOffset.dx, labelOffset.dy);
    canvas.rotate(midAngle + pi / 2);
    painter.paint(
      canvas,
      Offset(-painter.width / 2, -painter.height / 2),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(SpinnerPainter oldDelegate) =>
      oldDelegate.currentAngle != currentAngle ||
      oldDelegate.items != items;
}
