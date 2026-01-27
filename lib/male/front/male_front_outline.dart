part of 'front_library.dart';

class MaleFrontOutline with HasPaint, RequiresViewBox {
  MaleFrontOutline(Size size) {
    setSize(size);
  }

  List<Path> get paths =>
      getMusclePaths(outlineFront, size: size, svgSize: FRONT_SVG_SIZE);

  PathsPainter painter() => PathsPainter.fromPaths(
    paths,
    strokePaint: strokePaint,
    fillPaint: fillPaint,
  );
}
