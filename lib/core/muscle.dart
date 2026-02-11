part of 'core.dart';

abstract class SvgMuscle {}

abstract class Muscle {
  final String _name;
  final BodyView _view;

  BodyView get view => _view;

  String get name => _name;

  String get svgId => camelToSnake(_name);

  List<String> get rightSvgPath => getSvgPathReader().getPathDs("right_$svgId");

  List<String> get leftSvgPath => getSvgPathReader().getPathDs("left_$svgId");

  List<String> get svgPaths => getSvgPathReader().getPathDs(svgId);

  const Muscle(this._name, {required BodyView view}) : _view = view;

  SvgPathReader getSvgPathReader();

  SvgElement toSvgElement(
    MusclePosition? position, {
    Color fillColor = Colors.transparent,
    double fillOpacity = 0,
    Color strokeColor = Colors.black,
    double strokeWidth = 1,
  }) {
    String id = switch (position) {
      MusclePosition.left => 'left$_name',
      MusclePosition.right => 'right$_name',
      MusclePosition.both => _name,
      _ => _name,
    };
    final elmt = SvgGroup(id: id);
    final paths = getSvgPath(position)
        .asMap()
        .map(
          (idx, path) => MapEntry(
            idx,
            SvgPath(id: '$id$idx', d: path)
              ..fill(fillColor, opacity: fillOpacity)
              ..stroke(strokeColor, width: strokeWidth),
          ),
        )
        .values;
    elmt.addChildren(paths);
    return elmt;
  }

  List<String> getSvgPath(MusclePosition? position) {
    switch (position) {
      case MusclePosition.left:
        return leftSvgPath;
      case MusclePosition.right:
        return rightSvgPath;
      case MusclePosition.both:
      default:
        return svgPaths;
    }
  }

  static SvgElement fromHighlight<T extends Muscle>(
    MuscleHighlight<T> highlight, {
    Color? strokeColor,
    double? strokeWidth,
  }) {
    return highlight.muscle.toSvgElement(
      highlight.position,
      fillColor: highlight.color,
      fillOpacity: highlight.opacity,
      strokeColor: strokeColor ?? highlight.color,
      strokeWidth: strokeWidth ?? highlight.opacity,
    );
  }
}
