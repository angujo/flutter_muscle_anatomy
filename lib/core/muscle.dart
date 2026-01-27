import 'dart:ui';

import 'package:flutter_muscle_anatomy/core/app_enums.dart';
import 'package:flutter_muscle_anatomy/male/front/male_front_svg_paths.dart';

abstract class SvgMuscle {
  static const Size svgSize = Size(FRONT_SVG_WIDTH, FRONT_SVG_HEIGHT);
}

abstract class Muscle {
  List<String> get rightSvgPath;

  List<String> get leftSvgPath;

  List<String> get svgPaths;

  List<Path> getPaths({
    required Size size,
    MusclePosition position = MusclePosition.both,
  });
}
