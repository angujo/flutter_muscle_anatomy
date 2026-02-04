import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_muscle_anatomy/core/app_enums.dart';
import 'package:flutter_muscle_anatomy/core/muscle.dart';
import 'package:flutter_muscle_anatomy/core/svg_file.dart';

class MuscleHighlight<T extends Muscle> {
  final T muscle;
  final MusclePosition position;
  final Color color;
  final double opacity;

  MuscleHighlight({
    required this.position,
    required this.color,
    required this.opacity,
    required this.muscle,
  });

  MuscleHighlight<T> copyWith({
    T? muscle,
    MusclePosition? position,
    Color? color,
    double? opacity,
  }) {
    return MuscleHighlight(
      muscle: muscle ?? this.muscle,
      position: position ?? this.position,
      color: color ?? this.color,
      opacity: opacity ?? this.opacity,
    );
  }

  List<SvgElement> toSvgElements() {
    List<String> paths = muscle.svgPaths;
    if (position == MusclePosition.left) paths = muscle.leftSvgPath;
    if (position == MusclePosition.right) paths = muscle.rightSvgPath;
    return paths
        .map((p) => SvgPath(id: 'path', d: p)..fill(color, opacity: opacity))
        .toList();
  }
}

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

class PathPainter extends CustomPainter {
  final Path path;
  final Paint strokePaint;
  final Paint? fillPaint;
  final Size svgSize;
  static final Paint _defaultStrokePaint = Paint()
    ..color = Colors.grey
    ..style = PaintingStyle.stroke
    ..strokeWidth = 0.5;

  PathPainter({
    super.repaint,
    required this.svgSize,
    required this.path,
    required this.strokePaint,
    this.fillPaint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / svgSize.width;
    final scaleY = size.height / svgSize.height;

    canvas.save();
    canvas.scale(scaleX, scaleY);

    canvas.drawPath(path, strokePaint);
    if (null != fillPaint) canvas.drawPath(path, fillPaint!);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant PathPainter oldDelegate) {
    return false;
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


class MoldFillPainter extends CustomPainter {
  final Path outlinePath;
  final double fillLevel; // 0.0 → 1.0
  final Color fillColor;

  MoldFillPainter({
    required this.outlinePath,
    required this.fillLevel,
    required this.fillColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = outlinePath.getBounds();

    // Scale uniformly to fit width
    final scale = size.width / bounds.width;

    // Center the path
    final dx = (size.width - bounds.width * scale) / 2 - bounds.left * scale;
    final dy = (size.height - bounds.height * scale) / 2 - bounds.top * scale;

    final matrix = Matrix4.identity()
      ..translate(dx, dy)
      ..scale(scale);

    final transformedPath = outlinePath.transform(matrix.storage);

    // --- Draw liquid ---
    canvas.save();
    canvas.clipPath(transformedPath);

    final liquidHeight = size.height * fillLevel;
    canvas.drawRect(
      Rect.fromLTWH(
        0,
        size.height - liquidHeight,
        size.width,
        liquidHeight,
      ),
      Paint()..color = fillColor,
    );

    canvas.restore();

    // --- Draw outline ---
    canvas.drawPath(
      transformedPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5
        ..color = Colors.black26,
    );
  }

  @override
  bool shouldRepaint(covariant MoldFillPainter oldDelegate) {
    return oldDelegate.fillLevel != fillLevel ||
        oldDelegate.fillColor != fillColor ||
        oldDelegate.outlinePath != outlinePath;
  }
}
