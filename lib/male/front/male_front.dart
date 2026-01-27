part of 'front_library.dart';

class MaleFront with HasPaint, HasMuscles, RequiresViewBox {
  late final Map<FrontMuscle, MusclePaint> _muscles;

  @override
  List<FrontMuscle> get muscles => _muscles.keys.toList();

  MaleFront(Size s, {Paint? stroke, Paint? fill}) {
    setSize(s);
    strokePaint = stroke;
    fillPaint = fill;
    _muscles = {
      for (var m in FrontMuscle.values)
        m: MusclePaint(
          m,
          strokePaint: strokePaint,
          leftFill: fillPaint,
          rightFill: fillPaint,
        ),
    };
  }

  @override
  MusclesPainter painter() {
    return MusclesPainter(
      musclePaints: _muscles.values,
      strokePaint: strokePaint,
      fillPaint: fillPaint,
    );
  }

  void highlight(
    FrontMuscle muscle, {
    MusclePosition position = MusclePosition.both,
    required Paint fill,
  }) {
    if (!_muscles.containsKey(muscle)) {
      return;
    }
    final paint = _muscles[muscle]!;
    if (position == MusclePosition.both) {
      paint.leftFill = fill;
      paint.rightFill = fill;
    }
    if (position == MusclePosition.left) {
      paint.leftFill = fill;
    }
    if (position == MusclePosition.right) {
      paint.rightFill = fill;
    }
  }
}
