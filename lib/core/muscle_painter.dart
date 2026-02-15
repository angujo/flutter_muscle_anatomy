part of 'core.dart';
class MuscleHighlight<T extends Muscle> {
  final T muscle;
  final MusclePosition position;
  final Color color;
  final double opacity;

  MuscleHighlight({
    required this.position,
    required this.color,
    required this.opacity,
    required this.muscle,
  });

  MuscleHighlight<T> copyWith({
    T? muscle,
    MusclePosition? position,
    Color? color,
    double? opacity,
  }) {
    return MuscleHighlight(
      muscle: muscle ?? this.muscle,
      position: position ?? this.position,
      color: color ?? this.color,
      opacity: opacity ?? this.opacity,
    );
  }

}

class PathPainter extends CustomPainter {
  final Path path;
  final Paint strokePaint;
  final Paint? fillPaint;
  final Size svgSize;

  PathPainter({
    super.repaint,
    required this.svgSize,
    required this.path,
    required this.strokePaint,
    this.fillPaint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / svgSize.width;
    final scaleY = size.height / svgSize.height;

    canvas.save();
    canvas.scale(scaleX, scaleY);

    canvas.drawPath(path, strokePaint);
    if (null != fillPaint) canvas.drawPath(path, fillPaint!);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant PathPainter oldDelegate) {
    return false;
  }
}
