part of 'front_library.dart';

class RectusFemoris extends FrontMuscle {
  RectusFemoris(super.size);

  @override
    get _left => leftRectusFemoris;

  @override
  get _right => rightRectusFemoris;
}