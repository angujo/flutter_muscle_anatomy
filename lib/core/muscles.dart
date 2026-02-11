part of 'core.dart';

abstract class BodyMuscle {
  static BodyMuscles male = _BodyMuscles._(SvgPathReader.male());
  static BodyMuscles female = _BodyMuscles._(SvgPathReader.female());

  const BodyMuscle._();
}

abstract class BodyMuscles {
  List<Muscle> get front => all.where((m) => m.view == BodyView.front).toList();

  List<Muscle> get back => all.where((m) => m.view == BodyView.back).toList();

  List<Muscle> get all => [
    digastric,
    sternocleidomastoid,
    scalene,
    upperTrapezius,
    deltoid,
    biceps,
    latissimusDorsiF,
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
    gastrocnemiusF,
    soleusF,
    tibialisAnterior,
    extensorDigitorumLongus,
    peroneusLongus,
    brachialis,
    brachioradialis,
    pronatorTeres,
    flexorFasciaeLatae,
    triceps,
    levatorScapulae,
    trapezius,
    posteriorDeltoid,
    infraspinatus,
    teresMinor,
    teresMajor,
    anconeus,
    flexorCarpiUlnaris,
    extensorCarpiUlnaris,
    extensorDigitorum,
    externalOblique,
    latissimusDorsi,
    gluteusMedius,
    gluteusMaximus,
    iliotibialTact,
    bicepsFemoris,
    semitendinosus,
    adductorMagnus,
    semimebranosus,
    gastrocnemius,
    soleus,
  ];

  Muscle get digastric;

  Muscle get sternocleidomastoid;

  Muscle get scalene;

  Muscle get upperTrapezius;

  Muscle get deltoid;

  Muscle get biceps;

  Muscle get latissimusDorsiF;

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

  Muscle get gastrocnemiusF;

  Muscle get soleusF;

  Muscle get tibialisAnterior;

  Muscle get extensorDigitorumLongus;

  Muscle get peroneusLongus;

  Muscle get brachialis;

  Muscle get brachioradialis;

  Muscle get pronatorTeres;

  Muscle get flexorFasciaeLatae;

  Muscle get triceps;

  Muscle get levatorScapulae;

  Muscle get trapezius;

  Muscle get posteriorDeltoid;

  Muscle get infraspinatus;

  Muscle get teresMinor;

  Muscle get teresMajor;

  Muscle get anconeus;

  Muscle get flexorCarpiUlnaris;

  Muscle get extensorCarpiUlnaris;

  Muscle get extensorDigitorum;

  Muscle get externalOblique;

  Muscle get latissimusDorsi;

  Muscle get gluteusMedius;

  Muscle get gluteusMaximus;

  Muscle get iliotibialTact;

  Muscle get bicepsFemoris;

  Muscle get semitendinosus;

  Muscle get adductorMagnus;

  Muscle get semimebranosus;

  Muscle get gastrocnemius;

  Muscle get soleus;

  const BodyMuscles();
}

class _BodyMuscles extends BodyMuscles {
  final SvgPathReader _svgPathReader;

  //region Back
  @override
  Muscle get triceps => _MuscleLocator._(
    'triceps',
    svgPathReader: _svgPathReader,
    view: BodyView.back,
  );

  @override
  Muscle get levatorScapulae => _MuscleLocator._(
    'levator_scapulae',
    svgPathReader: _svgPathReader,
    view: BodyView.back,
  );

  @override
  Muscle get trapezius => _MuscleLocator._(
    'trapezius',
    svgPathReader: _svgPathReader,
    view: BodyView.back,
  );

  @override
  Muscle get posteriorDeltoid => _MuscleLocator._(
    'posterior_deltoid',
    svgPathReader: _svgPathReader,
    view: BodyView.back,
  );

  @override
  Muscle get infraspinatus => _MuscleLocator._(
    'infraspinatus',
    svgPathReader: _svgPathReader,
    view: BodyView.back,
  );

  @override
  Muscle get teresMinor => _MuscleLocator._(
    'teres_minor',
    svgPathReader: _svgPathReader,
    view: BodyView.back,
  );

