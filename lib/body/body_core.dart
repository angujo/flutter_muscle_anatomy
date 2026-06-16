part of 'body.dart';

/// Represents the skeletal muscles for a specific [BodyView].
///
/// It handles SVG path reading and provides mechanisms for building SVG elements
/// for both highlighted and non-highlighted muscles.
class _SkeletalMuscles
    with _StrokesFill, _MusclesHighlights, _BuildsSvgWriter {
  @override
  final BodyView _view;

  /// The reader used to extract path data from SVG assets.
  final SvgPathReader _svgPathReader;

  @override
  late Size dimension;

  /// The color of the hair, if it should be rendered.
  final Color? _hairColor;

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

  /// Creates an instance of [_SkeletalMuscles].
  _SkeletalMuscles({
    required BodyView view,
    required SvgPathReader svgPathReader,
    Color? hairColor,
  }) : _view = view,
       _svgPathReader = svgPathReader,
       _hairColor = hairColor,
       dimension = Size(svgPathReader.width, svgPathReader.height);

  /// Returns an [_SkeletalMuscles] for the male body for a specific [view].
  factory _SkeletalMuscles.male(BodyView view) =>
      _SkeletalMuscles(view: view, svgPathReader: SvgPathReader.male(view));

  /// Returns an [_SkeletalMuscles] for the female body for a specific [view].
  factory _SkeletalMuscles.female(BodyView view, {Color? hairColor}) =>
      _SkeletalMuscles(
        view: view,
        svgPathReader: SvgPathReader.female(view),
        hairColor: hairColor ?? Colors.grey,
      );

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

/// Base class for body anatomy visualization.
///
/// It aggregates one or more [_SkeletalMuscles] views (e.g., front and back)
/// and coordinates highlighting across them.
abstract class _Body with _BuildsSvgWriter implements BodyMuscleAnatomy {
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
  @override
  List<Path> get outlinePaths =>
      _skeletalMuscles.map((s) => s.outlinePath).toList();

  /// Returns a list of [Path] objects for the hair outlines of all skeletal muscle views.
  List<Path> get hairOutlinePaths =>
      _skeletalMuscles.map((s) => s.hairOutlinePath).nonNulls.toList();

  /// Private constructor for [_Body].
  _Body._(this._skeletalMuscles);

  @override
  List<Path> getAllMusclePaths() =>
      _skeletalMuscles.map((s) => s.getMusclePaths()).expand((l) => l).toList();

  @override
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
    _GenderType gender,
    Iterable<Muscle> muscles, {
    required T Function(List<_SkeletalMuscles>) constructor,
    Color? hairColor,
  }) {
    final fCounts = muscles.where((m) => m.isForView(BodyView.front)).length;
    final bCounts = muscles.where((m) => m.isForView(BodyView.back)).length;

    List<BodyView> views;
    if (0 == bCounts) {
      views = [BodyView.front];
    } else if (0 == fCounts) {
      views = [BodyView.back];
    } else if (fCounts > bCounts) {
      views = [BodyView.front, BodyView.back];
    } else {
      views = [BodyView.back, BodyView.front];
    }

    final b = constructor(_createSkeletals(gender, views, hairColor: hairColor));
    b.highlights(muscles);
    return b;
  }

  /// Helper to create a list of [_SkeletalMuscles] for the given [views].
  static List<_SkeletalMuscles> _createSkeletals(
    _GenderType gender,
    List<BodyView> views, {
    Color? hairColor,
  }) {
    return views
        .map(
          (v) => gender == _GenderType.male
              ? _SkeletalMuscles.male(v)
              : _SkeletalMuscles.female(v, hairColor: hairColor),
        )
        .toList();
  }
}

/// Interface for body anatomy visualization.
abstract class BodyMuscleAnatomy implements _IMuscleHighlights {
  /// The physical dimensions (width and height) of the SVG view box for this anatomy representation.
  Size get dimension;

  /// Returns a list of [Path] objects for the outlines of the body views.
  List<Path> get outlinePaths;

  /// Returns a list of [Path] objects for all available muscles in the body views.
  List<Path> getAllMusclePaths();

  /// Returns a list of [Path] objects for a specific [muscle] at a given [position].
  List<Path> getMusclePaths(Muscle muscle, {required MusclePosition position});

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

/// A factory for creating [BodyMuscleAnatomy] instances for a specific gender.
class BodyAnatomy {
  /// The gender type this factory produces.
  final _GenderType _genderType;

