part of 'body.dart';

/// An abstract class representing the skeletal muscles for a specific [BodyView].
///
/// It handles SVG path reading and provides mechanisms for building SVG elements
/// for both highlighted and non-highlighted muscles.
abstract class _SkeletalMuscles
    with _StrokesFill, _MusclesHighlights, _BuildsSvgWriter {
  @override
  final BodyView _view;

  /// The reader used to extract path data from SVG assets.
  final SvgPathReader _svgPathReader;

  @override
  late Size dimension;

  /// The color used for hair, if any.
  Color? get _hairColor;

  /// The intrinsic dimensions of the underlying SVG.
  late final Size svgDimension = Size(
    _svgPathReader.width,
    _svgPathReader.height,
  );

  /// Returns the [Path] object for the body outline.
  Path get outlinePath =>
      parseSvgPathData(_svgPathReader.getPathDs('outline').first);

  /// Returns the [Path] for the hair outline if available.
  Path? get hairOutlinePath {
    final hairSvgPath = _svgPathReader.getPathDs('hair_outline').firstOrNull;
    if (null == _hairColor || null == hairSvgPath) return null;
    return parseSvgPathData(hairSvgPath);
  }

  /// Returns the [Path] for a specific [muscle] at a given [position].
  ///
  /// Throws [UnimplementedError] if [position] is [MusclePosition.both].
  Path? getMusclePath(Muscle muscle, {required MusclePosition position}) {
    if (MusclePosition.both == position) {
      throw UnimplementedError('MusclePosition.both is not supported');
    }
    final name = '${position.name}_${muscle.name}';
    final svgPath = _svgPathReader.getPathDs(name).firstOrNull;
    return svgPath == null ? null : parseSvgPathData(svgPath);
  }

  /// Returns a list of [Path] objects for all muscles defined in [Muscle.values]
  /// for both left and right positions.
  List<Path> getMusclePaths() {
    final positions = {MusclePosition.left, MusclePosition.right};
    return Muscle.values
        .map(
          (m) => positions
              .map((p) => _svgPathReader.getPathDs('${p.name}_${m.name}'))
              .expand((l) => l),
        )
        .expand((l) => l)
        .map((s) => parseSvgPathData(s))
        .toList();
  }

  _SkeletalMuscles({
    required BodyView view,
    required SvgPathReader svgPathReader,
  }) : _view = view,
       _svgPathReader = svgPathReader,
       dimension = Size(svgPathReader.width, svgPathReader.height);

  /// Returns a [MuscleHelper] for the specified [muscle].
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

/// Internal implementation of male skeletal muscles.
class _MaleSkeletalMuscles extends _SkeletalMuscles {
  _MaleSkeletalMuscles({required super.view})
    : super(svgPathReader: SvgPathReader.male(view));

  @override
  final Color? _hairColor = null;

  /// Creates a male front view instance.
  static _MaleSkeletalMuscles front() =>
      _MaleSkeletalMuscles(view: BodyView.front);

  /// Creates a male back view instance.
  static _MaleSkeletalMuscles back() =>
      _MaleSkeletalMuscles(view: BodyView.back);
}

//endregion

//region Female

/// Internal implementation of female skeletal muscles.
class _FemaleSkeletalMuscles extends _SkeletalMuscles {
  _FemaleSkeletalMuscles({required super.view, Color? hairColor})
    : _hairColor = hairColor ?? Colors.grey,
      super(svgPathReader: SvgPathReader.female(view));

  @override
  final Color _hairColor;

  /// Creates a female front view instance.
  static _FemaleSkeletalMuscles front({Color? hairColor}) =>
      _FemaleSkeletalMuscles(view: BodyView.front, hairColor: hairColor);

  /// Creates a female back view instance.
  static _FemaleSkeletalMuscles back({Color? hairColor}) =>
      _FemaleSkeletalMuscles(view: BodyView.back, hairColor: hairColor);
}

//endregion

/// Base class for body anatomy visualization.
///
/// It aggregates one or more [_SkeletalMuscles] views (e.g., front and back)
/// and coordinates highlighting across them.
abstract class _Body with _BuildsSvgWriter implements _IMuscleHighlights {
  /// The list of skeletal muscle views (e.g., front, back) being visualized.
  final List<_SkeletalMuscles> _skeletalMuscles;

  /// The horizontal margin between multiple views.
  static const double _margin = 0.5;

  @override
  late final Size dimension = Size(
    (_margin * (_skeletalMuscles.length - 1)) +
        _skeletalMuscles.fold(0, (val, sk) => val + sk.dimension.width),
    _skeletalMuscles.map((s) => s.dimension.height).reduce(math.max),
  );

  /// Returns a list of [Path] objects for the outlines of all skeletal muscle views.
  List<Path> get outlinePaths =>
      _skeletalMuscles.map((s) => s.outlinePath).toList();

  _Body._(this._skeletalMuscles);

  /// Returns a list of [Path] objects for all muscles in all skeletal muscle views.
  List<Path> getAllMusclePaths() =>
      _skeletalMuscles.map((s) => s.getMusclePaths()).expand((l) => l).toList();

  /// Returns a list of [Path] objects for a [muscle] at a given [position]
  /// across all skeletal muscle views where it is available.
  List<Path> getMusclePaths(Muscle muscle, {required MusclePosition position}) {
    return _skeletalMuscles
        .map(
          (s) => MusclePosition.both == position
              ? [
                  s.getMusclePath(muscle, position: MusclePosition.left),
                  s.getMusclePath(muscle, position: MusclePosition.right),
                ]
              : [s.getMusclePath(muscle, position: position)],
        )
        .expand((l) => l)
        .nonNulls
        .toList();
  }

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

  /// Internal factory helper to create a body instance based on a set of muscles.
  static T _byMuscles<T extends _Body>(
    Iterable<Muscle> muscles, {
    required T Function(int fCount, int bCount) bodyFnc,
  }) {
    final fCounts = muscles.where((m) => m.isForView(BodyView.front)).length;
    final bCounts = muscles.where((m) => m.isForView(BodyView.back)).length;
    T b = bodyFnc.call(fCounts, bCounts);
    b.highlights(muscles);
    return b;
  }
}

abstract class BodyMuscleAnatomy {
  Size get dimension;

  List<Path> get outlinePaths;

  List<Path> getAllMusclePaths();

  List<Path> getMusclePaths(Muscle muscle, {required MusclePosition position});

  void highlight(
    Muscle muscle, {
    MusclePosition? position,
    Color? color,
    double? opacity,
  });

  void highlights(
    Iterable<Muscle> muscles, {
    MusclePosition? position,
    Color? color,
    double? opacity,
  });

  /// Returns a [BodyMuscleAnatomy] instance for the specified [gender].
  ///
  /// The [gender] string can be 'm', 'male', 'f', or 'female' (case-insensitive).
  static BodyMuscleAnatomy forGender(String gender) {
    return switch (_GenderType.fromName(gender)) {
      _GenderType.male => Male.both(),
      _GenderType.female => Female.both(),
    };
  }
}

class BodyAnatomy {
  late final _GenderType _genderType;

  BodyAnatomy._(dynamic gender) {
    if (gender is String) {
      _genderType = _GenderType.fromName(gender);
    } else if (gender is _GenderType) {
      _genderType = gender;
    } else {
      throw ArgumentError('Invalid gender type: $gender');
    }
  }

  BodyMuscleAnatomy front() {
    return switch (_genderType) {
      _GenderType.male => Male.front(),
      _GenderType.female => Female.front(),
    };
  }

  BodyMuscleAnatomy back() {
    return switch (_genderType) {
      _GenderType.male => Male.back(),
      _GenderType.female => Female.back(),
    };
  }

  BodyMuscleAnatomy frontBack() {
    return switch (_genderType) {
      _GenderType.male => Male.frontBack(),
      _GenderType.female => Female.frontBack(),
    };
  }

  BodyMuscleAnatomy backFront() {
    return switch (_genderType) {
      _GenderType.male => Male.backFront(),
      _GenderType.female => Female.backFront(),
    };
  }

  BodyMuscleAnatomy both() {
    return switch (_genderType) {
      _GenderType.male => Male.both(),
      _GenderType.female => Female.both(),
    };
  }

  BodyMuscleAnatomy byMuscles(Iterable<Muscle> muscles) {
    return switch (_genderType) {
      _GenderType.male => Male.byMuscles(muscles),
      _GenderType.female => Female.byMuscles(muscles),
    };
  }
}

/// Represents the male body anatomy.
class Male extends _Body implements BodyMuscleAnatomy {
  Male._(super.skeletalMuscles) : super._();

  /// Returns a male front view.
  static Male front() => Male._([_MaleSkeletalMuscles.front()]);

  /// Returns a male back view.
  static Male back() => Male._([_MaleSkeletalMuscles.back()]);

  /// Returns both front and back views for the male body.
  static Male frontBack() =>
      Male._([_MaleSkeletalMuscles.front(), _MaleSkeletalMuscles.back()]);

  /// Returns both back and front views for the male body.
  static Male backFront() =>
      Male._([_MaleSkeletalMuscles.back(), _MaleSkeletalMuscles.front()]);

  /// Alias for [frontBack].
  static Male both() => frontBack();

  /// Creates a [Male] instance showing the views that best represent the provided [muscles].
  static Male byMuscles(Iterable<Muscle> muscles) {
    return _Body._byMuscles(
      muscles,
      bodyFnc: (f, b) {
        if (0 == b) return front();
        if (0 == f) return back();
        if (f > b) return frontBack();
        return backFront();
      },
    );
  }
}

/// Represents the female body anatomy.
class Female extends _Body implements BodyMuscleAnatomy {
  Female._(super.skeletalMuscles) : super._();

  /// Returns a list of [Path] objects for the hair outlines of all skeletal muscle views.
  List<Path> get hairOutlinePaths =>
      _skeletalMuscles.map((s) => s.hairOutlinePath).nonNulls.toList();

  /// Returns a female front view.
  static Female front() => Female._([_FemaleSkeletalMuscles.front()]);

  /// Returns a female back view.
  static Female back() => Female._([_FemaleSkeletalMuscles.back()]);

  /// Returns both front and back views for the female body.
  static Female frontBack() =>
      Female._([_FemaleSkeletalMuscles.front(), _FemaleSkeletalMuscles.back()]);

  /// Returns both back and front views for the female body.
  static Female backFront() =>
      Female._([_FemaleSkeletalMuscles.back(), _FemaleSkeletalMuscles.front()]);

  /// Alias for [frontBack].
  static Female both() => frontBack();

  /// Creates a [Female] instance showing the views that best represent the provided [muscles].
  static Female byMuscles(Iterable<Muscle> muscles) {
    return _Body._byMuscles(
      muscles,
      bodyFnc: (f, b) {
        if (0 == b) return front();
        if (0 == f) return back();
        if (f > b) return frontBack();
        return backFront();
      },
    );
  }
}
