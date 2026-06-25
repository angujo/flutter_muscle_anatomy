part of 'body.dart';

/// Represents the skeletal muscles for a specific [BodyView].
///
/// It handles SVG path reading and provides mechanisms for building SVG elements
/// for both highlighted and non-highlighted muscles.
class _SkeletalMuscles with _Decorates, _MusclesHighlights, _BuildsSvgWriter {
  @override
  final BodyView _view;

  /// The reader used to extract path data from SVG assets.
  final SvgPathReader _svgPathReader;

  @override
  late Size dimension;

  /// The color of the hair, if it should be rendered.
  final Color? _hairColor;

  /// The intrinsic dimensions of the underlying SVG.
  Size get svgDimension => Size(_svgPathReader.width, _svgPathReader.height);

  /// Returns the [Path] object for the body outline.
  Path get outlinePath => _svgPathReader.getPaths('outline').first;

  /// Returns the [Paint] object for the body outline.
  Paint get outlinePaint => _defDecoration.strokePaint();

  /// @deprecated Use [hairPath] instead.
  @Deprecated('Use hairPath instead.')
  Path? get hairOutlinePath => hairPath;

  /// Returns the [Path] for the hair outline if available.
  Path? get hairPath {
    if (null == _hairColor) return null;
    return _svgPathReader.getPaths('hair_outline').firstOrNull;
  }

  /// Returns the [MuscleDecoration] for the hair.
  MuscleDecoration get hairDecoration =>
      _defDecoration.copyWith(fillColor: _hairColor);

  /// Returns the [Paint] for the hair stroke.
  Paint get hairStrokePaint => hairDecoration.strokePaint();

  /// Returns the [Paint] for the hair fill.
  Paint get hairFillPaint => hairDecoration.fillPaint();

  /// Returns the [Path] for a specific [muscle] at a given [position].
  ///
  /// Throws [UnimplementedError] if [position] is MusclePosition.both.
  Path? getMusclePath(Muscle muscle, {required MuscleSide position}) {
    if (MuscleSide.both == position) {
      throw UnimplementedError(
        MuscleAnatomyLocalization.translator(
          'errors.muscle_position_both_not_supported',
        ),
      );
    }
    return _svgPathReader
        .getPathData(muscle, position: position)
        ?.paths
        .firstOrNull;
  }

  /// Returns a map of all muscle instances and their corresponding path data.
  Map<MuscleInstance, SVGPathData> getMuscleInstancesData() =>
      _svgPathReader.getMuscleData();

  /// Returns a list of [Path] objects for all muscles defined in Muscle.values
  /// for both left and right positions.
  List<Path> getMusclePaths() => _svgPathReader
      .getMuscleData()
      .values
      .map((sd) => sd.paths)
      .expand((l) => l)
      .nonNulls
      .toList();

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

