import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

// PINTOR DE TENTÁCULOS (Fractal Energy)
class FractalEnergyPainter extends CustomPainter {
  final double animationValue;
  final double pulseValue;
  final bool isSpeaking; // Cambia si TARS habla

  FractalEnergyPainter({required this.animationValue, required this.pulseValue, required this.isSpeaking});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()..style = PaintingStyle.stroke..strokeWidth = 1.5;

    int totalTentacles = isSpeaking ? 24 : 12; // Más tentáculos al hablar
    double excitement = isSpeaking ? 2.0 : 1.0;

    for (int i = 0; i < totalTentacles; i++) {
      double angle = (i * 2 * math.pi / totalTentacles) + (animationValue * 0.2 * excitement);
      final path = Path();
      path.moveTo(center.dx, center.dy);

      double x2 = center.dx + math.cos(angle) * 300;
      double y2 = center.dy + math.sin(angle) * 300;
      double endX = center.dx + math.cos(angle + animationValue) * size.width;
      double endY = center.dy + math.sin(angle + animationValue) * size.height;

      path.cubicTo(
          center.dx + math.cos(angle) * 100 * pulseValue,
          center.dy + math.sin(angle) * 100 * pulseValue,
          x2, y2, endX, endY
      );

      paint.shader = ui.Gradient.linear(
        center, Offset(endX, endY),
        [
          isSpeaking ? const Color(0xFF00FFFF).withOpacity(0.8) : const Color(0xFFBB37E6).withOpacity(0.6),
          Colors.transparent
        ],
      );
      canvas.drawPath(path, paint);
    }
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// PINTOR DE GRID TÁCTICO
class QuantumGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.05)..strokeWidth = 0.5;
    double gridSize = 50.0;
    for (double i = 0; i < size.width; i += gridSize) canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    for (double i = 0; i < size.height; i += gridSize) canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);

    // Dibujar cruces tácticas
    final crossPaint = Paint()..color = Colors.white.withOpacity(0.2)..strokeWidth = 2;
    canvas.drawLine(Offset(20, 50), Offset(40, 50), crossPaint);
    canvas.drawLine(Offset(30, 40), Offset(30, 60), crossPaint);

    canvas.drawLine(Offset(size.width - 40, 50), Offset(size.width - 20, 50), crossPaint);
    canvas.drawLine(Offset(size.width - 30, 40), Offset(size.width - 30, 60), crossPaint);
  }
  @override bool shouldRepaint(CustomPainter oldDelegate) => false;
}