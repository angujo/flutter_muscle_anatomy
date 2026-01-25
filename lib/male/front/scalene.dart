part of 'front_library.dart';

class Scalene extends FrontMuscle {
  Scalene(super.size);

  @override
    get _left => leftScalene;

  @override
  get _right => rightScalene;
}