  @override
  Muscle get teresMajor => _MuscleLocator._(
    'teres_major',
    svgPathReader: _svgPathReader,
    view: BodyView.back,
  );

  @override
  Muscle get anconeus => _MuscleLocator._(
    'anconeus',
    svgPathReader: _svgPathReader,
    view: BodyView.back,
  );

  @override
  Muscle get flexorCarpiUlnaris => _MuscleLocator._(
    'flexor_carpi_ulnaris',
    svgPathReader: _svgPathReader,
    view: BodyView.back,
  );

  @override
  Muscle get extensorCarpiUlnaris => _MuscleLocator._(
    'extensor_carpi_ulnaris',
    svgPathReader: _svgPathReader,
    view: BodyView.back,
  );

  @override
  Muscle get extensorDigitorum => _MuscleLocator._(
    'extensor_digitorum',
    svgPathReader: _svgPathReader,
    view: BodyView.back,
  );

  @override
  Muscle get externalOblique => _MuscleLocator._(
    'external_oblique',
    svgPathReader: _svgPathReader,
    view: BodyView.back,
  );

  @override
  Muscle get latissimusDorsi => _MuscleLocator._(
    'latissimus_dorsi',
    svgPathReader: _svgPathReader,
    view: BodyView.back,
  );

  @override
  Muscle get gluteusMedius => _MuscleLocator._(
    'gluteus_medius',
    svgPathReader: _svgPathReader,
    view: BodyView.back,
  );

  @override
  Muscle get gluteusMaximus => _MuscleLocator._(
    'gluteus_maximus',
    svgPathReader: _svgPathReader,
    view: BodyView.back,
  );

  @override
  Muscle get iliotibialTact => _MuscleLocator._(
    'iliotibial_tact',
    svgPathReader: _svgPathReader,
    view: BodyView.back,
  );

  @override
  Muscle get bicepsFemoris => _MuscleLocator._(
    'biceps_femoris',
    svgPathReader: _svgPathReader,
    view: BodyView.back,
  );

  @override
  Muscle get semitendinosus => _MuscleLocator._(
    'semitendinosus',
    svgPathReader: _svgPathReader,
    view: BodyView.back,
  );

  @override
  Muscle get adductorMagnus => _MuscleLocator._(
    'adductor_magnus',
    svgPathReader: _svgPathReader,
    view: BodyView.back,
  );

  @override
  Muscle get semimebranosus => _MuscleLocator._(
    'semimebranosus',
    svgPathReader: _svgPathReader,
    view: BodyView.back,
  );

  @override
  Muscle get gastrocnemius => _MuscleLocator._(
    'gastrocnemius',
    svgPathReader: _svgPathReader,
    view: BodyView.back,
  );

  @override
  Muscle get soleus => _MuscleLocator._(
    'soleus',
    svgPathReader: _svgPathReader,
    view: BodyView.back,
  );

  //endregion

  //region Front
  @override
  Muscle get digastric => _MuscleLocator._(
    'digastric',
    svgPathReader: _svgPathReader,
    view: BodyView.front,
  );

  @override
  Muscle get sternocleidomastoid => _MuscleLocator._(
    'sternocleidomastoid',
    svgPathReader: _svgPathReader,
    view: BodyView.front,
  );

  @override
  Muscle get scalene => _MuscleLocator._(
    'scalene',
    svgPathReader: _svgPathReader,
    view: BodyView.front,
  );

  @override
  Muscle get upperTrapezius => _MuscleLocator._(
    'upper_trapezius',
    svgPathReader: _svgPathReader,
    view: BodyView.front,
  );

  @override
  Muscle get deltoid => _MuscleLocator._(
    'deltoid',
    svgPathReader: _svgPathReader,
    view: BodyView.front,
  );

  @override
  Muscle get biceps => _MuscleLocator._(
    'biceps',
    svgPathReader: _svgPathReader,
    view: BodyView.front,
  );

  @override
  Muscle get latissimusDorsiF => _MuscleLocator._(
    'latissimus_dorsi_f',
    svgPathReader: _svgPathReader,
    view: BodyView.front,
  );

