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
  @Deprecated("Use iliotibialTract instead")
  iliotibialTact(view: BodyView.back),

  /// The iliotibial tract, a longitudinal fibrous reinforcement of the fascia lata.
  iliotibialTract(view: BodyView.back),

  /// The biceps femoris muscle, a muscle of the thigh located to the posterior, or back.
  bicepsFemoris(view: BodyView.back),

  /// The semitendinosus muscle, one of the three hamstring muscles.
  semitendinosus(view: BodyView.back),

  /// The adductor magnus muscle, a large triangular muscle, situated on the medial side of the thigh.
  adductorMagnus(view: BodyView.back),

  /// The semimembranosus muscle, the most medial of the three hamstring muscles.
  semimembranosus(view: BodyView.back),
  @Deprecated("Use semimembranosus instead")
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
  pectoralisMajor(view: BodyView.front),
  @Deprecated("Use pectoralisMajor instead")
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

  //region Aliases
  static Muscle get abs => rectusAbdominis;

  static Muscle get obliques => externalAbdominalOblique;

  static Muscle get pecs => pectoralisMajor;

  static Muscle get chest => pectoralisMajor;

  static Muscle get lats => latissimusDorsi;

  static Muscle get traps => trapezius;

  static Muscle get quads => rectusFemoris;

  static Muscle get hamstrings => bicepsFemoris;

  static Muscle get calves => gastrocnemius;

  static Muscle get glutes => gluteusMaximus;

  static Muscle get rearDelts => posteriorDeltoid;

  static Muscle get frontDelts => anteriorDeltoid;

  //endregion

  final BodyView view;

  const Muscle({required this.view});

  /// Returns true if the muscle is visible from the front view.
  bool get isFront => view == BodyView.front || view == BodyView.both;

  /// Returns true if the muscle is visible from the back view.
  bool get isBack => view == BodyView.back || view == BodyView.both;

  /// Returns true if the muscle is visible in the specified [view].
  bool isForView(BodyView view) =>
      view == BodyView.both || this.view == view || this.view == BodyView.both;

  /// Returns a list of all muscles visible from the front.
  static List<Muscle> front() =>
      Muscle.values.where((m) => m.isForView(BodyView.front)).toList();

  /// Returns a list of all muscles visible from the back.
  static List<Muscle> back() =>
      Muscle.values.where((m) => m.isForView(BodyView.back)).toList();

  /// Returns a list of all muscles visible in the specified [view].
  static List<Muscle> forView(BodyView view) =>
      Muscle.values.where((m) => m.isForView(view)).toList();

  /// Returns the view that is most represented in the provided set of [muscles].
  static BodyView dominantView(Iterable<Muscle> muscles) {
    if (muscles.isEmpty) return BodyView.front;
    var frontCount = 0, backCount = 0;
    for (final muscle in muscles) {
      frontCount += muscle.isFront ? 1 : 0;
      backCount += muscle.isBack ? 1 : 0;
    }
    return frontCount < backCount ? BodyView.back : BodyView.front;
  }

  /// Returns the list of views necessary to display the provided [muscles].
  static List<BodyView> views(Iterable<Muscle> muscles) {
    var frontCount = 0;
    var backCount = 0;

    for (final muscle in muscles) {
      if (muscle.isFront) frontCount++;
      if (muscle.isBack) backCount++;
    }

    final frontAny = frontCount > 0;
    final backAny = backCount > 0;

    if (frontAny && backAny) {
      return [
        backCount > frontCount ? BodyView.back : BodyView.front,
        backCount > frontCount ? BodyView.front : BodyView.back,
      ];
    }

    return [backAny ? BodyView.back : BodyView.front];
  }

  static List<Muscle> search(String query, {int? top}) {
    return _MuscleSearch.search(
      query,
      top: top,
    ).map((g) => g.muscles).expand((m) => m).toList();
  }
}

/// Represents raw SVG path data for a muscle.
class SVGPathData {
  /// The list of SVG path 'd' strings.
  final List<String> svgPaths;

