import 'dart:ui';

import 'package:flutter_muscle_anatomy/muscle_painter.dart';

abstract class Muscle {
  final Size _size;
  final Paint? strokePaint;
  final Paint? fillPaint;

  Size get size => _size;

  Muscle(this._size, {this.strokePaint, this.fillPaint});

  List<Path> get paths;

  List<Path> get leftPaths;

  List<Path> get rightPaths;

  MusclePainter _paint(List<Path> pts) {
    return MusclePainter(
      paths: pts,
      strokePaint: strokePaint,
      fillPaint: fillPaint,
    );
  }

  MusclePainter painter() => _paint(paths);

  MusclePainter rightPainter() => _paint(rightPaths);

  MusclePainter leftPainter() => _paint(leftPaths);
}
