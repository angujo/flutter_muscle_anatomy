part of 'core.dart';

enum Muscle {
  triceps(view: BodyView.back),
  levatorScapulae(view: BodyView.back),
  trapezius(view: BodyView.back),
  posteriorDeltoid(view: BodyView.back),
  infraspinatus(view: BodyView.back),
  teresMinor(view: BodyView.back),
  teresMajor(view: BodyView.back),
  anconeus(view: BodyView.back),
  flexorCarpiUlnaris(view: BodyView.back),
  extensorCarpiUlnaris(view: BodyView.back),
  extensorDigitorum(view: BodyView.back),
  externalOblique(view: BodyView.back),
  latissimusDorsi(view: BodyView.both),
  gluteusMedius(view: BodyView.back),
  gluteusMaximus(view: BodyView.back),
  iliotibialTact(view: BodyView.back),
  bicepsFemoris(view: BodyView.back),
  semitendinosus(view: BodyView.back),
  adductorMagnus(view: BodyView.back),
  semimebranosus(view: BodyView.back),
  gastrocnemius(view: BodyView.both),
  soleus(view: BodyView.both),
  digastric(view: BodyView.front),
  sternocleidomastoid(view: BodyView.front),
  scalene(view: BodyView.front),
  upperTrapezius(view: BodyView.front),
  deltoid(view: BodyView.front),
  biceps(view: BodyView.front),
  pectolarisMajor(view: BodyView.front),
  rectusAbdominis(view: BodyView.front),
  externalAbdominalOblique(view: BodyView.front),
  adductorLongus(view: BodyView.front),
  tensorFasciaeLatae(view: BodyView.front),
  pectineus(view: BodyView.front),
  iliopsoas(view: BodyView.front),
  gracilis(view: BodyView.front),
  rectusFemoris(view: BodyView.front),
  vastusMedialis(view: BodyView.front),
  vastusLateralis(view: BodyView.front),
  sartorius(view: BodyView.front),
  tibialisAnterior(view: BodyView.front),
  anteriorDeltoid(view: BodyView.front),
  extensorDigitorumLongus(view: BodyView.front),
  peroneusLongus(view: BodyView.front),
  brachialis(view: BodyView.front),
  brachioradialis(view: BodyView.front),
  pronatorTeres(view: BodyView.front),
  flexorFasciaeLatae(view: BodyView.front);

  final BodyView _view;

  const Muscle({required BodyView view}) : _view = view;

  bool isFront() => _view == BodyView.front || _view == BodyView.both;

  bool isBack() => _view == BodyView.back || _view == BodyView.both;

  bool isForView(BodyView view) =>
      view == BodyView.both ||
      _view == view ||
      (_view == BodyView.both &&
          (view == BodyView.front || view == BodyView.back));

  static List<Muscle> front() =>
      Muscle.values.where((m) => m.isForView(BodyView.front)).toList();

  static List<Muscle> back() =>
      Muscle.values.where((m) => m.isForView(BodyView.back)).toList();

  static List<Muscle> forView(BodyView view) =>
      Muscle.values.where((m) => m.isForView(view)).toList();
}

class MuscleHelper {
  static final Map<(Muscle, String), MuscleHelper> _instances = {};
  final String _name;
  final SvgPathReader _svgPathReader;

  String get name => _name;

  String get svgId => camelToSnake(_name);

  List<String> get rightSvgPath => _svgPathReader.getPathDs("right_$svgId");

  List<String> get leftSvgPath => _svgPathReader.getPathDs("left_$svgId");

  List<String> get svgPaths => _svgPathReader.getPathDs(svgId);

  static MuscleHelper getInstance(Muscle muscle, SvgPathReader svgPathReader) {
    final key = (muscle, svgPathReader._filePath);
    _instances.putIfAbsent(
      key,
      () => MuscleHelper._(muscle.name, svgPathReader),
    );
    return _instances[key]!;
  }

  const MuscleHelper._(this._name, this._svgPathReader);

  SvgElement toSvgElement(
    MusclePosition? position, {
    Color fillColor = Colors.transparent,
    double fillOpacity = 0,
    Color strokeColor = Colors.black,
    double strokeWidth = 1,
    String? idSuffix,
  }) {
    final suffix = null == idSuffix || idSuffix.isEmpty ? '' : '_$idSuffix';
    String id = switch (position) {
      MusclePosition.left => 'left_$_name$suffix',
      MusclePosition.right => 'right_$_name$suffix',
      _ => '$_name$suffix',
    };
    final elmt = SvgGroup(id: id);
    final paths = getSvgPath(position)
        .asMap()
        .map(
          (idx, path) => MapEntry(
            idx,
            SvgPath(id: '${id}_$idx', d: path)
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
    MuscleHighlight<T> highlight,
    SvgPathReader pathReader, {
    Color? strokeColor,
    double? strokeWidth,
    String? idSuffix,
  }) {
    return getInstance(highlight.muscle, pathReader).toSvgElement(
      highlight.position,
      fillColor: highlight.color,
      fillOpacity: highlight.opacity,
      strokeColor: strokeColor ?? highlight.color,
      strokeWidth: strokeWidth ?? highlight.opacity,
      idSuffix: idSuffix,
    );
  }

  static MuscleHelper fromMuscle(Muscle muscle, SvgPathReader svgPathReader) {
    return getInstance(muscle, svgPathReader);
  }
}

class MuscleHighlight<T extends Muscle> {
  final T muscle;
  final MusclePosition position;
  final Color color;
  final double opacity;

  MuscleHighlight({
    required this.position,
    required this.color,
    required this.opacity,
    required this.muscle,
  });

  MuscleHighlight<T> copyWith({
    T? muscle,
    MusclePosition? position,
    Color? color,
    double? opacity,
  }) {
    return MuscleHighlight(
      muscle: muscle ?? this.muscle,
      position: position ?? this.position,
      color: color ?? this.color,
      opacity: opacity ?? this.opacity,
    );
  }
}
