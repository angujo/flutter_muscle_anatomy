part of 'front_library.dart';

class Sternocleidomastoid extends FrontMuscle {
  Sternocleidomastoid(super.size);

  @override
    get _left => leftSternocleidomastoid;

  @override
  get _right => rightSternocleidomastoid;
}