  @override
  List<SvgElement> _getRootBuilds() {
    final build = SvgGroup(id: _view.name);
    final outline = SvgPath(
      id: 'outline_${_view.name}',
      d: _svgPathReader.getPathDs('outline').first,
    )..decorate(_defDecoration);
    (outline.toString());
    build.addChild(outline);
    for (final muscleEntry in _svgPathReader.getMuscleData().entries) {
      final deco = _defDecoration.copyFrom(
        _instanceDecoration(muscleEntry.key),
      );
      build.addChild(muscleEntry.value.toSvgElement(muscleEntry.key, deco));
    }
    if (null != _hairColor) {
      final hairs = _svgPathReader.getPathDs('hair_outline');
      if (hairs.isNotEmpty) {
        build.addChild(
          SvgPath(id: 'hair_outline_${_view.name}', d: hairs.first)
            ..decorate(hairDecoration),
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
  List<Path> get outlinePaths {
    List<Path> paths = [];
    double x = 0;
    for (final skel in _skeletalMuscles) {
      final matrix = Matrix4.translationValues(x, 0, 0);
      paths.add(skel.outlinePath.transform(matrix.storage));
      x += skel.dimension.width + _margin;
    }
    return paths;
  }

  /// Returns a list of [Path] objects for the hair outlines of all skeletal muscle views.
  @override
  List<Path> get hairOutlinePaths {
    List<Path> paths = [];
    double x = 0;
    for (final skel in _skeletalMuscles) {
      final path = skel.hairPath;
      if (path != null) {
        final matrix = Matrix4.translationValues(x, 0, 0);
        paths.add(path.transform(matrix.storage));
      }
      x += skel.dimension.width + _margin;
    }
    return paths;
  }

  /// Returns the [Paint] for the body outline.
  @override
  Paint get outlinePaint => _skeletalMuscles.first.outlinePaint;

  /// Returns the [Paint] for the hair stroke.
  @override
  Paint get hairStrokePaint => _skeletalMuscles.first.hairStrokePaint;

  /// Returns the [Paint] for the hair fill.
  @override
  Paint get hairFillPaint => _skeletalMuscles.first.hairFillPaint;

  /// Private constructor for [_Body].
  _Body._(this._skeletalMuscles);

  @override
  List<MuscleHighlight> getHighlights() {
    List<MuscleHighlight> highlights = [];
    for (final skeletal in _skeletalMuscles) {
      highlights.addAll(
        skeletal._highlights.entries.map(
          (e) => MuscleHighlight(e.key, e.value),
        ),
      );
    }
    return highlights;
  }

  @override
  List<MuscleMember> getMuscleMembers() {
    List<MuscleMember> members = [];
    double x = 0;
    for (final skel in _skeletalMuscles) {
      final matrix = Matrix4.translationValues(x, 0, 0);
      for (final entry in skel.getMuscleInstancesData().entries) {
        members.add(
          MuscleMember(
            entry.key,
            entry.value,
            skel._decoration(entry.key),
            matrix,
          ),
        );
      }
      x += skel.dimension.width + _margin;
    }
    return members;
  }

  @override
  List<Path> getAllMusclePaths() {
    List<Path> paths = [];
    double x = 0;
    for (final skel in _skeletalMuscles) {
      final matrix = Matrix4.translationValues(x, 0, 0);
      for (final path in skel.getMusclePaths()) {
        paths.add(path.transform(matrix.storage));
      }
      x += skel.dimension.width + _margin;
    }
    return paths;
  }

  @override
  List<Path> getMusclePaths(Muscle muscle, {required MuscleSide position}) {
    List<Path> paths = [];
    double x = 0;
    for (final skel in _skeletalMuscles) {
      final matrix = Matrix4.translationValues(x, 0, 0);
      final skelPaths = MuscleSide.both == position
          ? [
              skel.getMusclePath(muscle, position: MuscleSide.left),
              skel.getMusclePath(muscle, position: MuscleSide.right),
            ]
          : [skel.getMusclePath(muscle, position: position)];

      for (final p in skelPaths) {
        if (p != null) {
          paths.add(p.transform(matrix.storage));
        }
      }
      x += skel.dimension.width + _margin;
    }
    return paths;
  }

  @override
  void highlight(
    Muscle muscle, {
    MuscleSide position = MuscleSide.both,
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
    MuscleSide position = MuscleSide.both,
    Color? color,
    double? opacity,
  }) {
    for (final muscle in muscles) {
      highlight(muscle, position: position, color: color, opacity: opacity);
    }
  }

  @override
  List<SvgElement> _getRootBuilds() {
    List<SvgElement> groups = [];
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
    bool singleView = false,
  }) {
    final domView = Muscle.dominantView(muscles);

    List<BodyView> views = singleView ? [domView] : Muscle.views(muscles);

    final b = constructor(
      _createSkeletals(gender, views.nonNulls.toList(), hairColor: hairColor),
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
              ? _SkeletalMuscles.male(v)
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

  /// Returns the [Paint] for the body outline.
  Paint get outlinePaint;

  /// Returns the [Paint] for the hair stroke.
  Paint get hairStrokePaint;

  /// Returns the [Paint] for the hair fill.
  Paint get hairFillPaint;

  /// Returns a list of current muscle highlights.
  List<MuscleHighlight> getHighlights();

  /// Returns a list of all muscle members being visualized.
  List<MuscleMember> getMuscleMembers();

  /// Returns a list of [Path] objects for all available muscles in the body views.
  List<Path> getAllMusclePaths();

  /// Returns a list of [Path] objects for a specific [muscle] at a given [position].
  List<Path> getMusclePaths(Muscle muscle, {required MuscleSide position});
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
          : _GenderType.fromName(gender is String ? gender : gender.toString()),
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

  /// Returns a [MuscleAnatomy] for a specific [view].
  MuscleAnatomy byView(BodyView view) => _fromViews([view]);

  /// Returns a [MuscleAnatomy] with views that best represent the provided [muscles].
  MuscleAnatomy byMuscles(
    Iterable<Muscle> muscles, {
    bool singleView = false,
  }) => _Body._byMuscles(
    _genderType,
    muscles,
    constructor: _Body._,
    hairColor: _hairColor,
    singleView: singleView,
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
