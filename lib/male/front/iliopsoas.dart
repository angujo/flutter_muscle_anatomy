part of 'front_library.dart';

class Iliopsoas extends FrontMuscle {
  Iliopsoas(super.size);

  @override
    get _left => leftIliopsoas;

  @override
  get _right => rightIliopsoas;
}