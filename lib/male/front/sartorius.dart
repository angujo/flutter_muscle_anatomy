part of 'front_library.dart';

class Sartorius extends FrontMuscle {
  Sartorius(super.size);

  @override
    get _left => leftSartorius;

  @override
  get _right => rightSartorius;
}
