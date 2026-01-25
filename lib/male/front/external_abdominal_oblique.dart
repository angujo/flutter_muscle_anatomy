part of 'front_library.dart';

class ExternalAbdominalOblique extends FrontMuscle {
  ExternalAbdominalOblique(super.size);

  @override
    get _left => leftExternalAbdominalOblique;

  @override
  get _right => rightExternalAbdominalOblique;
}
