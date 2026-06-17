part of 'body.dart';

/// Represents the skeletal muscles for a specific [BodyView].
///
/// It handles SVG path reading and provides mechanisms for building SVG elements
/// for both highlighted and non-highlighted muscles.
class _SkeletalMuscles with _StrokesFill, _MusclesHighlights, _BuildsSvgWriter {
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
  Path get outlinePath => _svgPathReader.getPaths('outline').first;

  /// Returns the [Path] for the hair outline if available.
  Path? get hairOutlinePath {
    if (null == _hairColor) return null;
    return _svgPathReader.getPaths('hair_outline').firstOrNull;
  }

  /// Returns the [Path] for a specific [muscle] at a given [position].
  ///
  /// Throws [UnimplementedError] if [position] is MusclePosition.both.
  Path? getMusclePath(Muscle muscle, {required MusclePosition position}) {
    if (MusclePosition.both == position) {
      throw UnimplementedError(
        MuscleAnatomyLocalization.translator(
          'errors.muscle_position_both_not_supported',
        ),
      );
    }
    final name = '${position.name}_${muscle.name}';
    return _svgPathReader.getPaths(name).firstOrNull;
  }

  /// Returns a list of [Path] objects for all muscles defined in Muscle.values
  /// for both left and right positions.
  List<Path> getMusclePaths() {
    final positions = {MusclePosition.left, MusclePosition.right};
    return Muscle.values
        .map(
          (Muscle m) => positions
              .map((MusclePosition p) => getMusclePath(m, position: p))
              .whereType<Path>(),
        )
        .expand((l) => l)
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
  factory _SkeletalMuscles.male(BodyView view, {Color? hairColor}) =>
      _SkeletalMuscles(
        view: view,
        svgPathReader: SvgPathReader.male(view),
        hairColor: hairColor,
      );

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
class _Body with _BuildsSvgWriter implements MuscleAnatomy {
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
  @override
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
  static MuscleAnatomy _byMuscles(
    _GenderType gender,
    Iterable<Muscle> muscles, {
    required MuscleAnatomy Function(List<_SkeletalMuscles>) constructor,
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

    final b = constructor(
      _createSkeletals(gender, views, hairColor: hairColor),
    );
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
              ? _SkeletalMuscles.male(v, hairColor: hairColor)
              : _SkeletalMuscles.female(v, hairColor: hairColor),
        )
        .toList();
  }

  /// Internal factory to create a [MuscleAnatomy] instance from specific views.
  static MuscleAnatomy _fromViews(
    _GenderType gender,
    List<BodyView> views, {
    Color? hairColor,
  }) {
    final skeletals = _createSkeletals(gender, views, hairColor: hairColor);
    return _Body._(skeletals);
  }
}

/// Interface for body anatomy visualization.
abstract class MuscleAnatomy implements _IMuscleHighlights {
  /// The physical dimensions (width and height) of the SVG view box.
  Size get dimension;

  /// Forces a rebuild of the SVG content.
  void rebuild();

  /// Builds the SVG document if it hasn't been built yet.
  void build();

  /// Scales the given [size] to either fill or fit the current [dimension].
  Size scaledSize(Size size, {bool fill = false});

  /// Returns a list of [Path] objects for the outlines of the body views.
  List<Path> get outlinePaths;

  /// Returns a list of [Path] objects for the hair outlines of the body views.
  List<Path> get hairOutlinePaths;

  /// Returns a list of [Path] objects for all available muscles in the body views.
  List<Path> getAllMusclePaths();

  /// Returns a list of [Path] objects for a specific [muscle] at a given [position].
  List<Path> getMusclePaths(Muscle muscle, {required MusclePosition position});
}

/// A factory for creating [MuscleAnatomy] instances for a specific gender.
class Anatomy {
  /// The gender type this factory produces.
  final _GenderType _genderType;

  /// The optional hair color to apply to produced instances.
  final Color? _hairColor;

  /// Creates a [Anatomy] factory for the given [gender].
  ///
  /// [gender] can be a [String] or any object whose `toString()` returns a valid gender string.
  /// [hairColor] can optionally be specified for the resulting anatomy views.
  Anatomy(dynamic gender, {Color? hairColor})
    : _genderType = gender is _GenderType
          ? gender
          : _GenderType.fromName(
              gender is String ? gender : gender.toString(),
            ),
      _hairColor = hairColor;

  /// Returns a [MuscleAnatomy] with only the front view.
  MuscleAnatomy front() => _fromViews([BodyView.front]);

  /// Returns a [MuscleAnatomy] with only the back view.
  MuscleAnatomy back() => _fromViews([BodyView.back]);

  /// Returns a [MuscleAnatomy] with both front and back views.
  MuscleAnatomy frontBack() => _fromViews([BodyView.front, BodyView.back]);

  /// Returns a [MuscleAnatomy] with both back and front views.
  MuscleAnatomy backFront() => _fromViews([BodyView.back, BodyView.front]);

  /// Returns a [MuscleAnatomy] with both front and back views (alias for [frontBack]).
  MuscleAnatomy both() => frontBack();

  /// Returns a [MuscleAnatomy] with views that best represent the provided [muscles].
  MuscleAnatomy byMuscles(Iterable<Muscle> muscles) => _Body._byMuscles(
    _genderType,
    muscles,
    constructor: _Body._,
    hairColor: _hairColor,
  );

  /// Internal helper to create the anatomy instance from requested views.
  MuscleAnatomy _fromViews(List<BodyView> views) =>
      _Body._fromViews(_genderType, views, hairColor: _hairColor);
}

/// Represents the male body anatomy.
final class Male {
  /// Private constructor for [Male].
  Male._();

  /// Returns a [MuscleAnatomy] instance with only the front view.
  static MuscleAnatomy front() => Anatomy(_GenderType.male).front();

  /// Returns a [MuscleAnatomy] instance with only the back view.
  static MuscleAnatomy back() => Anatomy(_GenderType.male).back();

  /// Returns a [MuscleAnatomy] instance with both front and back views.
  static MuscleAnatomy frontBack() => Anatomy(_GenderType.male).frontBack();

  /// Returns a [MuscleAnatomy] instance with both back and front views.
  static MuscleAnatomy backFront() => Anatomy(_GenderType.male).backFront();

  /// Returns a [MuscleAnatomy] instance with both front and back views (alias for [frontBack]).
  static MuscleAnatomy both() => Anatomy(_GenderType.male).both();

  /// Creates a [MuscleAnatomy] instance showing the views that best represent the provided [muscles].
  static MuscleAnatomy byMuscles(Iterable<Muscle> muscles) =>
      Anatomy(_GenderType.male).byMuscles(muscles);
}

/// Represents the female body anatomy.
final class Female {
  /// Private constructor for [Female].
  Female._();

  /// Returns a [MuscleAnatomy] instance with only the front view.
  ///
  /// [hairColor] can optionally be specified.
  static MuscleAnatomy front({Color? hairColor}) =>
      Anatomy(_GenderType.female, hairColor: hairColor).front();

  /// Returns a [MuscleAnatomy] instance with only the back view.
  ///
  /// [hairColor] can optionally be specified.
  static MuscleAnatomy back({Color? hairColor}) =>
      Anatomy(_GenderType.female, hairColor: hairColor).back();

  /// Returns a [MuscleAnatomy] instance with both front and back views.
  ///
  /// [hairColor] can optionally be specified.
  static MuscleAnatomy frontBack({Color? hairColor}) =>
      Anatomy(_GenderType.female, hairColor: hairColor).frontBack();

  /// Returns a [MuscleAnatomy] instance with both back and front views.
  ///
  /// [hairColor] can optionally be specified.
  static MuscleAnatomy backFront({Color? hairColor}) =>
      Anatomy(_GenderType.female, hairColor: hairColor).backFront();

  /// Returns a [MuscleAnatomy] instance with both front and back views (alias for [frontBack]).
  static MuscleAnatomy both({Color? hairColor}) =>
      frontBack(hairColor: hairColor);

  /// Creates a [MuscleAnatomy] instance showing the views that best represent the provided [muscles].
  static MuscleAnatomy byMuscles(
    Iterable<Muscle> muscles, {
    Color? hairColor,
  }) => Anatomy(_GenderType.female, hairColor: hairColor).byMuscles(muscles);
}
