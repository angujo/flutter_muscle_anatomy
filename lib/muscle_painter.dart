import 'package:flutter/material.dart';

class MusclePainter extends CustomPainter {
  final Iterable<Path> paths;
  final Paint? strokePaint;
  final Paint? fillPaint;

  MusclePainter({
    super.repaint,
    required this.paths,
    this.strokePaint,
    this.fillPaint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
