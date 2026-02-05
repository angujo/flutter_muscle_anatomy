import 'dart:ui';

import 'package:path_drawing/path_drawing.dart';

List<String> flattenSvgPath<T>(T svgPaths) {
  if (svgPaths is List) {
    return svgPaths.map((ep) => flattenSvgPath(ep)).expand((ls) => ls).toList();
  }
  if (svgPaths is String) {
    return [svgPaths];
  }
  throw UnimplementedError('Svg Path can only be a String or List<String>!');
}

List<Path> getMusclePaths<T>(
  T svgPath, {
  required Size size,
  required Size svgSize,
}) {
  final svgPaths = flattenSvgPath(svgPath);
  return svgPaths
      .map(
        (ep) => parseSvgPathData(
          ep,
        ), // svgPathToFlutterPath(svgPath: ep, size: size, svgSize: svgSize),
      )
      .toList();
}

String camelToSnake(String input) {
  return input
      .replaceAllMapped(
        RegExp(r'([a-z0-9])([A-Z])'),
        (Match m) => '${m[1]}_${m[2]}',
      )
      .toLowerCase();
}
