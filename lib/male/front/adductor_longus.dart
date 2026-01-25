part of 'front_library.dart';

class AdductorLongus extends FrontMuscle {
  AdductorLongus(super.size);

  @override
    get _left => leftAdductorLongus;

  @override
  get _right => rightAdductorLongus;
}
