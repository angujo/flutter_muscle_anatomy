part of 'male_front_library.dart';

enum FrontMuscle implements Muscle {
  // Front Muscles
  digastric(leftDigastric, rightDigastric),
  sternocleidomastoid(leftSternocleidomastoid, rightSternocleidomastoid),
  scalene(leftScalene, rightScalene),
  trapezius(leftTrapezius, rightTrapezius),
  deltoid(leftDeltoid, rightDeltoid),
  biceps(leftBiceps, rightBiceps),
  latissimusDorsi(leftLatissimusDorsi, rightLatissimusDorsi),
  pectolarisMajor(leftPectolarisMajor, rightPectolarisMajor),
  rectusAbdominis(leftRectusAbdominis, rightRectusAbdominis),
  externalAbdominalOblique(
    leftExternalAbdominalOblique,
    rightExternalAbdominalOblique,
  ),
  adductorLongus(leftAdductorLongus, rightAdductorLongus),
  tensorFasciaeLatae(leftTensorFasciaeLatae, rightTensorFasciaeLatae),
  pectineus(leftPectineus, rightPectineus),
  iliopsoas(leftIliopsoas, rightIliopsoas),
  gracilis(leftGracilis, rightGracilis),
  rectusFemoris(leftRectusFemoris, rightRectusFemoris),
  vastusMedialis(leftVastusMedialis, rightVastusMedialis),
  vastusLateralis(leftVastusLateralis, rightVastusLateralis),
  sartorius(leftSartorius, rightSartorius),
  gastrocnemius(leftGastrocnemius, rightGastrocnemius),
  soleus(leftSoleus, rightSoleus),
  tibialisAnterior(leftTibialisAnterior, rightTibialisAnterior),
  extensorDigitorumLongus(
    leftExtensorDigitorumLongus,
    rightExtensorDigitorumLongus,
  ),
  peroneusLongus(leftPeroneusLongus, rightPeroneusLongus),
  brachialis(leftBrachialis, rightBrachialis),
  brachioradialis(leftBrachioradialis, rightBrachioradialis),
  pronatorTeres(leftPronatorTeres, rightPronatorTeres),
  flexorFasciaeLatae(leftFlexorFasciaeLatae, rightFlexorFasciaeLatae);

  final Object _leftSvgPath;
  final Object _rightSvgPath;

  @override
  List<String> get rightSvgPath => flattenSvgPath(_rightSvgPath);

  @override
  List<String> get leftSvgPath => flattenSvgPath(_leftSvgPath);

  @override
  List<String> get svgPaths => [...leftSvgPath, ...rightSvgPath];

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

  SvgElement toSvgElement(
    MusclePosition? position, {
    Color fillColor = Colors.transparent,
    double fillOpacity = 0,
    Color strokeColor = Colors.black,
    double strokeWidth = 1,
  }) {
    String id = switch (position) {
      MusclePosition.left => 'left$name',
      MusclePosition.right => 'right$name',
      MusclePosition.both => name,
      _ => name,
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

  static SvgElement fromHighlight(
    MuscleHighlight<FrontMuscle> highlight, {
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

  @override
  List<Path> getPaths({
    required Size size,
    MusclePosition position = MusclePosition.both,
  }) {
    List<String> svgPaths = this.svgPaths;
    if (position == MusclePosition.left) svgPaths = leftSvgPath;
    if (position == MusclePosition.right) svgPaths = rightSvgPath;
    return getMusclePaths(svgPaths, size: size, svgSize: FRONT_SVG_SIZE);
  }

  const FrontMuscle(this._leftSvgPath, this._rightSvgPath);
}
