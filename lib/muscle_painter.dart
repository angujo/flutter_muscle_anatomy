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
    for (var path in paths) {
      _paintPath(path, canvas);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  void _paintPath(Path path, Canvas canvas) {
    Paint stroke = strokePaint ?? Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    Paint fill = fillPaint ?? Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, stroke);
    canvas.drawPath(path, fill);
  }
}
