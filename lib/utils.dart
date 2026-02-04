import 'dart:ui';
import 'dart:math' as math;
import 'package:vector_math/vector_math_64.dart';
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

Path svgPathToFlutterPath({
  required String svgPath,
  required Size size,
  required Size svgSize,
}) {
  final p = parseSvgPathData(svgPath);
  final path = Path();

  double x = 0, y = 0;
  double startX = 0, startY = 0;
  double lastCx = 0, lastCy = 0;
  double lastQx = 0, lastQy = 0;

  final tokens = RegExp(
    r'[AaCcHhLlMmQqSsTtVvZz]|-?\d*\.?\d+(?:e[-+]?\d+)?',
  ).allMatches(svgPath).map((m) => m.group(0)!).toList();

  int i = 0;
  String cmd = '';

  double n() => double.parse(tokens[i++]);

  while (i < tokens.length) {
    if (RegExp(r'[A-Za-z]').hasMatch(tokens[i])) {
      cmd = tokens[i++];
    }

    switch (cmd) {
      case 'M':
        x = n();
        y = n();
        path.moveTo(x, y);
        startX = x;
        startY = y;
        break;

      case 'm':
        x += n();
        y += n();
        path.moveTo(x, y);
        startX = x;
        startY = y;
        break;

      case 'L':
        x = n();
        y = n();
        path.lineTo(x, y);
        break;

      case 'l':
        x += n();
        y += n();
        path.lineTo(x, y);
        break;

      case 'H':
        x = n();
        path.lineTo(x, y);
        break;

      case 'h':
        x += n();
        path.lineTo(x, y);
        break;

      case 'V':
        y = n();
        path.lineTo(x, y);
        break;

      case 'v':
        y += n();
        path.lineTo(x, y);
        break;

      case 'C':
        {
          final x1 = n(), y1 = n();
          final x2 = n(), y2 = n();
          x = n();
          y = n();
          path.cubicTo(x1, y1, x2, y2, x, y);
          lastCx = x2;
          lastCy = y2;
          break;
        }

      case 'c':
        {
          final x1 = x + n(), y1 = y + n();
          final x2 = x + n(), y2 = y + n();
          x += n();
          y += n();
          path.cubicTo(x1, y1, x2, y2, x, y);
          lastCx = x2;
          lastCy = y2;
          break;
        }

      case 'S':
        {
          final x1 = 2 * x - lastCx;
          final y1 = 2 * y - lastCy;
          final x2 = n(), y2 = n();
          x = n();
          y = n();
          path.cubicTo(x1, y1, x2, y2, x, y);
          lastCx = x2;
          lastCy = y2;
          break;
        }

      case 's':
        {
          final x1 = 2 * x - lastCx;
          final y1 = 2 * y - lastCy;
          final x2 = x + n(), y2 = y + n();
          x += n();
          y += n();
          path.cubicTo(x1, y1, x2, y2, x, y);
          lastCx = x2;
          lastCy = y2;
          break;
        }

      case 'Q':
        {
          final cx = n(), cy = n();
          x = n();
          y = n();
          path.quadraticBezierTo(cx, cy, x, y);
          lastQx = cx;
          lastQy = cy;
          break;
        }

      case 'q':
        {
          final cx = x + n(), cy = y + n();
          x += n();
          y += n();
          path.quadraticBezierTo(cx, cy, x, y);
          lastQx = cx;
          lastQy = cy;
          break;
        }

      case 'T':
        {
          final cx = 2 * x - lastQx;
          final cy = 2 * y - lastQy;
          x = n();
          y = n();
          path.quadraticBezierTo(cx, cy, x, y);
          lastQx = cx;
          lastQy = cy;
          break;
        }

      case 't':
        {
          final cx = 2 * x - lastQx;
          final cy = 2 * y - lastQy;
          x += n();
          y += n();
          path.quadraticBezierTo(cx, cy, x, y);
          lastQx = cx;
          lastQy = cy;
          break;
        }

      case 'A':
      case 'a':
        {
          final rx = n(), ry = n();
          final rotation = n() * math.pi / 180;
          final largeArc = n() != 0;
          final sweep = n() != 0;
          final endX = cmd == 'a' ? x + n() : n();
          final endY = cmd == 'a' ? y + n() : n();

          path.arcToPoint(
            Offset(endX, endY),
            radius: Radius.elliptical(rx, ry),
            rotation: rotation,
            largeArc: largeArc,
            clockwise: sweep,
          );

          x = endX;
          y = endY;
          break;
        }

      case 'Z':
      case 'z':
        path.close();
        x = startX;
        y = startY;
        break;
    }
  }

  // --- SVG preserveAspectRatio="xMidYMid meet" ---
  final scale = math.min(
    size.width / svgSize.width,
    size.height / svgSize.height,
  );

  final dx = (size.width - svgSize.width * scale) / 2;
  final dy = (size.height - svgSize.height * scale) / 2;

  final matrix = Matrix4.identity()
    ..translate(dx, dy)
    ..scale(scale, scale);

  return path.transform(matrix.storage);
}
