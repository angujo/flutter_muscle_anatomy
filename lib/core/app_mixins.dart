part of 'core.dart';

mixin HasPaint {
  Paint? strokePaint;
  Paint? fillPaint;
}

mixin RequiresViewBox {
  late Size _size;

  Size get size => _size;

  void setSize(Size s) => _size = s;
}
