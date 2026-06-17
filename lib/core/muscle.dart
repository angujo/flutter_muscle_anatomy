part of 'core.dart';

/// Represents individual muscles in the human body.
///
/// Each muscle is associated with a [BodyView] indicating where it is visible.
enum Muscle {
  /// The triceps brachii muscle, located on the back of the upper arm.
  triceps(view: BodyView.back),

  /// The levator scapulae muscle, which lifts the scapula.
  levatorScapulae(view: BodyView.back),

  /// The trapezius muscle, a large superficial muscle that extends longitudinally from the occipital bone to the lower thoracic vertebrae.
  trapezius(view: BodyView.back),

  /// The posterior part of the deltoid muscle.
  posteriorDeltoid(view: BodyView.back),

  /// The infraspinatus muscle, a thick triangular muscle that occupies the chief part of the infraspinatous fossa.
  infraspinatus(view: BodyView.back),

  /// The teres minor muscle, a narrow, elongated muscle of the rotator cuff.
  teresMinor(view: BodyView.back),

  /// The teres major muscle, a muscle of the upper limb.
  teresMajor(view: BodyView.back),

  /// The anconeus muscle, a small muscle on the posterior aspect of the elbow joint.
  anconeus(view: BodyView.back),

  /// The flexor carpi ulnaris muscle, a muscle of the human forearm that acts to flex and adduct the hand.
  flexorCarpiUlnaris(view: BodyView.back),

  /// The extensor carpi ulnaris muscle, a muscle of the forearm that acts to extend and adduct at the wrist.
  extensorCarpiUlnaris(view: BodyView.back),

  /// The extensor digitorum muscle, a muscle of the posterior forearm that extends the medial four digits of the hand.
  extensorDigitorum(view: BodyView.back),

  /// The external oblique muscle, the largest and most superficial of the three flat abdominal muscles.
  externalOblique(view: BodyView.back),

  /// The latissimus dorsi muscle, the larger, flat, dorso-lateral muscle on the trunk.
  latissimusDorsi(view: BodyView.both),

  /// The gluteus medius muscle, one of the three gluteal muscles.
  gluteusMedius(view: BodyView.back),

  /// The gluteus maximus muscle, the main extensor muscle of the hip.
  gluteusMaximus(view: BodyView.back),

  /// The iliotibial tract, a longitudinal fibrous reinforcement of the fascia lata.
  iliotibialTact(view: BodyView.back),

  /// The biceps femoris muscle, a muscle of the thigh located to the posterior, or back.
  bicepsFemoris(view: BodyView.back),

  /// The semitendinosus muscle, one of the three hamstring muscles.
  semitendinosus(view: BodyView.back),

  /// The adductor magnus muscle, a large triangular muscle, situated on the medial side of the thigh.
  adductorMagnus(view: BodyView.back),

  /// The semimembranosus muscle, the most medial of the three hamstring muscles.
  semimebranosus(view: BodyView.back),

  /// The gastrocnemius muscle, a powerful superficial bipennate muscle that is in the back part of the lower leg.
  gastrocnemius(view: BodyView.both),

  /// The soleus muscle, a powerful muscle in the back part of the lower leg.
  soleus(view: BodyView.both),

  /// The digastric muscle, a small muscle located under the jaw.
  digastric(view: BodyView.front),

  /// The sternocleidomastoid muscle, one of the largest and most superficial cervical muscles.
  sternocleidomastoid(view: BodyView.front),

  /// The scalene muscles, a group of three pairs of muscles in the lateral neck.
  scalene(view: BodyView.front),

  /// The upper portion of the trapezius muscle.
  upperTrapezius(view: BodyView.front),

  /// The deltoid muscle, the muscle forming the rounded contour of the human shoulder.
  deltoid(view: BodyView.front),

  /// The biceps brachii muscle, a two-headed muscle that lies on the upper arm between the shoulder and the elbow.
  biceps(view: BodyView.front),

  /// The pectoralis major muscle, a thick, fan-shaped muscle, situated at the chest of the human body.
  pectolarisMajor(view: BodyView.front),

  /// The rectus abdominis muscle, also known as the "abs".
  rectusAbdominis(view: BodyView.front),

  /// The external abdominal oblique muscle.
  externalAbdominalOblique(view: BodyView.front),

  /// The adductor longus muscle, a skeletal muscle located in the thigh.
  adductorLongus(view: BodyView.front),

  /// The tensor fasciae latae muscle, a muscle of the thigh.
  tensorFasciaeLatae(view: BodyView.front),

  /// The pectineus muscle, a flat, quadrangular muscle, situated at the anterior part of the medial and upper aspect of the thigh.
  pectineus(view: BodyView.front),

  /// The iliopsoas muscle, the joined psoas and iliacus muscles.
  iliopsoas(view: BodyView.front),

  /// The gracilis muscle, the most superficial muscle on the medial side of the thigh.
  gracilis(view: BodyView.front),

  /// The rectus femoris muscle, one of the four quadriceps muscles of the human body.
  rectusFemoris(view: BodyView.front),

  /// The vastus medialis muscle, an extensor muscle located medially in the thigh that extends the knee.
  vastusMedialis(view: BodyView.front),

