part of 'front_library.dart';

class RectusAbdominis extends FrontMuscle {
  RectusAbdominis(super.size);

  @override
    get _left => leftRectusAbdominis;

  @override
  get _right => rightRectusAbdominis;
}
