library;

import 'package:flutter/material.dart';
import 'package:flutter_muscle_anatomy/core/core.dart';
import 'dart:math' as math;
import 'package:path_drawing/path_drawing.dart';

part 'male_front.dart';

abstract class _Body {
  final Color _strokeColor;
  final double _strokeWidth;
  final Color _defFillColor;
  final double _defFillOpacity;
  final Color _defHighlightColor;
  final double _defHighlightOpacity;
  final Map<(Muscle, MusclePosition), MuscleHighlight<Muscle>> _highlights = {};
  late SvgFileWriter _svgFile;

  SvgElement get _bodySvgElement;

  SvgPathReader get _svgPathReader;

  String get _outlineId;

  List<Muscle> get _muscles;

  bool _built = false;

  Size get svgSize => Size(_svgPathReader.width, _svgPathReader.height);

  Path get outlinePath =>
      parseSvgPathData(_svgPathReader.getPathDs(_outlineId).first);

  List<(Muscle, MusclePosition)> get highlightedMuscles =>
      _highlights.keys.toList();

  List<(Muscle, MusclePosition)> get nonHighlightedMuscles {
    final Set<(Muscle, MusclePosition)> highlighted = Set.from(
      highlightedMuscles,
    );
    return _muscles
        .map((m) {
          final both = (m, MusclePosition.both);
          if (highlighted.contains(both)) {
            return <(Muscle, MusclePosition)>[];
          }
          final left = (m, MusclePosition.left);
          final right = (m, MusclePosition.right);
          final positions = {left, right};
          final diff = positions.difference(highlighted);
          if (diff.length == positions.length) return [both];
          return List<(Muscle, MusclePosition)>.from(diff);
        })
        .expand((l) => l)
        .toList();
  }

  _Body({
    Color strokeColor = Colors.black,
    double strokeWidth = 0.2,
    Color defFillColor = Colors.transparent,
    double defFillOpacity = 0,
    Color defHighlightColor = Colors.red,
    double defHighlightOpacity = 0.5,
    List<Muscle> muscles = const [],
  }) : _defHighlightOpacity = defHighlightOpacity,
       _defHighlightColor = defHighlightColor,
       _defFillOpacity = defFillOpacity,
       _defFillColor = defFillColor,
       _strokeWidth = strokeWidth,
       _strokeColor = strokeColor {
    final entries = muscles
        .map(
          (m) => MuscleHighlight(
            muscle: m,
            color: _defHighlightColor,
            opacity: _defHighlightOpacity,
            position: MusclePosition.both,
          ),
        )
        .map((mh) => MapEntry((mh.muscle, MusclePosition.both), mh));
    _highlights.addAll(Map.fromEntries(entries));
  }

  void _prepareBuild() {
    _svgFile = SvgFileWriter(svgSize);
    final path = SvgPath(
      id: 'outline',
      d: _svgPathReader.getPathDs(_outlineId).first,
    )..stroke(_strokeColor, width: _strokeWidth);
    _bodySvgElement.addChild(path);
  }

  void rebuild() {
    _built = false;
    build();
  }

  void build() {
    if (_built) return;
    _prepareBuild();
    _built = true;

    for (var (muscle, position) in nonHighlightedMuscles) {
      _bodySvgElement.addChild(
        muscle.toSvgElement(
          position,
          fillColor: _defFillColor,
          fillOpacity: _defFillOpacity,
          strokeColor: _strokeColor,
          strokeWidth: _strokeWidth,
        ),
      );
    }
    for (final highlight in _highlights.values) {
      _bodySvgElement.addChild(
        Muscle.fromHighlight(
          highlight,
          strokeColor: _strokeColor,
          strokeWidth: _strokeWidth,
        ),
      );
    }

    _svgFile.addElement(_bodySvgElement);
    _svgFile.build();
  }

  @override
  String toString() {
    build();
    return _svgFile.toString();
  }

  void highlight(
    Muscle muscle, {
    MusclePosition? position,
    Color? color,
    double? opacity,
  }) {
    final key = (muscle, position ?? MusclePosition.both);
    final left = (muscle, MusclePosition.left);
    final right = (muscle, MusclePosition.right);
    final both = (muscle, MusclePosition.both);
    if (key == both) {
      _highlights.remove(left);
      _highlights.remove(right);
    } else if (_highlights.keys.contains(both)) {
      final bothHigh = _highlights.remove(both);
      _highlights.putIfAbsent(key == left ? right : left, () => bothHigh!);
    }
    _highlights.putIfAbsent(key, () {
      return MuscleHighlight(
        muscle: muscle,
        color: color ?? _defHighlightColor,
        opacity: opacity ?? _defHighlightOpacity,
        position: position ?? MusclePosition.both,
      );
    });
  }

  void highlights(
    Iterable<Muscle> muscles, {
    MusclePosition? position,
    Color? color,
    double? opacity,
  }) {
    for (final muscle in muscles) {
      highlight(muscle, position: position, color: color, opacity: opacity);
    }
  }

  PathPainter outlinePainter({required Paint stroke, Paint? fill}) {
    return PathPainter(
      path: outlinePath,
      svgSize: svgSize,
      strokePaint: stroke,
      fillPaint: fill,
    );
  }

  Size scaledSize(Size size, {bool fill = false}) {
    final mW = size.width / svgSize.width;
    final mH = size.height / svgSize.height;
    final scale = fill ? math.max(mW, mH) : math.min(mW, mH);
    return Size(svgSize.width * scale, svgSize.height * scale);
  }
}