  /// Creates an instance of [SVGPathData].
  const SVGPathData({required this.svgPaths});

  /// Returns the path data as a list of [Path] objects.
  List<Path> get paths => svgPaths.map(parseSvgPathData).toList();

  /// Converts the path data to an [SvgElement].
  SvgElement toSvgElement(MuscleInstance loc, MuscleDecoration decoration) {
    final group = SvgGroup(id: loc.svgWriteId);
    final paths = svgPaths
        .asMap()
        .map(
          (idx, path) => MapEntry(
            idx,
            SvgPath(id: '${loc.svgWriteId}_$idx', d: path)
              ..fill(decoration.fillColor, opacity: decoration.fillOpacity)
              ..stroke(decoration.strokeColor, width: decoration.strokeWidth),
          ),
        )
        .values;
    group.addChildren(paths);
    return group;
  }
}

class MuscleInstance {
  final Muscle muscle;
  final MuscleSide position;

  /// The name of the muscle (corresponds to the enum member name).
  String get name => muscle.name;

  /// The snake_case version of the muscle name, used for SVG IDs.
  String get svgReadId => position == MuscleSide.both
      ? camelToSnake(name)
      : "${position.name}_${camelToSnake(name)}";

  /// The snake_case version of the muscle name, used for SVG IDs.
  String get svgWriteId =>
      "${camelToSnake(name)}_${position.name}_${muscle.view.name}";

  const MuscleInstance({required this.muscle, required this.position});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is MuscleInstance &&
            other.muscle == muscle &&
            other.position == position);
  }

  @override
  int get hashCode => Object.hash(muscle.hashCode, position.hashCode);

  @override
  String toString() {
    return "MuscleInstance(muscle: $muscle, position: $position)";
  }

  /// Returns an inverted version of this muscle instance (swaps left/right).
  MuscleInstance inverse() =>
      MuscleInstance(muscle: muscle, position: position.inverse());
}

/// Defines the visual styling for a muscle.
class MuscleDecoration {
  final Color _fillColor;
  final double? _fillOpacity;
  final Color _strokeColor;
  final double? _strokeOpacity;
  final double _strokeWidth;

  /// Returns the fill color with applied opacity (defaults to 1.0 if null).
  Color get fillColor => _fillColor.withValues(alpha: _fillOpacity ?? 1.0);

  /// The fill opacity (0.0 to 1.0).
  double? get fillOpacity => _fillOpacity;

  /// Returns the stroke color with applied opacity (defaults to 1.0 if null).
  Color get strokeColor =>
      _strokeColor.withValues(alpha: _strokeOpacity ?? 1.0);

  /// The stroke width.
  double get strokeWidth => _strokeWidth;

  /// The stroke opacity (0.0 to 1.0).
  double? get strokeOpacity => _strokeOpacity;

  double get _paintStrokeWidth => _strokeWidth * 5;

  const MuscleDecoration._({
    Color? fillColor,
    double? fillOpacity,
    Color? strokeColor,
    double? strokeOpacity,
    double? strokeWidth,
  }) : _fillColor = fillColor ?? Colors.transparent,
       _fillOpacity = fillOpacity,
       _strokeColor = strokeColor ?? Colors.black,
       _strokeOpacity = strokeOpacity,
       _strokeWidth = strokeWidth ?? 0.1;

  /// Creates a [MuscleDecoration] instance.
  factory MuscleDecoration({
    Color? fillColor,
    double? fillOpacity,
    Color? strokeColor,
    double? strokeOpacity,
    double? strokeWidth,
  }) => MuscleDecoration._(
    fillColor: fillColor,
    fillOpacity: fillOpacity,
    strokeColor: strokeColor,
    strokeOpacity: strokeOpacity,
    strokeWidth: strokeWidth,
  );

