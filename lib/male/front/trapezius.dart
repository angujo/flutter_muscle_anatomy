part of 'front_library.dart';

class Trapezius extends FrontMuscle {
  Trapezius(super.size);

  @override
    get _left => leftTrapezius;

  @override
  get _right => rightTrapezius;
}
