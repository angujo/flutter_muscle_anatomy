part of 'front_library.dart';

abstract class FrontMuscle {
  final Size _size;
  final Paint? strokePaint;
  final Paint? fillPaint;

  Size get _svgSize => const Size(FRONT_SVG_WIDTH, FRONT_SVG_HEIGHT);

  dynamic get _left;

  dynamic get _right;

  List<Path> get leftPaths => getMusclePaths(_left, size: _size, svgSize: _svgSize);

  List<Path> get rightPaths => getMusclePaths(_right, size: _size, svgSize: _svgSize);

  List<Path> get paths => [...leftPaths, ...rightPaths];

  FrontMuscle(this._size, {this.strokePaint, this.fillPaint});
}
