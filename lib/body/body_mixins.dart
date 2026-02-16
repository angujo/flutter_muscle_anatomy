part of 'body.dart';

/// Interface for classes that support highlighting muscles.
abstract class IMuscleHighlights {
  /// Highlights a specific [muscle] with optional [position], [color], and [opacity].
  void highlight(
    Muscle muscle, {
    MusclePosition? position,
    Color? color,
    double? opacity,
  });

  /// Highlights multiple [muscles] with optional [position], [color], and [opacity].
  void highlights(
    Iterable<Muscle> muscles, {
    MusclePosition? position,
    Color? color,
    double? opacity,
  });
}

/// A mixin that provides functionality for building an [SvgFileWriter].
mixin BuildsSvgWriter {
  late SvgFileWriter _svgFileWriter;
  bool _built = false;

  /// Returns the root SVG groups to be built into the SVG.
  List<SvgGroup> _getRootBuilds();

  /// The dimensions of the SVG view box.
  Size get dimension;

  /// Rebuilds the SVG content.
  void rebuild() {
    _built = false;
    build();
  }

  /// Returns the SVG string representation.
  @override
  String toString() {
    build();
    return _svgFileWriter.toString();
  }

  /// Builds the SVG document if it hasn't been built yet.
  void build() {
    if (_built) return;
    _svgFileWriter = SvgFileWriter(dimension);
    final build = _getRootBuilds();
    _svgFileWriter.addElements(build);
    _svgFileWriter.build();
    _built = true;
  }

  /// Scales the given [size] to fit or fill the [dimension].
  Size scaledSize(Size size, {bool fill = false}) {
    final mW = size.width / dimension.width;
    final mH = size.height / dimension.height;
    final scale = fill ? math.max(mW, mH) : math.min(mW, mH);
    return Size(dimension.width * scale, dimension.height * scale);
  }
}

/// A mixin that manages default stroke and fill colors/opacity.
mixin StrokesFill {
  Color _strokeColor = Colors.black;
  double _strokeWidth = 0.2;
  Color _defFillColor = Colors.transparent;
  double _defFillOpacity = 0;

  /// Sets the default stroke color and width.
  void setStroke({required Color color, required double width}) {
    _strokeColor = color;
    _strokeWidth = width;
  }

  /// Sets the default fill color and opacity.
  void setFill({required Color color, required double opacity}) {
    _defFillColor = color;
    _defFillOpacity = opacity;
  }
}

/// A mixin that implements [IMuscleHighlights] logic for tracking highlighted muscles.
mixin MusclesHighlights {

  /// The view being highlighted.
  BodyView get _view;

  Color _defHighlightColor = Colors.red;
  double _defHighlightOpacity = 0.5;

  /// Map of highlighted muscles and their positions.
  final Map<(Muscle, MusclePosition), MuscleHighlight<Muscle>> _highlights = {};

  /// List of currently highlighted muscles and their positions.
  List<(Muscle, MusclePosition)> get _highlightedMuscles =>
      _highlights.keys.toList();

  /// List of muscles and positions that are not currently highlighted.
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

  /// Sets the default highlight color and opacity.
  void setDefaultHighlight({required Color color, required double opacity}) {
    _defHighlightColor = color;
    _defHighlightOpacity = opacity;
  }

  /// Highlights a [muscle] at a specific [position].
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

  /// Highlights multiple [muscles].
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
