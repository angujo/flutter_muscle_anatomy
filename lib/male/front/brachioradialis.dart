part of 'front_library.dart';

class Brachioradialis extends FrontMuscle {
  Brachioradialis(super.size);

  @override
  get _left => leftBrachioradialis;

  @override
  get _right => rightBrachioradialis;
}
