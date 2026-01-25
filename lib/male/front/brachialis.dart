part of 'front_library.dart';

class Brachialis extends FrontMuscle {
  Brachialis(super.size);

  @override
  get _left => leftBrachialis;

  @override
  get _right => rightBrachialis;
}
