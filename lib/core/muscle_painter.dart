import 'package:flutter/material.dart';
import 'package:flutter_muscle_anatomy/core/app_enums.dart';
import 'package:flutter_muscle_anatomy/core/muscle.dart';

class ItemPaint<T> {
  final T _item;
  Paint? strokePaint;
  Paint? leftFill;
  Paint? rightFill;

  ItemPaint(this._item, {this.strokePaint, this.leftFill, this.rightFill});
}

class PathPaint extends ItemPaint<Path> {
  Path get path => _item;

  PathPaint(super.item, {super.strokePaint, super.leftFill, super.rightFill});
}

class MusclePaint<T extends Muscle> extends ItemPaint<T> {
  T get muscle => _item;

  MusclePaint(super.item, {super.strokePaint, super.leftFill, super.rightFill});
}

class PathsPainter extends CustomPainter {
  final Iterable<PathPaint> _pathPaints;
  final Paint? _strokePaint;
  final Paint? _fillPaint;

  PathsPainter({
    super.repaint,
    required Iterable<PathPaint> pathPaints,
    required Paint? strokePaint,
    required Paint? fillPaint,
  }) : _pathPaints = pathPaints,
       _strokePaint = strokePaint,
       _fillPaint = fillPaint;

  @override
  void paint(Canvas canvas, Size size) {
    for (final pathPaint in _pathPaints) {
      _paintPath(pathPaint, canvas);
    }
  }

  void _paintPath(PathPaint pathPaint, Canvas canvas) {
    Paint stroke = pathPaint.strokePaint ?? _strokePaint ?? Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    Paint fill = _fillPaint ?? Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.fill;
    canvas.drawPath(pathPaint.path, stroke);
    canvas.drawPath(pathPaint.path, fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  static PathsPainter fromPaths(
    Iterable<Path> paths, {
    Paint? strokePaint,
    Paint? fillPaint,
  }) {
    return PathsPainter(
      pathPaints: paths.map((p) => PathPaint(p)),
      strokePaint: strokePaint,
      fillPaint: fillPaint,
    );
  }
}

class MusclesPainter extends CustomPainter {
  final Iterable<MusclePaint> _musclePaints;
  final Paint? _strokePaint;
  final Paint? _fillPaint;

  MusclesPainter({
    super.repaint,
    Paint? strokePaint,
    Paint? fillPaint,
    required Iterable<MusclePaint> musclePaints,
  }) : _fillPaint = fillPaint,
       _strokePaint = strokePaint,
       _musclePaints = musclePaints;

  @override
  void paint(Canvas canvas, Size size) {
    for (final musclePaint in _musclePaints) {
      _paintMuscle(musclePaint, canvas, size);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  void _paintMuscle(MusclePaint musclePaint, Canvas canvas, Size size) {
    Paint stroke = musclePaint.strokePaint ?? _strokePaint ?? Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    Paint fill = _fillPaint ?? Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.fill;

    Paint leftFill = musclePaint.leftFill ?? fill;
    Paint rightFill = musclePaint.rightFill ?? fill;

    _paintPaths(
      musclePaint.muscle.getPaths(size: size, position: MusclePosition.left),
      canvas,
      size,
      stroke,
      leftFill,
    );
    _paintPaths(
      musclePaint.muscle.getPaths(size: size, position: MusclePosition.right),
      canvas,
      size,
      stroke,
      rightFill,
    );
  }

  void _paintPaths(
    List<Path> paths,
    Canvas canvas,
    Size size,
    Paint stroke,
    Paint fill,
  ) {
    for (final path in paths) {
      canvas.drawPath(path, stroke);
      canvas.drawPath(path, fill);
    }
  }

  static MusclesPainter fromMuscles<T extends Muscle>(
    Iterable<T> muscles, {
    Paint? strokePaint,
    Paint? fillPaint,
  }) {
    return MusclesPainter(
      musclePaints: muscles.map((m) => MusclePaint(m)),
      strokePaint: strokePaint,
      fillPaint: fillPaint,
    );
  }
}