  /// Merges properties of [other] into this decoration.
  /// If [other] is null, returns this instance unchanged.
  MuscleDecoration copyFrom(MuscleDecoration? other) {
    if (other == null) return this;
    return copyWith(
      fillColor: other._fillColor,
      fillOpacity: other._fillOpacity,
      strokeColor: other._strokeColor,
      strokeOpacity: other._strokeOpacity,
      // Added missing property
      strokeWidth: other._strokeWidth,
    );
  }

  /// Creates a copy of this decoration with updated properties.
  MuscleDecoration copyWith({
    Color? fillColor,
    double? fillOpacity,
    Color? strokeColor,
    double? strokeOpacity,
    double? strokeWidth,
  }) {
    return MuscleDecoration._(
      fillColor: fillColor ?? _fillColor,
      // We allow explicitly passing null or falling back to current value
      fillOpacity: fillOpacity ?? _fillOpacity,
      strokeColor: strokeColor ?? _strokeColor,
      strokeOpacity: strokeOpacity ?? _strokeOpacity,
      strokeWidth: strokeWidth ?? _strokeWidth,
    );
  }

  /// Returns a [Paint] object for the stroke based on this decoration.
  Paint strokePaint() {
    return Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _paintStrokeWidth
      ..color = strokeColor; // Uses the getter safely
  }

  /// Returns a [Paint] object for the fill based on this decoration.
  Paint fillPaint() {
    return Paint()
      ..style = PaintingStyle.fill
      ..color = fillColor; // Uses the getter safely
  }

  @override
  String toString() {
    return "MuscleDecoration(fillColor: ${_fillColor.toHex()}, fillOpacity: $_fillOpacity, strokeColor: ${_strokeColor.toHex()}, strokeOpacity: $_strokeOpacity, strokeWidth: $_strokeWidth)";
  }
}

/// Represents a muscle member within the anatomy visualization.
final class MuscleMember {
  final MuscleInstance _instance;
  final SVGPathData _data;
  final Matrix4? _transform;
  final MuscleDecoration _decoration;

  /// The muscle associated with this member.
  Muscle get muscle => _instance.muscle;

  /// The lateral position of this member.
  MuscleSide get position => _instance.position;

  /// The name of the muscle.
  String get name => _instance.name;

  /// The list of SVG path strings for this member.
  List<String> get svgPaths => _data.svgPaths;

  /// The visual decoration applied to this member.
  MuscleDecoration get decoration => _decoration;

  /// The list of [Path] objects, with any transformations applied.
  List<Path> get paths {
    final rawPaths = _data.paths;
    if (null == _transform) return rawPaths;
    return rawPaths.map((p) => p.transform(_transform.storage)).toList();
  }

  /// Creates an instance of [MuscleMember].
  const MuscleMember(
    this._instance,
    this._data,
    this._decoration, [
    this._transform,
  ]);
}

/// Represents a highlighted muscle in the anatomy visualization.
final class MuscleHighlight {
  final MuscleInstance _instance;
  final MuscleDecoration _decoration;

  /// The muscle associated with this highlight.
  Muscle get muscle => _instance.muscle;

  /// The lateral position of this highlight.
  MuscleSide get position => _instance.position;

  /// The fill color of the highlight.
  Color get fillColor => _decoration.fillColor;

  /// The fill opacity of the highlight.
  double? get fillOpacity => _decoration.fillOpacity;

  /// The stroke color of the highlight.
  Color get strokeColor => _decoration.strokeColor;

  /// The stroke width of the highlight.
  double get strokeWidth => _decoration.strokeWidth;

  /// The stroke opacity of the highlight.
  double? get strokeOpacity => _decoration.strokeOpacity;

  /// Returns the [Paint] for the highlight stroke.
  Paint get strokePaint => _decoration.strokePaint();

  /// Returns the [Paint] for the highlight fill.
  Paint get fillPaint => _decoration.fillPaint();

  /// Creates an instance of [MuscleHighlight].
  const MuscleHighlight(this._instance, this._decoration);
}

class _MuscleSearchResult {
  final _MuscleGroup group;
  final double score;