  /// Creates a [BodyAnatomy] factory for the given [gender].
  ///
  /// [gender] can be a [String] or any object whose `toString()` returns a valid gender string.
  BodyAnatomy(dynamic gender)
    : _genderType = _GenderType.fromName(
        gender is String ? gender : gender.toString(),
      );

  /// Returns a [BodyMuscleAnatomy] with only the front view.
  BodyMuscleAnatomy front() =>
      _genderType == _GenderType.male ? Male.front() : Female.front();

  /// Returns a [BodyMuscleAnatomy] with only the back view.
  BodyMuscleAnatomy back() =>
      _genderType == _GenderType.male ? Male.back() : Female.back();

  /// Returns a [BodyMuscleAnatomy] with both front and back views.
  BodyMuscleAnatomy frontBack() =>
      _genderType == _GenderType.male ? Male.frontBack() : Female.frontBack();

  /// Returns a [BodyMuscleAnatomy] with both back and front views.
  BodyMuscleAnatomy backFront() =>
      _genderType == _GenderType.male ? Male.backFront() : Female.backFront();

  /// Returns a [BodyMuscleAnatomy] with both front and back views (alias for [frontBack]).
  BodyMuscleAnatomy both() =>
      _genderType == _GenderType.male ? Male.both() : Female.both();

  /// Returns a [BodyMuscleAnatomy] with views that best represent the provided [muscles].
  BodyMuscleAnatomy byMuscles(Iterable<Muscle> muscles) =>
      _genderType == _GenderType.male
          ? Male.byMuscles(muscles)
          : Female.byMuscles(muscles);
}

/// Represents the male body anatomy.
class Male extends _Body {
  /// Private constructor for [Male].
  Male._(super.skeletalMuscles) : super._();

  /// Returns a [Male] instance with only the front view.
  static Male front() =>
      Male._(_Body._createSkeletals(_GenderType.male, [BodyView.front]));

  /// Returns a [Male] instance with only the back view.
  static Male back() =>
      Male._(_Body._createSkeletals(_GenderType.male, [BodyView.back]));

  /// Returns a [Male] instance with both front and back views.
  static Male frontBack() => Male._(
    _Body._createSkeletals(_GenderType.male, [BodyView.front, BodyView.back]),
  );

  /// Returns a [Male] instance with both back and front views.
  static Male backFront() => Male._(
    _Body._createSkeletals(_GenderType.male, [BodyView.back, BodyView.front]),
  );

  /// Returns a [Male] instance with both front and back views (alias for [frontBack]).
  static Male both() => frontBack();

  /// Creates a [Male] instance showing the views that best represent the provided [muscles].
  static Male byMuscles(Iterable<Muscle> muscles) =>
      _Body._byMuscles(_GenderType.male, muscles, constructor: Male._);
}

/// Represents the female body anatomy.
class Female extends _Body {
  /// Private constructor for [Female].
  Female._(super.skeletalMuscles) : super._();

  /// Returns a [Female] instance with only the front view.
  ///
  /// [hairColor] can optionally be specified.
  static Female front({Color? hairColor}) => Female._(
    _Body._createSkeletals(
      _GenderType.female,
      [BodyView.front],
      hairColor: hairColor,
    ),
  );

  /// Returns a [Female] instance with only the back view.
  ///
  /// [hairColor] can optionally be specified.
  static Female back({Color? hairColor}) => Female._(
    _Body._createSkeletals(
      _GenderType.female,
      [BodyView.back],
      hairColor: hairColor,
    ),
  );

  /// Returns a [Female] instance with both front and back views.
  ///
  /// [hairColor] can optionally be specified.
  static Female frontBack({Color? hairColor}) => Female._(
    _Body._createSkeletals(
      _GenderType.female,
      [BodyView.front, BodyView.back],
      hairColor: hairColor,
    ),
  );

  /// Returns a [Female] instance with both back and front views.
  ///
  /// [hairColor] can optionally be specified.
  static Female backFront({Color? hairColor}) => Female._(
    _Body._createSkeletals(
      _GenderType.female,
      [BodyView.back, BodyView.front],
      hairColor: hairColor,
    ),
  );

  /// Returns a [Female] instance with both front and back views (alias for [frontBack]).
  static Female both({Color? hairColor}) => frontBack(hairColor: hairColor);

  /// Creates a [Female] instance showing the views that best represent the provided [muscles].
  static Female byMuscles(Iterable<Muscle> muscles, {Color? hairColor}) =>
      _Body._byMuscles(
        _GenderType.female,
        muscles,
        constructor: Female._,
        hairColor: hairColor,
      );
}