  @override
  Muscle get pectolarisMajor => _MuscleLocator._(
    'pectolaris_major',
    svgPathReader: _svgPathReader,
    view: BodyView.front,
  );

  @override
  Muscle get rectusAbdominis => _MuscleLocator._(
    'rectus_abdominis',
    svgPathReader: _svgPathReader,
    view: BodyView.front,
  );

  @override
  Muscle get externalAbdominalOblique => _MuscleLocator._(
    'external_abdominal_oblique',
    svgPathReader: _svgPathReader,
    view: BodyView.front,
  );

  @override
  Muscle get adductorLongus => _MuscleLocator._(
    'adductor_longus',
    svgPathReader: _svgPathReader,
    view: BodyView.front,
  );

  @override
  Muscle get tensorFasciaeLatae => _MuscleLocator._(
    'tensor_fasciae_latae',
    svgPathReader: _svgPathReader,
    view: BodyView.front,
  );

  @override
  Muscle get pectineus => _MuscleLocator._(
    'pectineus',
    svgPathReader: _svgPathReader,
    view: BodyView.front,
  );

  @override
  Muscle get iliopsoas => _MuscleLocator._(
    'iliopsoas',
    svgPathReader: _svgPathReader,
    view: BodyView.front,
  );

  @override
  Muscle get gracilis => _MuscleLocator._(
    'gracilis',
    svgPathReader: _svgPathReader,
    view: BodyView.front,
  );

  @override
  Muscle get rectusFemoris => _MuscleLocator._(
    'rectus_femoris',
    svgPathReader: _svgPathReader,
    view: BodyView.front,
  );

  @override
  Muscle get vastusMedialis => _MuscleLocator._(
    'vastus_medialis',
    svgPathReader: _svgPathReader,
    view: BodyView.front,
  );

  @override
  Muscle get vastusLateralis => _MuscleLocator._(
    'vastus_lateralis',
    svgPathReader: _svgPathReader,
    view: BodyView.front,
  );

  @override
  Muscle get sartorius => _MuscleLocator._(
    'sartorius',
    svgPathReader: _svgPathReader,
    view: BodyView.front,
  );

  @override
  Muscle get gastrocnemiusF => _MuscleLocator._(
    'gastrocnemius_f',
    svgPathReader: _svgPathReader,
    view: BodyView.front,
  );

  @override
  Muscle get soleusF => _MuscleLocator._(
    'soleus_f',
    svgPathReader: _svgPathReader,
    view: BodyView.front,
  );

  @override
  Muscle get tibialisAnterior => _MuscleLocator._(
    'tibialis_anterior',
    svgPathReader: _svgPathReader,
    view: BodyView.front,
  );

  @override
  Muscle get extensorDigitorumLongus => _MuscleLocator._(
    'extensor_digitorum_longus',
    svgPathReader: _svgPathReader,
    view: BodyView.front,
  );

  @override
  Muscle get peroneusLongus => _MuscleLocator._(
    'peroneus_longus',
    svgPathReader: _svgPathReader,
    view: BodyView.front,
  );

  @override
  Muscle get brachialis => _MuscleLocator._(
    'brachialis',
    svgPathReader: _svgPathReader,
    view: BodyView.front,
  );

  @override
  Muscle get brachioradialis => _MuscleLocator._(
    'brachioradialis',
    svgPathReader: _svgPathReader,
    view: BodyView.front,
  );

  @override
  Muscle get pronatorTeres => _MuscleLocator._(
    'pronator_teres',
    svgPathReader: _svgPathReader,
    view: BodyView.front,
  );

  @override
  Muscle get flexorFasciaeLatae => _MuscleLocator._(
    'flexor_fasciae_latae',
    svgPathReader: _svgPathReader,
    view: BodyView.front,
  );

  //endregion

  const _BodyMuscles._(this._svgPathReader);
}

class _MuscleLocator extends Muscle {
  final SvgPathReader _svgPathReader;

  const _MuscleLocator._(
    super.name, {
    required SvgPathReader svgPathReader,
    required super.view,
  }) : _svgPathReader = svgPathReader;

  @override
  SvgPathReader getSvgPathReader() => _svgPathReader;
}
