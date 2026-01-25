part of 'front_library.dart';

class Pectineus extends FrontMuscle {
  Pectineus(super.size);

  @override
    get _left => leftPectineus;

  @override
  get _right => rightPectineus;
}
