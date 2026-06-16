part of 'body.dart';

/// Represents the gender types supported by the body anatomy model.
enum _GenderType {
  /// Male body type.
  male,

  /// Female body type.
  female;

  /// Converts a [gender] string into a [_GenderType].
  ///
  /// Matches the first character of the string (case-insensitive):
  /// - 'm' -> [male]
  /// - 'f' -> [female]
  ///
  /// It also supports matching against localized names.
  ///
  /// Throws an [ArgumentError] if [gender] is empty or does not start with 'm' or 'f'.
  static _GenderType fromName(String gender) {
    String g = gender.trim().toLowerCase();
    if (g.isEmpty) {
      throw ArgumentError(
        'errors.invalid_gender'.tr(
          namedArgs: {'gender': gender, 'expected': names().join(', ')},
        ),
      );
    }

    for (final type in values) {
      if (type.name.toLowerCase() == g ||
          type.name.substring(0, 1).toLowerCase() == g ||
          type.name.localizedGender.toLowerCase() == g) {
        return type;
      }
    }

    return switch (g.substring(0, 1)) {
      'm' => male,
      'f' => female,
      _ => throw ArgumentError(
        'errors.invalid_gender'.tr(
          namedArgs: {'gender': gender, 'expected': names().join(', ')},
        ),
      ),
    };
  }

  /// Returns a list of short and full names for all available genders, including localized ones.
  static List<String> names() => values
      .expand((e) => [
            e.name.substring(0, 1),
            e.name,
            e.name.localizedGender,
          ])
      .toSet()
      .toList();
}

/// Interface for classes that support highlighting muscles on the body.
abstract class _IMuscleHighlights {
  /// Highlights a specific [muscle] in the view.
  ///
  /// [position] specifies which side to highlight (defaults to [MusclePosition.both]).
  /// [color] and [opacity] can override the default highlight styling.
  void highlight(
    Muscle muscle, {
    MusclePosition? position,
    Color? color,
    double? opacity,
  });

  /// Highlights a collection of [muscles] in the view.
  ///
  /// [position] specifies which side to highlight (defaults to [MusclePosition.both]).
  /// [color] and [opacity] can override the default highlight styling.
  void highlights(
    Iterable<Muscle> muscles, {
    MusclePosition? position,
    Color? color,
    double? opacity,
  });
}

/// A mixin that provides functionality for building an [SvgFileWriter] and
/// managing the SVG generation process.
mixin _BuildsSvgWriter {
  /// The writer used to generate SVG content.
  late SvgFileWriter _svgFileWriter;

  /// Tracks whether the SVG has already been built.
  bool _built = false;

  /// Returns the root [SvgGroup]s that compose the body's SVG structure.
  ///
  /// This must be implemented by the class using the mixin.
  List<SvgGroup> _getRootBuilds();

  /// The physical dimensions (width and height) of the SVG view box.
  Size get dimension;

  /// Forces a rebuild of the SVG content by resetting the [_built] flag and calling [build].
  void rebuild() {
    _built = false;
    build();
  }

  /// Returns the string representation of the generated SVG.
  ///
  /// Automatically calls [build] if it hasn't been called yet.
  @override
  String toString() {
    build();
    return _svgFileWriter.toString();
  }

  /// Builds the SVG document if it hasn't been built yet.
  ///
  /// Initializes the [_svgFileWriter] with the current [dimension],
  /// adds the root elements from [_getRootBuilds], and finalizes the build.
  void build() {
    if (_built) return;
    _svgFileWriter = SvgFileWriter(dimension);
    final build = _getRootBuilds();
    _svgFileWriter.addElements(build);
    _svgFileWriter.build();
    _built = true;
  }

  /// Scales the given [size] to either [fill] or fit the current [dimension].
  ///
  /// If [fill] is true, the size is scaled using the maximum multiplier between
  /// width and height ratios. Otherwise, it uses the minimum multiplier.
  Size scaledSize(Size size, {bool fill = false}) {
    final mW = size.width / dimension.width;
    final mH = size.height / dimension.height;
    final scale = fill ? math.max(mW, mH) : math.min(mW, mH);
    return Size(dimension.width * scale, dimension.height * scale);
  }
}

/// A mixin that manages styling properties for strokes and default fills
/// of the body parts.
mixin _StrokesFill {
  /// The color of the strokes for body part outlines.
  Color _strokeColor = Colors.black;

  /// The thickness of the strokes for body part outlines.
  double _strokeWidth = 0.2;

  /// The default fill color for body parts when not highlighted.
  Color _defFillColor = Colors.transparent;

  /// The default fill opacity for body parts when not highlighted.
  double _defFillOpacity = 0;

  /// Sets the default stroke [color] and [width].
  void setStroke({required Color color, required double width}) {
    _strokeColor = color;
    _strokeWidth = width;
  }

  /// Sets the default fill [color] and [opacity].
  void setFill({required Color color, required double opacity}) {
    _defFillColor = color;
    _defFillOpacity = opacity;
  }
}

/// A mixin that implements the [_IMuscleHighlights] interface to track
/// and manage muscle highlighting state.
mixin _MusclesHighlights {
  /// The specific [BodyView] (e.g., front, back) this highlighting logic is applied to.
  BodyView get _view;

  /// The default color used for highlighting muscles.
  Color _defHighlightColor = Colors.red;

  /// The default opacity used for highlighting muscles.
  double _defHighlightOpacity = 0.5;

  /// Internal storage for tracked highlights, keyed by muscle and its position.
  final Map<(Muscle, MusclePosition), MuscleHighlight<Muscle>> _highlights = {};

  /// Returns a list of keys representing currently highlighted muscles and their positions.
  List<(Muscle, MusclePosition)> get _highlightedMuscles =>
      _highlights.keys.toList();

  /// Returns a list of muscles and positions that are currently NOT highlighted for the current [_view].
  List<(Muscle, MusclePosition)> get _nonHighlightedMuscles {
    final Set<(Muscle, MusclePosition)> highlighted = Set.from(
      _highlightedMuscles,
    );
    return Muscle.forView(_view)
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

  /// Sets the default highlight [color] and [opacity] to be used when not explicitly specified in [highlight].
  void setDefaultHighlight({required Color color, required double opacity}) {
    _defHighlightColor = color;
    _defHighlightOpacity = opacity;
  }

  /// Highlights a [muscle] at a specific [position].
  ///
  /// If [position] is [MusclePosition.both], it removes any individual left/right highlights for that muscle.
  /// If [position] is left or right and a "both" highlight exists, it replaces the "both" highlight with the other side's highlight.
  void highlight(
    Muscle muscle, {
    MusclePosition? position,
    Color? color,
    double? opacity,
  }) {
    if (!muscle.isForView(_view)) return;
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

  /// Highlights multiple [muscles] with an optional [position], [color], and [opacity].
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
}
