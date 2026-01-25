part of 'front_library.dart';

class Gracilis extends FrontMuscle {
  Gracilis(super.size);

  @override
    get _left => leftGracilis;

  @override
  get _right => rightGracilis;
}