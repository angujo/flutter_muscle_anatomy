import 'dart:ui';

import 'package:flutter_muscle_anatomy/core/muscle.dart';
import 'package:flutter_muscle_anatomy/core/muscle_painter.dart';

mixin HasPaint {
  Paint? strokePaint;
  Paint? fillPaint;
}
mixin HasMuscle<T extends Muscle> on HasPaint {
  T get muscle;

  MusclesPainter painter() => MusclesPainter.fromMuscles(
    [muscle],
    strokePaint: strokePaint,
    fillPaint: fillPaint,
  );
}
mixin HasMuscles<T extends Muscle> on HasPaint {
  List<T> get muscles;

  MusclesPainter painter() => MusclesPainter.fromMuscles(
    muscles,
    strokePaint: strokePaint,
    fillPaint: fillPaint,
  );
}

mixin HasSymmetricalMuscles<T extends Muscle> on HasPaint, HasMuscle {
  List<Path> get leftMusclePaths;

  List<Path> get rightMusclePaths;

  PathsPainter rightPainter() => PathsPainter.fromPaths(
    rightMusclePaths,
    strokePaint: strokePaint,
    fillPaint: fillPaint,
  );

  PathsPainter leftPainter() => PathsPainter.fromPaths(
    leftMusclePaths,
    strokePaint: strokePaint,
    fillPaint: fillPaint,
  );
}

mixin RequiresViewBox {
  late Size _size;

  Size get size => _size;

  void setSize(Size s) => _size = s;
}
