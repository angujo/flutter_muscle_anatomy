part of 'front_library.dart';

class Gastrocnemius extends FrontMuscle {
  Gastrocnemius(super.size);

  @override
    get _left => leftGastrocnemius;

  @override
  get _right => rightGastrocnemius;
}
