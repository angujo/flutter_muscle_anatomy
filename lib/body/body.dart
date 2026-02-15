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

  MuscleHelper getMuscleHelper(Muscle muscle) =>
      MuscleHelper.fromMuscle(muscle, _svgPathReader);

  @override
  List<SvgGroup> _getRootBuilds() {
    final build = SvgGroup(id: _view.name);
    final outline = SvgPath(
      id: 'outline_${_view.name}',
      d: _svgPathReader.getPathDs('outline').first,
    );
    build.addChild(outline);
    for (var (muscle, position) in _nonHighlightedMuscles) {
      if (!muscle.isForView(_view)) continue;
      build.addChild(
        getMuscleHelper(muscle).toSvgElement(
          position,
          fillColor: _defFillColor,
          fillOpacity: _defFillOpacity,
          strokeColor: _strokeColor,
          strokeWidth: _strokeWidth,
          idSuffix: _view.name,
        ),
      );
    }
    for (final highlight in _highlights.values) {
      if (!highlight.muscle.isForView(_view)) continue;
      build.addChild(
        MuscleHelper.fromHighlight(
          highlight,
          _svgPathReader,
          strokeColor: _strokeColor,
          strokeWidth: _strokeWidth,
          idSuffix: _view.name,
        ),
      );
    }
    if (null != _hairColor) {
      final hairs = _svgPathReader.getPathDs('hair_outline');
      if (hairs.isNotEmpty) {
        build.addChild(
          SvgPath(id: 'hair_outline_${_view.name}', d: hairs.first)
            ..stroke(_strokeColor, width: _strokeWidth)
            ..fill(_hairColor, opacity: 0.5),
        );
      }
    }
    return [build];
  }
}

//region Male
class _MaleSkeletalMuscles extends _SkeletalMuscles {
  _MaleSkeletalMuscles({required super.view})
    : super(svgPathReader: SvgPathReader.male(view));

  @override
  final Color? _hairColor = null;

  static _MaleSkeletalMuscles front() =>
      _MaleSkeletalMuscles(view: BodyView.front);

  static _MaleSkeletalMuscles back() =>
      _MaleSkeletalMuscles(view: BodyView.back);
}

//endregion

//region Female
class _FemaleSkeletalMuscles extends _SkeletalMuscles {
  _FemaleSkeletalMuscles({required super.view, Color? hairColor})
    : _hairColor = hairColor??Colors.grey,
      super(svgPathReader: SvgPathReader.female(view));

  @override
  final Color _hairColor;

  static _FemaleSkeletalMuscles front({Color? hairColor}) =>
      _FemaleSkeletalMuscles(view: BodyView.front, hairColor: hairColor);

  static _FemaleSkeletalMuscles back({Color? hairColor}) =>
      _FemaleSkeletalMuscles(view: BodyView.back, hairColor: hairColor);
}

//endregion

abstract class _Body with BuildsSvgWriter implements IMuscleHighlights {
  final List<_SkeletalMuscles> _skeletalMuscles;
  static const double _margin = 0.5;

  @override
  late final Dim dimension = Dim(
    (_margin * (_skeletalMuscles.length - 1)) +
        _skeletalMuscles.fold(0, (val, sk) => val + sk.dimension.width),
    _skeletalMuscles.map((s) => s.dimension.height).reduce(math.max),
  );

  _Body._(this._skeletalMuscles);

  @override
  void highlight(
    Muscle muscle, {
    MusclePosition? position,
    Color? color,
    double? opacity,
  }) {
    for (final skeletal in _skeletalMuscles) {
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
    for (final entry in _skeletalMuscles.asMap().entries) {
      final group = SvgGroup(id: 'skeletal_${entry.key}');
      if (0 != x) {
        group.addAttribute('transform', 'translate($x,0)');
      }
      group.addChildren(entry.value._getRootBuilds());
      groups.add(group);
      x += entry.value.dimension.width + _margin;
    }
    return groups;
  }
}

class Male extends _Body {
  Male._(super.skeletalMuscles) : super._();

  static Male front() => Male._([_MaleSkeletalMuscles.front()]);

  static Male back() => Male._([_MaleSkeletalMuscles.back()]);

  static Male frontBack() =>
      Male._([_MaleSkeletalMuscles.front(), _MaleSkeletalMuscles.back()]);

  static Male backFront() =>
      Male._([_MaleSkeletalMuscles.back(), _MaleSkeletalMuscles.front()]);

  static Male both() => frontBack();
}

class Female extends _Body {
  Female._(super.skeletalMuscles) : super._();

  static Female front() => Female._([_FemaleSkeletalMuscles.front()]);

  static Female back() => Female._([_FemaleSkeletalMuscles.back()]);

  static Female frontBack() =>
      Female._([_FemaleSkeletalMuscles.front(), _FemaleSkeletalMuscles.back()]);

  static Female backFront() =>
      Female._([_FemaleSkeletalMuscles.back(), _FemaleSkeletalMuscles.front()]);

  static Female both() => frontBack();
}
