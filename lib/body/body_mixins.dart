part of 'body.dart';

abstract class IMuscleHighlights {
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
}

mixin BuildsSvgWriter {
  late SvgFileWriter _svgFileWriter;
  bool _built = false;

  List<SvgGroup> _getRootBuilds();

  Dim get dimension;

  void rebuild() {
    _built = false;
    build();
  }

  @override
  String toString() {
    build();
    return _svgFileWriter.toString();
  }

  void build() {
    if (_built) return;
    _svgFileWriter = SvgFileWriter(dimension);
    final build = _getRootBuilds();
    _svgFileWriter.addElements(build);
    _svgFileWriter.build();
    _built = true;
  }

  Dim scaledSize(Dim size, {bool fill = false}) {
    final mW = size.width / dimension.width;
    final mH = size.height / dimension.height;
    final scale = fill ? math.max(mW, mH) : math.min(mW, mH);
    return Dim(dimension.width * scale, dimension.height * scale);
  }
}

mixin StrokesFill {
  Color _strokeColor = Colors.black;
  double _strokeWidth = 0.2;
  Color _defFillColor = Colors.transparent;
  double _defFillOpacity = 0;

  void setStroke({required Color color, required double width}) {
    _strokeColor = color;
    _strokeWidth = width;
  }

  void setFill({required Color color, required double opacity}) {
    _defFillColor = color;
    _defFillOpacity = opacity;
  }
}

mixin MusclesHighlights {
  Iterable<Muscle> get _muscles;

  BodyView get _view;

  Color _defHighlightColor = Colors.red;
  double _defHighlightOpacity = 0.5;

  final Map<(Muscle, MusclePosition), MuscleHighlight<Muscle>> _highlights = {};

  List<(Muscle, MusclePosition)> get _highlightedMuscles =>
      _highlights.keys.toList();

  List<(Muscle, MusclePosition)> get _nonHighlightedMuscles {
    final Set<(Muscle, MusclePosition)> highlighted = Set.from(
      _highlightedMuscles,
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

  void setDefaultHighlight({required Color color, required double opacity}) {
    _defHighlightColor = color;
    _defHighlightOpacity = opacity;
  }

  void highlight(
    Muscle muscle, {
    MusclePosition? position,
    Color? color,
    double? opacity,
  }) {
    if (muscle.view != _view) return;
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
}
