part of 'core.dart';

final class Dim {
  final double width;
  final double height;

  const Dim(this.width, this.height);
}


mixin HasPaint {
  Paint? strokePaint;
  Paint? fillPaint;
}

mixin RequiresViewBox {
  late Size _size;

  Size get size => _size;

  void setSize(Size s) => _size = s;
}