  /// The vastus lateralis muscle, the largest and most powerful part of the quadriceps femoris.
  vastusLateralis(view: BodyView.front),

  /// The sartorius muscle, the longest muscle in the human body.
  sartorius(view: BodyView.front),

  /// The tibialis anterior muscle, a muscle that originates in the upper two-thirds of the lateral surface of the tibia.
  tibialisAnterior(view: BodyView.front),

  /// The anterior part of the deltoid muscle.
  anteriorDeltoid(view: BodyView.front),

  /// The extensor digitorum longus muscle, a pennate muscle on the lateral part of the front of the leg.
  extensorDigitorumLongus(view: BodyView.front),

  /// The peroneus longus muscle, a superficial muscle in the lateral compartment of the leg.
  peroneusLongus(view: BodyView.front),

  /// The brachialis muscle, a muscle in the upper arm that flexes the elbow joint.
  brachialis(view: BodyView.front),

  /// The brachioradialis muscle, a muscle of the forearm that flexes the forearm at the elbow.
  brachioradialis(view: BodyView.front),

  /// The pronator teres muscle, a muscle of the human body that is located in the forearm.
  pronatorTeres(view: BodyView.front),

  /// The flexor fasciae latae muscle.
  flexorFasciaeLatae(view: BodyView.front);

  final BodyView _view;

  const Muscle({required BodyView view}) : _view = view;

  /// Returns true if the muscle is visible from the front view.
  bool isFront() => _view == BodyView.front || _view == BodyView.both;

  /// Returns true if the muscle is visible from the back view.
  bool isBack() => _view == BodyView.back || _view == BodyView.both;

  /// Returns true if the muscle is visible in the specified [view].
  bool isForView(BodyView view) =>
      view == BodyView.both ||
      _view == view ||
      (_view == BodyView.both &&
          (view == BodyView.front || view == BodyView.back));

  /// Returns a list of all muscles visible from the front.
  static List<Muscle> front() =>
      Muscle.values.where((m) => m.isForView(BodyView.front)).toList();

  /// Returns a list of all muscles visible from the back.
  static List<Muscle> back() =>
      Muscle.values.where((m) => m.isForView(BodyView.back)).toList();

  /// Returns a list of all muscles visible in the specified [view].
  static List<Muscle> forView(BodyView view) =>
      Muscle.values.where((m) => m.isForView(view)).toList();
}

/// A helper class to facilitate mapping [Muscle] enum values to SVG path data.
final class MuscleHelper {
  /// Internal cache for [MuscleHelper] instances.
  static final Map<(Muscle, SvgAssetType), MuscleHelper> _instances = {};
  final String _name;
  final SvgPathReader _svgPathReader;

  /// The name of the muscle (corresponds to the enum member name).
  String get name => _name;

  /// The snake_case version of the muscle name, used for SVG IDs.
  String get svgId => camelToSnake(_name);

  /// Returns the SVG path data for the right side of this muscle.
  List<String> get rightSvgPath => _svgPathReader.getPathDs("right_$svgId");

  /// Returns the SVG path data for the left side of this muscle.
  List<String> get leftSvgPath => _svgPathReader.getPathDs("left_$svgId");

  /// Returns the SVG path data for this muscle (could be both or a single centered path).
  List<String> get svgPaths => _svgPathReader.getPathDs(svgId);

  const MuscleHelper._(this._name, this._svgPathReader);

  factory MuscleHelper(Muscle muscle, SvgPathReader svgPathReader) =>
      _instances.putIfAbsent((
        muscle,
        svgPathReader._assetType,
      ), () => MuscleHelper._(muscle.name, svgPathReader));

  /// Converts this muscle helper into an [SvgElement] for a specific [position].
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

  /// Returns the raw SVG path data string(s) for the specified [position].
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

  /// Creates an [SvgElement] from a [MuscleHighlight] object.
  static SvgElement fromHighlight<T extends Muscle>(
    MuscleHighlight<T> highlight,
    SvgPathReader pathReader, {
    Color? strokeColor,
    double? strokeWidth,
    String? idSuffix,
  }) {
    return MuscleHelper(highlight.muscle, pathReader).toSvgElement(
      highlight.position,
      fillColor: highlight.color,
      fillOpacity: highlight.opacity,
      strokeColor: strokeColor ?? highlight.color,
      strokeWidth: strokeWidth ?? highlight.opacity,
      idSuffix: idSuffix,
    );
  }

  /// Factory-like method to get a [MuscleHelper] from a [Muscle].
  factory MuscleHelper.fromMuscle(Muscle muscle, SvgPathReader svgPathReader) =>
      MuscleHelper(muscle, svgPathReader);
}

/// Represents a configuration for highlighting a specific muscle.
class MuscleHighlight<T extends Muscle> {
  /// The muscle to be highlighted.
  final T muscle;

  /// The position (left, right, or both) of the muscle to highlight.
  final MusclePosition position;

  /// The color to use for the highlight.
  final Color color;

  /// The opacity of the highlight color.
  final double opacity;

  /// Creates a new [MuscleHighlight] configuration.
  MuscleHighlight({
    required this.position,
    required this.color,
    required this.opacity,
    required this.muscle,
  });

  /// Creates a copy of this [MuscleHighlight] with updated fields.
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
