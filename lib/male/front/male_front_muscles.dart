part of 'front_library.dart';

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

class Digastric extends MaleFrontMuscle {
  Digastric(super.size);

  @override
  FrontMuscle get muscle => FrontMuscle.digastric;
}

class Sternocleidomastoid extends MaleFrontMuscle {
  Sternocleidomastoid(super.size);

  @override
  FrontMuscle get muscle => FrontMuscle.sternocleidomastoid;
}

class Scalene extends MaleFrontMuscle {
  Scalene(super.size);

  @override
  FrontMuscle get muscle => FrontMuscle.scalene;
}

class Trapezius extends MaleFrontMuscle {
  Trapezius(super.size);

  @override
  FrontMuscle get muscle => FrontMuscle.trapezius;
}

class Deltoid extends MaleFrontMuscle {
  Deltoid(super.size);

  @override
  FrontMuscle get muscle => FrontMuscle.deltoid;
}

class Biceps extends MaleFrontMuscle {
  Biceps(super.size);

  @override
  FrontMuscle get muscle => FrontMuscle.biceps;
}

class LatissimusDorsi extends MaleFrontMuscle {
  LatissimusDorsi(super.size);

  @override
  FrontMuscle get muscle => FrontMuscle.latissimusDorsi;
}

class PectolarisMajor extends MaleFrontMuscle {
  PectolarisMajor(super.size);

  @override
  FrontMuscle get muscle => FrontMuscle.pectolarisMajor;
}

class RectusAbdominis extends MaleFrontMuscle {
  RectusAbdominis(super.size);

  @override
  FrontMuscle get muscle => FrontMuscle.rectusAbdominis;
}

class ExternalAbdominalOblique extends MaleFrontMuscle {
  ExternalAbdominalOblique(super.size);

  @override
  FrontMuscle get muscle => FrontMuscle.externalAbdominalOblique;
}

class AdductorLongus extends MaleFrontMuscle {
  AdductorLongus(super.size);

  @override
  FrontMuscle get muscle => FrontMuscle.adductorLongus;
}

class TensorFasciaeLatae extends MaleFrontMuscle {
  TensorFasciaeLatae(super.size);

  @override
  FrontMuscle get muscle => FrontMuscle.tensorFasciaeLatae;
}

class Pectineus extends MaleFrontMuscle {
  Pectineus(super.size);

  @override
  FrontMuscle get muscle => FrontMuscle.pectineus;
}

class Iliopsoas extends MaleFrontMuscle {
  Iliopsoas(super.size);

  @override
  FrontMuscle get muscle => FrontMuscle.iliopsoas;
}

class Gracilis extends MaleFrontMuscle {
  Gracilis(super.size);

  @override
  FrontMuscle get muscle => FrontMuscle.gracilis;
}

class RectusFemoris extends MaleFrontMuscle {
  RectusFemoris(super.size);

  @override
  FrontMuscle get muscle => FrontMuscle.rectusFemoris;
}

class VastusMedialis extends MaleFrontMuscle {
  VastusMedialis(super.size);

  @override
  FrontMuscle get muscle => FrontMuscle.vastusMedialis;
}

class VastusLateralis extends MaleFrontMuscle {
  VastusLateralis(super.size);

  @override
  FrontMuscle get muscle => FrontMuscle.vastusLateralis;
}

class Sartorius extends MaleFrontMuscle {
  Sartorius(super.size);

  @override
  FrontMuscle get muscle => FrontMuscle.sartorius;
}

class Gastrocnemius extends MaleFrontMuscle {
  Gastrocnemius(super.size);

  @override
  FrontMuscle get muscle => FrontMuscle.gastrocnemius;
}

class Soleus extends MaleFrontMuscle {
  Soleus(super.size);

  @override
  FrontMuscle get muscle => FrontMuscle.soleus;
}

class TibialisAnterior extends MaleFrontMuscle {
  TibialisAnterior(super.size);

  @override
  FrontMuscle get muscle => FrontMuscle.tibialisAnterior;
}

class ExtensorDigitorumLongus extends MaleFrontMuscle {
  ExtensorDigitorumLongus(super.size);

  @override
  FrontMuscle get muscle => FrontMuscle.extensorDigitorumLongus;
}

class PeroneusLongus extends MaleFrontMuscle {
  PeroneusLongus(super.size);

  @override
  FrontMuscle get muscle => FrontMuscle.peroneusLongus;
}

class Brachialis extends MaleFrontMuscle {
  Brachialis(super.size);

  @override
  FrontMuscle get muscle => FrontMuscle.brachialis;
}

class Brachioradialis extends MaleFrontMuscle {
  Brachioradialis(super.size);

  @override
  FrontMuscle get muscle => FrontMuscle.brachioradialis;
}

class PronatorTeres extends MaleFrontMuscle {
  PronatorTeres(super.size);

  @override
  FrontMuscle get muscle => FrontMuscle.pronatorTeres;
}

class FlexorFasciaeLatae extends MaleFrontMuscle {
  FlexorFasciaeLatae(super.size);

  @override
  FrontMuscle get muscle => FrontMuscle.flexorFasciaeLatae;
}
