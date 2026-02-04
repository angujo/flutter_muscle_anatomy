part of 'male_front_library.dart';

class MaleFront {
  List<FrontMuscle> get muscles => FrontMuscle.values;
  final Color strokeColor;
  final double strokeWidth;
  final Color defFillColor;
  final double defFillOpacity;
  final Color defHighlightColor;
  final double defHighlightOpacity;
  final Map<(FrontMuscle, MusclePosition), MuscleHighlight<FrontMuscle>>
  _highlights = {};
  late SvgFile _svgFile;
  late SvgElement _frontSvgElement;
  bool _built = false;

  Size get svgSize => FRONT_SVG_SIZE;

  List<(FrontMuscle, MusclePosition)> get highlightedMuscles =>
      _highlights.keys.toList();

  List<(FrontMuscle, MusclePosition)> get nonHighlightedMuscles {
    final Set<(FrontMuscle, MusclePosition)> highlighted = Set.from(
      highlightedMuscles,
    );
    return muscles
        .map((m) {
      final both = (m, MusclePosition.both);
      if (highlighted.contains(both)) {
        return <(FrontMuscle, MusclePosition)>[];
      }
      final left = (m, MusclePosition.left);
      final right = (m, MusclePosition.right);
      final positions = {left, right};
      final diff = positions.difference(highlighted);
      if (diff.length == positions.length) return [both];
      return List<(FrontMuscle, MusclePosition)>.from(diff);
    })
        .expand((l) => l)
        .toList();
  }

  MaleFront({
    this.strokeColor = Colors.black,
    this.strokeWidth = 0.2,
    this.defFillColor = Colors.transparent,
    this.defFillOpacity = 0,
    this.defHighlightColor = Colors.red,
    this.defHighlightOpacity = 0.5,
    List<FrontMuscle> muscles = const [],
  }) {
    final entries = muscles
        .map(
          (m) =>
          MuscleHighlight(
            muscle: m,
            color: defHighlightColor,
            opacity: defHighlightOpacity,
            position: MusclePosition.both,
          ),
    )
        .map((mh) => MapEntry((mh.muscle, MusclePosition.both), mh));
    _highlights.addAll(Map.fromEntries(entries));
  }

  void _prepareBuild() {
    _svgFile = SvgFile(FRONT_SVG_SIZE);
    _frontSvgElement = SvgGroup(id: 'front')
      ..addStyle('display', 'inline')
      ..addAttribute('transform', 'translate(-10.159436,-6.2156523)');
    outline();
  }

  void outline() {
    final path = SvgPath(id: 'front_outline', d: outlineFront)
      ..stroke(strokeColor, width: strokeWidth);
    _frontSvgElement.addChild(path);
  }

  void rebuild() {
    _built = false;
    build();
  }

  void build() {
    if (_built) return;
    _prepareBuild();
    _built = true;

    for (var (muscle, position) in nonHighlightedMuscles) {
      _frontSvgElement.addChild(
        muscle.toSvgElement(
          position,
          fillColor: defFillColor,
          fillOpacity: defFillOpacity,
          strokeColor: strokeColor,
          strokeWidth: strokeWidth,
        ),
      );
    }
    for (final highlight in _highlights.values) {
      _frontSvgElement.addChild(
        FrontMuscle.fromHighlight(
          highlight,
          strokeColor: strokeColor,
          strokeWidth: strokeWidth,
        ),
      );
    }

    _svgFile.addElement(_frontSvgElement);
    _svgFile.build();
  }

  @override
  String toString() {
    build();
    return _svgFile.toString();
  }

  void highlight(FrontMuscle muscle, {
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
        color: color ?? defHighlightColor,
        opacity: opacity ?? defHighlightOpacity,
        position: position ?? MusclePosition.both,
      );
    });
  }

  void highlights(Iterable<FrontMuscle> muscles, {
    MusclePosition? position,
    Color? color,
    double? opacity,
  }) {
    for (final muscle in muscles) {
      highlight(muscle, position: position, color: color, opacity: opacity);
    }
  }

  MoldFillPainter moldFillPainter(Color color, double level) {
    return MoldFillPainter(
      outlinePath: getOutlinePath(),
      fillLevel: level,
      fillColor: color,
    );
  }

  Path getOutlinePath() {
    return parseSvgPathData(outlineFront);
  }

  PathPainter outlinePainter({required Paint stroke, Paint? fill}) {
    return PathPainter(
      path: getOutlinePath(),
      svgSize: FRONT_SVG_SIZE,
      strokePaint: stroke,
      fillPaint: fill,
    );
  }

  Size scaledSize(Size size, {bool fill = false}) {
    final mW = size.width / svgSize.width;
    final mH = size.height / svgSize.height;
    final scale = fill ? math.max(mW, mH) : math.min(mW, mH);
    return Size(svgSize.width * scale, svgSize.height * scale);
  }
}
