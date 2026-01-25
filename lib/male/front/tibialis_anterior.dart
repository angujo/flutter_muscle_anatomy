part of 'front_library.dart';

class TibialisAnterior extends FrontMuscle {
  TibialisAnterior(super.size);

  @override
    get _left => leftTibialisAnterior;

  @override
  get _right => rightTibialisAnterior;
}
