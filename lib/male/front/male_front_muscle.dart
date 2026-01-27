part of 'front_library.dart';

abstract class MaleFrontMuscle
    with HasPaint, HasMuscle, HasSymmetricalMuscles, RequiresViewBox {

  @override
  FrontMuscle get muscle;

  @override
  List<Path> get leftMusclePaths =>
      muscle.getPaths(size: size, position: MusclePosition.left);

  @override
  List<Path> get rightMusclePaths =>
      muscle.getPaths(size: size, position: MusclePosition.right);

  MaleFrontMuscle(Size size, {Paint? fillPaint, Paint? strokePaint}) {
    setSize(size);
    this.fillPaint = fillPaint;
    this.strokePaint = strokePaint;
  }
}
