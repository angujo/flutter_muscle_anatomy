part of 'front_library.dart';

class Deltoid extends FrontMuscle {
  Deltoid(super.size);

  @override
    get _left => leftDeltoid;

  @override
  get _right => rightDeltoid;
}