  const _MuscleSearchResult({required this.group, required this.score});
}

class _MuscleGroups {
  static final List<_MuscleGroup> values = [
    const _MuscleGroup(
      name: 'Abs',
      muscles: {Muscle.rectusAbdominis},
      searchTerms: {
        'abs',
        'ab',
        'abdominals',
        'rectus abdominis',
        'six pack',
        'six-pack',
        'sixpack',
        'core',
        'stomach',
        'stomach muscles',
      },
    ),

    const _MuscleGroup(
      name: 'Obliques',
      muscles: {Muscle.externalAbdominalOblique}, // Kept one for redundancy cleanup, update to match your enum
      searchTerms: {
        'oblique',
        'obliques',
        'side abs',
        'waist',
        'waist muscles',
      },
    ),

    const _MuscleGroup(
      name: 'Chest',
      muscles: {Muscle.pectoralisMajor}, // Fixed typo: pectolaris -> pectoralis
      searchTerms: {
        'chest',
        'pec',
        'pecs',
        'pectoral',
        'pectorals',
        'pectoralis major',
      },
    ),

    const _MuscleGroup(
      name: 'Lats',
      muscles: {Muscle.latissimusDorsi},
      searchTerms: {
        'lat',
        'lats',
        'latissimus',
        'latissimus dorsi',
        'wings',
        'back width',
        'v taper',
      },
    ),

    const _MuscleGroup(
      name: 'Traps',
      muscles: {Muscle.trapezius, Muscle.upperTrapezius},
      searchTerms: {'trap', 'traps', 'trapezius', 'upper traps', 'upper back'},
    ),

    const _MuscleGroup(
      name: 'Shoulders',
      muscles: {
        Muscle.deltoid,
        Muscle.anteriorDeltoid,
        Muscle.posteriorDeltoid,
      },
      searchTerms: {
        'shoulder',
        'shoulders',
        'delt',
        'delts',
        'deltoid',
        'deltoids',
      },
    ),

    const _MuscleGroup(
      name: 'Front Delts',
      muscles: {Muscle.anteriorDeltoid},
      searchTerms: {
        'front delt',
        'front delts',
        'anterior delt',
        'anterior deltoid',
        'front shoulder',
      },
    ),

    const _MuscleGroup(
      name: 'Rear Delts',
      muscles: {Muscle.posteriorDeltoid},
      searchTerms: {
        'rear delt',
        'rear delts',
        'posterior delt',
        'posterior deltoid',
        'rear shoulder',
      },
    ),

    const _MuscleGroup(
      name: 'Biceps',
      muscles: {Muscle.biceps, Muscle.brachialis},
      searchTerms: {'bicep', 'biceps', 'biceps brachii', 'arm flexors'},
    ),

    const _MuscleGroup(
      name: 'Triceps',
      muscles: {Muscle.triceps},
      searchTerms: {'tricep', 'triceps', 'triceps brachii'},
    ),

    const _MuscleGroup(
      name: 'Forearms',
      muscles: {
        Muscle.brachioradialis,
        Muscle.flexorCarpiUlnaris,
        Muscle.extensorCarpiUlnaris,
        Muscle.extensorDigitorum,
        Muscle.pronatorTeres,
      },
      searchTerms: {
        'forearm',
        'forearms',
        'grip',
        'grip strength',
        'wrist flexors',
        'wrist extensors',
      },
    ),

    const _MuscleGroup(
      name: 'Glutes',
      muscles: {Muscle.gluteusMaximus, Muscle.gluteusMedius},
      searchTerms: {'glute', 'glutes', 'gluteal', 'butt', 'buttocks', 'hips'},
    ),

    const _MuscleGroup(
      name: 'Hip Flexors',
      muscles: {Muscle.iliopsoas, Muscle.tensorFasciaeLatae},
      searchTerms: {'hip flexor', 'hip flexors', 'iliopsoas', 'psoas', 'tfl'},
    ),

    const _MuscleGroup(
      name: 'Adductors',
      muscles: {
        Muscle.adductorLongus,
        Muscle.adductorMagnus,
        Muscle.gracilis,
        Muscle.pectineus,
      },
      searchTerms: {'adductor', 'adductors', 'inner thigh', 'groin'},
    ),

    const _MuscleGroup(
      name: 'Quads',
      muscles: {
        Muscle.rectusFemoris,
        Muscle.vastusMedialis,
        Muscle.vastusLateralis,
        // Optional: Muscle.vastusIntermedius (the 4th quad muscle, if you want full completion)
      },
      searchTerms: {'quad', 'quads', 'quadriceps', 'front thigh', 'vmo'},
    ),

    const _MuscleGroup(
      name: 'Hamstrings',
      muscles: {
        Muscle.bicepsFemoris,
        Muscle.semitendinosus,
        Muscle.semimembranosus, // Fixed typo: semimebranosus -> semimembranosus
      },
      searchTerms: {'hamstring', 'hamstrings', 'rear thigh', 'back of thigh'},
    ),

    const _MuscleGroup(
      name: 'Calves',
      muscles: {Muscle.gastrocnemius, Muscle.soleus},
      searchTerms: {'calf', 'calves', 'gastrocnemius', 'soleus'},
    ),

    const _MuscleGroup(
      name: 'Shins',
      muscles: {Muscle.tibialisAnterior},
      searchTerms: {'shin', 'shins', 'tibialis anterior'},
    ),
  ];
}

