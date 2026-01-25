part of 'front_library.dart';

abstract class FrontMuscle extends Muscle {
  Size get _svgSize => const Size(FRONT_SVG_WIDTH, FRONT_SVG_HEIGHT);

  dynamic get _left;

  dynamic get _right;

  @override
  List<Path> get leftPaths =>
      getMusclePaths(_left, size: size, svgSize: _svgSize);

  @override
  List<Path> get rightPaths =>
      getMusclePaths(_right, size: size, svgSize: _svgSize);

  @override
  List<Path> get paths => [...leftPaths, ...rightPaths];

  FrontMuscle(super._size, {super.fillPaint, super.strokePaint});
}
