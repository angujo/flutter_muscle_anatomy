part of 'core.dart';

abstract class FrontMuscle {
  static FrontMuscles male = _FrontMuscles._(SvgPathReader.maleFront());
  static FrontMuscles female = _FrontMuscles._(SvgPathReader.maleFront());

  const FrontMuscle._();
}

abstract class FrontMuscles {
  List<Muscle> get all => [
    digastric,
    sternocleidomastoid,
    scalene,
    trapezius,
    deltoid,
    biceps,
    latissimusDorsi,
    pectolarisMajor,
    rectusAbdominis,
    externalAbdominalOblique,
    adductorLongus,
    tensorFasciaeLatae,
    pectineus,
    iliopsoas,
    gracilis,
    rectusFemoris,
    vastusMedialis,
    vastusLateralis,
    sartorius,
    gastrocnemius,
    soleus,
    tibialisAnterior,
    extensorDigitorumLongus,
    peroneusLongus,
    brachialis,
    brachioradialis,
    pronatorTeres,
    flexorFasciaeLatae,
  ];

  Muscle get digastric;

  Muscle get sternocleidomastoid;

  Muscle get scalene;

  Muscle get trapezius;

  Muscle get deltoid;

  Muscle get biceps;

  Muscle get latissimusDorsi;

  Muscle get pectolarisMajor;

  Muscle get rectusAbdominis;

  Muscle get externalAbdominalOblique;

  Muscle get adductorLongus;

  Muscle get tensorFasciaeLatae;

  Muscle get pectineus;

  Muscle get iliopsoas;

  Muscle get gracilis;

  Muscle get rectusFemoris;

  Muscle get vastusMedialis;

  Muscle get vastusLateralis;

  Muscle get sartorius;

  Muscle get gastrocnemius;

  Muscle get soleus;

  Muscle get tibialisAnterior;

  Muscle get extensorDigitorumLongus;

  Muscle get peroneusLongus;

  Muscle get brachialis;

  Muscle get brachioradialis;

  Muscle get pronatorTeres;

  Muscle get flexorFasciaeLatae;

  const FrontMuscles();
}

class _FrontMuscles extends FrontMuscles {
  final SvgPathReader _svgPathReader;

  @override
  Muscle get digastric =>
      _FrontMuscleLocator._('digastric', svgPathReader: _svgPathReader);

  @override
  Muscle get sternocleidomastoid => _FrontMuscleLocator._(
    'sternocleidomastoid',
    svgPathReader: _svgPathReader,
  );

  @override
  Muscle get scalene =>
      _FrontMuscleLocator._('scalene', svgPathReader: _svgPathReader);

  @override
  Muscle get trapezius =>
      _FrontMuscleLocator._('trapezius', svgPathReader: _svgPathReader);

  @override
  Muscle get deltoid =>
      _FrontMuscleLocator._('deltoid', svgPathReader: _svgPathReader);

  @override
  Muscle get biceps =>
      _FrontMuscleLocator._('biceps', svgPathReader: _svgPathReader);

  @override
  Muscle get latissimusDorsi =>
      _FrontMuscleLocator._('latissimus_dorsi', svgPathReader: _svgPathReader);

  @override
  Muscle get pectolarisMajor =>
      _FrontMuscleLocator._('pectoralis_major', svgPathReader: _svgPathReader);

  @override
  Muscle get rectusAbdominis =>
      _FrontMuscleLocator._('rectus_abdominis', svgPathReader: _svgPathReader);

  @override
  Muscle get externalAbdominalOblique => _FrontMuscleLocator._(
    'external_abdominal_oblique',
    svgPathReader: _svgPathReader,
  );

  @override
  Muscle get adductorLongus =>
      _FrontMuscleLocator._('adductor_longus', svgPathReader: _svgPathReader);

  @override
  Muscle get tensorFasciaeLatae => _FrontMuscleLocator._(
    'tensor_fasciae_latae',
    svgPathReader: _svgPathReader,
  );

  @override
  Muscle get pectineus =>
      _FrontMuscleLocator._('pectineus', svgPathReader: _svgPathReader);

  @override
  Muscle get iliopsoas =>
      _FrontMuscleLocator._('iliopsoas', svgPathReader: _svgPathReader);

  @override
  Muscle get gracilis =>
      _FrontMuscleLocator._('gracilis', svgPathReader: _svgPathReader);

  @override
  Muscle get rectusFemoris =>
      _FrontMuscleLocator._('rectus_femoris', svgPathReader: _svgPathReader);

  @override
  Muscle get vastusMedialis =>
      _FrontMuscleLocator._('vastus_medialis', svgPathReader: _svgPathReader);

  @override
  Muscle get vastusLateralis =>
      _FrontMuscleLocator._('vastus_lateralis', svgPathReader: _svgPathReader);

  @override
  Muscle get sartorius =>
      _FrontMuscleLocator._('sartorius', svgPathReader: _svgPathReader);

  @override
  Muscle get gastrocnemius =>
      _FrontMuscleLocator._('gastrocnemius', svgPathReader: _svgPathReader);

  @override
  Muscle get soleus =>
      _FrontMuscleLocator._('soleus', svgPathReader: _svgPathReader);

  @override
  Muscle get tibialisAnterior =>
      _FrontMuscleLocator._('tibialis_anterior', svgPathReader: _svgPathReader);

  @override
  Muscle get extensorDigitorumLongus => _FrontMuscleLocator._(
    'extensor_digitorum_longus',
    svgPathReader: _svgPathReader,
  );

  @override
  Muscle get peroneusLongus =>
      _FrontMuscleLocator._('peroneus_longus', svgPathReader: _svgPathReader);

  @override
  Muscle get brachialis =>
      _FrontMuscleLocator._('brachialis', svgPathReader: _svgPathReader);

  @override
  Muscle get brachioradialis =>
      _FrontMuscleLocator._('brachioradialis', svgPathReader: _svgPathReader);

  @override
  Muscle get pronatorTeres =>
      _FrontMuscleLocator._('pronator_teres', svgPathReader: _svgPathReader);

  @override
  Muscle get flexorFasciaeLatae => _FrontMuscleLocator._(
    'flexor_fasciae_latae',
    svgPathReader: _svgPathReader,
  );

  const _FrontMuscles._(this._svgPathReader);
}

class _FrontMuscleLocator extends Muscle {
  final SvgPathReader _svgPathReader;

  const _FrontMuscleLocator._(
    super.name, {
    required SvgPathReader svgPathReader,
  }) : _svgPathReader = svgPathReader;

  @override
  SvgPathReader getSvgPathReader() => _svgPathReader;
}
