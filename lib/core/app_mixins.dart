import 'dart:ui';

import 'package:flutter_muscle_anatomy/core/muscle.dart';
import 'package:flutter_muscle_anatomy/core/muscle_painter.dart';

mixin HasPaint {
  Paint? strokePaint;
  Paint? fillPaint;
}

mixin RequiresViewBox {
  late Size _size;

  Size get size => _size;

  void setSize(Size s) => _size = s;
}
