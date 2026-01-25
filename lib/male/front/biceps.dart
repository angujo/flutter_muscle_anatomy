part of 'front_library.dart';

class Biceps extends FrontMuscle {
  Biceps(super.size);

  @override
    get _left => leftBiceps;

  @override
  get _right => rightBiceps;
}