class _MuscleGroup {
  final String name;
  final Set<Muscle> muscles;
  final Set<String> searchTerms;

  const _MuscleGroup({
    required this.name,
    required this.muscles,
    required this.searchTerms,
  });
}

class _MuscleSearch {
  static List<_MuscleGroup> search(String query, {int? top}) {
    if (query.trim().isEmpty || 0 == top) return [];
    final q = _normalize(query);

    final results = <_MuscleSearchResult>[];

    for (final group in _MuscleGroups.values) {
      double bestScore = 0;

      for (final term in group.searchTerms) {
        final score = _score(q, _normalize(term));

        if (score > bestScore) {
          bestScore = score;
        }
      }

      if (bestScore >= 0.4) {
        results.add(_MuscleSearchResult(group: group, score: bestScore));
      }
    }

    results.sort((a, b) => b.score.compareTo(a.score));

    return (null == top ? results : results.take(top))
        .map((sr) => sr.group)
        .toList();
  }

  static double _score(String query, String term) {
    if (query == term) {
      return 1.0;
    }

    if (term.startsWith(query)) {
      return 0.95;
    }

    if (term.contains(query)) {
      return 0.85;
    }

    final similarity = _similarity(query, term);

    return similarity * 0.75;
  }

  static double _similarity(String a, String b) {
    final distance = _levenshtein(a, b);

    final maxLength = a.length > b.length ? a.length : b.length;

    if (maxLength == 0) {
      return 1;
    }

    return 1 - (distance / maxLength);
  }

  static int _levenshtein(String a, String b) {
    final matrix = List.generate(
      a.length + 1,
      (_) => List.filled(b.length + 1, 0),
    );

    for (var i = 0; i <= a.length; i++) {
      matrix[i][0] = i;
    }

    for (var j = 0; j <= b.length; j++) {
      matrix[0][j] = j;
    }

    for (var i = 1; i <= a.length; i++) {
      for (var j = 1; j <= b.length; j++) {
        final cost = a[i - 1] == b[j - 1] ? 0 : 1;

        matrix[i][j] = [
          matrix[i - 1][j] + 1,
          matrix[i][j - 1] + 1,
          matrix[i - 1][j - 1] + cost,
        ].reduce((a, b) => a < b ? a : b);
      }
    }

    return matrix[a.length][b.length];
  }

  static String _normalize(String value) {
    return value
        .toLowerCase()
        .replaceAll('&', 'and')
        .replaceAll(RegExp(r'[^a-z0-9 ]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}
