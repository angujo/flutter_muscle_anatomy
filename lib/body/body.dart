library;

import 'package:flutter/material.dart';
import 'package:flutter_muscle_anatomy/core/core.dart';
import 'dart:math' as math;
import 'package:path_drawing/path_drawing.dart';

abstract class _Body {
  final Color _strokeColor;
  final double _strokeWidth;
  final Color _defFillColor;
  final double _defFillOpacity;
  final Color _defHighlightColor;
  final double _defHighlightOpacity;
  final Map<(Muscle, MusclePosition), MuscleHighlight<Muscle>> _highlights = {};
  late SvgFileWriter _svgFile;
  final BodyView _view;
  String? _hairOutlineId;

  SvgPathReader get _svgPathReader;

  List<Muscle> get _muscles;

  bool _built = false;

  Size get svgSize => Size(_svgPathReader.width, _svgPathReader.height);

  List<Path> get outlinePaths {
    final paths = <Path>[];
    switch (_view) {
      case BodyView.front:
        paths.add(
          parseSvgPathData(_svgPathReader.getPathDs('outline_front').first),
        );
        break;
      case BodyView.back:
        paths.add(
          parseSvgPathData(_svgPathReader.getPathDs('outline_back').first),
        );
        break;
      case BodyView.both:
        paths.add(
          parseSvgPathData(_svgPathReader.getPathDs('outline_front').first),
        );
        paths.add(
          parseSvgPathData(_svgPathReader.getPathDs('outline_back').first),
        );
        break;
      case BodyView.any:
        if (_frontHighlighted()) {
          paths.add(
            parseSvgPathData(_svgPathReader.getPathDs('outline_front').first),
          );
        }
        if (_backHighlighted()) {
          paths.add(
            parseSvgPathData(_svgPathReader.getPathDs('outline_back').first),
          );
        }
        if (!_frontHighlighted() && !_backHighlighted()) {
          paths.add(
            parseSvgPathData(_svgPathReader.getPathDs('outline_front').first),
          );
          paths.add(
            parseSvgPathData(_svgPathReader.getPathDs('outline_back').first),
          );
        }
        break;
    }
    return paths;
  }

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
    required BodyView view,
  }) : _defHighlightOpacity = defHighlightOpacity,
       _defHighlightColor = defHighlightColor,
       _defFillOpacity = defFillOpacity,
       _defFillColor = defFillColor,
       _strokeWidth = strokeWidth,
       _view = view,
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

  void rebuild() {
    _built = false;
    build();
  }

  bool _frontHighlighted() => highlightedMuscles
      .map((hm) => hm.$1)
      .any((m) => m.view == BodyView.front);

  bool _backHighlighted() =>
      highlightedMuscles.map((hm) => hm.$1).any((m) => m.view == BodyView.back);

  void _builder(String name, BodyView view) {
    final build = SvgGroup(id: name);
    final outline = SvgPath(
      id: 'outline_$name',
      d: _svgPathReader.getPathDs('outline_$name').first,
    );
    build.addChild(outline);
    for (var (muscle, position) in nonHighlightedMuscles) {
      if (muscle.view != view) continue;
      build.addChild(
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
      if (highlight.muscle.view != view) continue;
      build.addChild(
        Muscle.fromHighlight(
          highlight,
          strokeColor: _strokeColor,
          strokeWidth: _strokeWidth,
        ),
      );
    }
    if (null != _hairOutlineId) {
      build.addChild(
        SvgPath(
          id: '${_hairOutlineId}_$name',
          d: _svgPathReader.getPathDs('${_hairOutlineId}_$name').first,
        ),
      );
    }
    _svgFile.addElement(build);
  }

  void _buildFront() => _builder('front', BodyView.front);

  void _buildBack() => _builder('back', BodyView.back);

  void build() {
    if (_built) return;
    _svgFile = SvgFileWriter(svgSize);
    switch (_view) {
      case BodyView.front:
        _buildFront();
        break;
      case BodyView.back:
        _buildBack();
        break;
      case BodyView.both:
        _buildFront();
        _buildBack();
        break;
      case BodyView.any:
        if (_frontHighlighted()) {
          _buildFront();
        }
        if (_backHighlighted()) {
          _buildBack();
        }
        if (!_frontHighlighted() && !_backHighlighted()) {
          _buildFront();
          _buildBack();
        }
        break;
    }
    _built = true;
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

  Size scaledSize(Size size, {bool fill = false}) {
    final mW = size.width / svgSize.width;
    final mH = size.height / svgSize.height;
    final scale = fill ? math.max(mW, mH) : math.min(mW, mH);
    return Size(svgSize.width * scale, svgSize.height * scale);
  }
}

class Male extends _Body {
  static final BodyMuscles muscles = BodyMuscle.male;

  @override
  late final List<Muscle> _muscles = muscles.all;

  @override
  SvgPathReader _svgPathReader = SvgPathReader.male();

  Male({
    super.strokeColor = Colors.black,
    super.strokeWidth = 0.2,
    super.defFillColor = Colors.transparent,
    super.defFillOpacity = 0,
    super.defHighlightColor = Colors.red,
    super.defHighlightOpacity = 0.5,
    super.muscles = const [],
    super.view = BodyView.both,
  }) : _svgPathReader = SvgPathReader.male(view: view);

  static Male front({
    Color strokeColor = Colors.black,
    double strokeWidth = 0.2,
    Color defFillColor = Colors.transparent,
    double defFillOpacity = 0,
    Color defHighlightColor = Colors.red,
    double defHighlightOpacity = 0.5,
    List<Muscle> muscles = const [],
  }) => Male(
    muscles: muscles,
    strokeColor: strokeColor,
    strokeWidth: strokeWidth,
    defFillColor: defFillColor,
    defFillOpacity: defFillOpacity,
    defHighlightColor: defHighlightColor,
    defHighlightOpacity: defHighlightOpacity,
    view: BodyView.front,
  ).._svgPathReader = SvgPathReader.male(view: BodyView.front);

  static Male back({
    Color strokeColor = Colors.black,
    double strokeWidth = 0.2,
    Color defFillColor = Colors.transparent,
    double defFillOpacity = 0,
    Color defHighlightColor = Colors.red,
    double defHighlightOpacity = 0.5,
    List<Muscle> muscles = const [],
  }) => Male(
    muscles: muscles,
    strokeColor: strokeColor,
    strokeWidth: strokeWidth,
    defFillColor: defFillColor,
    defFillOpacity: defFillOpacity,
    defHighlightColor: defHighlightColor,
    defHighlightOpacity: defHighlightOpacity,
    view: BodyView.back,
  ).._svgPathReader = SvgPathReader.male(view: BodyView.back);
}
