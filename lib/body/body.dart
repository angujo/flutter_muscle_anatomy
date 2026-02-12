library;

import 'package:flutter/material.dart';
import 'package:flutter_muscle_anatomy/core/core.dart';
import 'dart:math' as math;
import 'package:path_drawing/path_drawing.dart';

part 'body_mixins.dart';

abstract class _SkeletalMuscles
    with StrokesFill, MusclesHighlights, BuildsSvgWriter {
  @override
  final BodyView _view;
  final SvgPathReader _svgPathReader;
  @override
  late Dim dimension;

  Color? get _hairColor;

  late final Dim svgDimension = Dim(
    _svgPathReader.width,
    _svgPathReader.height,
  );

  Path get outlinePath =>
      parseSvgPathData(_svgPathReader.getPathDs('outline').first);

  _SkeletalMuscles({
    required BodyView view,
    required SvgPathReader svgPathReader,
  }) : _view = view,
       _svgPathReader = svgPathReader,
       dimension = Dim(svgPathReader.width, svgPathReader.height);

  @override
  List<SvgGroup> _getRootBuilds() {
    final build = SvgGroup(id: _view.name);
    final outline = SvgPath(
      id: 'outline_${_view.name}',
      d: _svgPathReader.getPathDs('outline_${_view.name}').first,
    );
    build.addChild(outline);
    for (var (muscle, position) in _nonHighlightedMuscles) {
      if (muscle.view != _view) continue;
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
      if (highlight.muscle.view != _view) continue;
      build.addChild(
        Muscle.fromHighlight(
          highlight,
          strokeColor: _strokeColor,
          strokeWidth: _strokeWidth,
        ),
      );
    }
    if (null != _hairColor) {
      final hairs = _svgPathReader.getPathDs('hair_outline');
      if (hairs.isNotEmpty) {
        build.addChild(
          SvgPath(id: 'hair_outline_${_view.name}', d: hairs.first)
            ..stroke(_strokeColor, width: _strokeWidth)
            ..fill(_hairColor, opacity: _defFillOpacity),
        );
      }
    }
    return [build];
  }
}

//region Male
class _MaleSkeletalMuscles extends _SkeletalMuscles {
  @override
  final List<Muscle> _muscles = BodyMuscle.male.all;

  _MaleSkeletalMuscles({required super.view})
    : super(svgPathReader: SvgPathReader.male(view: view));

  @override
  final Color? _hairColor = null;
}

class _MaleFrontSkeletalMuscles extends _MaleSkeletalMuscles {
  @override
  List<Muscle> get _muscles => BodyMuscle.male.front;

  _MaleFrontSkeletalMuscles() : super(view: BodyView.front);
}

class _MaleBackSkeletalMuscles extends _MaleSkeletalMuscles {
  @override
  List<Muscle> get _muscles => BodyMuscle.male.back;

  _MaleBackSkeletalMuscles() : super(view: BodyView.back);
}
//endregion

abstract class _Body with BuildsSvgWriter implements IMuscleHighlights {
  final List<_SkeletalMuscles> _skeletals;

  @override
  late final Dim dimension = Dim(
    _skeletals.fold(0, (val, sk) => val + sk.dimension.width),
    _skeletals.map((s) => s.dimension.height).reduce(math.max),
  );

  _Body._(this._skeletals);

  @override
  void highlight(
    Muscle muscle, {
    MusclePosition? position,
    Color? color,
    double? opacity,
  }) {
    for (final skeletal in _skeletals) {
      skeletal.highlight(
        muscle,
        position: position,
        color: color,
        opacity: opacity,
      );
    }
  }

  @override
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

  @override
  List<SvgGroup> _getRootBuilds() {
    List<SvgGroup> groups = [];
    double x = 0;
    for (final entry in _skeletals.asMap().entries) {
      final group = SvgGroup(id: 'skeletal_${entry.key}');
      if (0 != x) {
        group.addAttribute('transform', 'translate($x,0)');
      }
      group.addChildren(entry.value._getRootBuilds());
      groups.add(group);
      x += entry.value.dimension.width + 2;
    }
    return groups;
  }
}

class Male extends _Body {
  static final BodyMuscles muscles = BodyMuscle.male;

  Male._(super.skeletalMuscles) : super._();

  static Male front() => Male._([_MaleFrontSkeletalMuscles()]);

  static Male back() => Male._([_MaleBackSkeletalMuscles()]);

  static Male frontBack() =>
      Male._([_MaleFrontSkeletalMuscles(), _MaleBackSkeletalMuscles()]);

  static Male backFront() =>
      Male._([_MaleBackSkeletalMuscles(), _MaleFrontSkeletalMuscles()]);

  static Male both() => frontBack();
}
