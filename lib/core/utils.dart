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

bool isRightSidePath(String pathData, double fullWidth) {
  final minX = fullWidth / 2;

  // Tokenize the path data
  final tokens = pathData
      .replaceAll(',', ' ')
      .split(RegExp(r'\s+|(?=[A-Za-z])'))
      .where((token) => token.isNotEmpty)
      .toList();

  double maxX = double.negativeInfinity;
  double currentX = 0;
  double startX = 0;

  for (int i = 0; i < tokens.length; i++) {
    final token = tokens[i];

    // Check if it's a command
    if (token.length == 1 && _isCommandChar(token)) {
      final command = token;
      final isRelative = command.toLowerCase() == command;
      double newX = currentX;

      switch (command.toUpperCase()) {
        case 'M': // Move to
        case 'L': // Line to
        case 'T': // Smooth quadratic Bézier
          if (i + 2 < tokens.length) {
            final x = double.tryParse(tokens[i + 1]) ?? 0;
            newX = isRelative ? currentX + x : x;
            i += 2;
          }
          break;

        case 'H': // Horizontal line
          if (i + 1 < tokens.length) {
            final x = double.tryParse(tokens[i + 1]) ?? 0;
            newX = isRelative ? currentX + x : x;
            i += 1;
          }
          break;

        case 'C': // Cubic Bézier
          if (i + 6 < tokens.length) {
            final x = double.tryParse(tokens[i + 5]) ?? 0;
            newX = isRelative ? currentX + x : x;
            i += 6;
          }
          break;

        case 'S': // Smooth cubic Bézier
        case 'Q': // Quadratic Bézier
          if (i + 4 < tokens.length) {
            final x = double.tryParse(tokens[i + 3]) ?? 0;
            newX = isRelative ? currentX + x : x;
            i += 4;
          }
          break;

        case 'A': // Arc
          if (i + 7 < tokens.length) {
            final x = double.tryParse(tokens[i + 6]) ?? 0;
            newX = isRelative ? currentX + x : x;
            i += 7;
          }
          break;

        case 'V': // Vertical line (no x change)
          if (i + 1 < tokens.length) {
            newX = currentX;
            i += 1;
          }
          break;

        case 'Z': // Close path
          newX = startX;
          break;
      }

      // Update current position
      currentX = newX;

      if (currentX >= minX) return true;

      // Update maxX
      if (currentX > maxX) {
        maxX = currentX;
      }

      // For initial move, set start position
      if (command.toUpperCase() == 'M') {
        startX = currentX;
      }
    }
  }

  return false;
}

bool _isCommandChar(String s) {
  if (s.length != 1) return false;
  final code = s.codeUnitAt(0);
  return (code >= 65 && code <= 90) || (code >= 97 && code <= 122);
}
