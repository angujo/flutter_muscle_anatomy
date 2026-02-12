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

String translatePath(String pathData, double offsetX) {
  final numberRegex =
  RegExp(r'[-+]?(?:\d*\.\d+|\d+)(?:[eE][-+]?\d+)?');

  final tokens = <String>[];
  final buffer = StringBuffer();

  double currentX = 0;
  double currentY = 0;
  double startX = 0;
  double startY = 0;

  int i = 0;

  while (i < pathData.length) {
    final char = pathData[i];

    if (RegExp(r'[A-Za-z]').hasMatch(char)) {
      tokens.add(char);
      i++;
      continue;
    }

    final match = numberRegex.matchAsPrefix(pathData.substring(i));
    if (match != null) {
      tokens.add(match.group(0)!);
      i += match.group(0)!.length;
      continue;
    }

    tokens.add(char);
    i++;
  }

  String? cmd;
  int paramIndex = 0;

  for (final token in tokens) {
    if (RegExp(r'[A-Za-z]').hasMatch(token)) {
      cmd = token;
      paramIndex = 0;
      buffer.write(token);
      continue;
    }

    if (cmd == null || double.tryParse(token) == null) {
      buffer.write(token);
      continue;
    }

    double value = double.parse(token);
    final upper = cmd.toUpperCase();
    final isRelative = cmd == cmd.toLowerCase();

    bool isX = false;

    if (upper == 'H') {
      isX = true;
    } else if (upper == 'V') isX = false;
    else if (upper == 'A') isX = paramIndex % 7 == 5;
    else isX = paramIndex % 2 == 0;

    if (isRelative) {
      if (isX) {
        currentX += value;
      } else {
        currentY += value;
      }
    } else {
      if (isX) {
        currentX = value;
      } else {
        currentY = value;
      }
    }

    double outputValue = value;

    if (!isRelative && isX) {
      outputValue = value + offsetX;
    }

    buffer.write(outputValue.toString());
    paramIndex++;
  }

  return buffer.toString();
}


String translatePathData(String pathData, double offsetX) {
  final commandRegex = RegExp(
    r'([MmLlHhVvCcSsQqTtAaZz])\s*([^MmLlHhVvCcSsQqTtAaZz]*)',
  );

  return pathData.replaceAllMapped(commandRegex, (match) {
    final cmd = match.group(1)!;
    final params = match.group(2)!;

    // Don't process close path commands
    if (cmd.toUpperCase() == 'Z') {
      return match.group(0)!;
    }

    // Parse numbers while preserving original text between them
    final numberRegex = RegExp(r'[-+]?(?:\d*\.\d+|\d+)(?:[eE][-+]?\d+)?');
    int paramIndex = 0;
    final isRelative = cmd == cmd.toLowerCase();
    final upperCmd = cmd.toUpperCase();

    return cmd +
        params.replaceAllMapped(numberRegex, (numMatch) {
          final numStr = numMatch.group(0)!;
          final numValue = double.parse(numStr);
          double result = numValue;

          // Determine if this is an x coordinate
          bool isXCoord = false;
          if (upperCmd != 'V') {
            if (upperCmd == 'H') {
              isXCoord = true; // H only has x coordinates
            } else if (upperCmd == 'A') {
              // Arc: rx, ry, rotation, large-arc, sweep, x, y
              // x is at index 5. Multiple arcs can be in one command, so we use modulo 7.
              isXCoord = paramIndex % 7 == 5;
            } else {
              // For M, L, C, S, Q, T: x coordinates are at even indices (0, 2, 4...)
              isXCoord = paramIndex % 2 == 0;
            }
          }

          // Only translate absolute coordinates
          if (isXCoord && !isRelative) {
            result = numValue + offsetX;
          }

          paramIndex++;
          return _formatNumber(result, original: numStr);
        });
  });
}

String _formatNumber(double value, {required String original}) {
  // Try to preserve original formatting when possible
  if (value == value.toInt().toDouble()) {
    // Integer value
    final hasDecimal = original.contains('.');
    return hasDecimal ? value.toStringAsFixed(1) : value.toInt().toString();
  }

  // Check if original had specific decimal places
  if (original.contains('.')) {
    final parts = original.split('.');
    if (parts.length > 1) {
      final decimalPart = parts[1];
      // Handle simple decimals (avoid breaking on scientific notation if possible)
      if (!decimalPart.contains('e') && !decimalPart.contains('E')) {
        return value.toStringAsFixed(decimalPart.length);
      }
    }
  }

  // Default formatting
  return value.toString();
}
