part of 'core.dart';

/// A callback type for translating keys.
typedef MuscleAnatomyTranslator = String Function(String key, {Map<String, String>? namedArgs});

/// Global configuration for muscle anatomy localization.
class MuscleAnatomyLocalization {
  /// The translator function used by the localization extensions.
  /// Defaults to returning the key itself.
  ///
  /// To use with `easy_localization`, set this to:
  /// ```dart
  /// MuscleAnatomyLocalization.translator = (key, {namedArgs}) => key.tr(namedArgs: namedArgs);
  /// ```
  static MuscleAnatomyTranslator translator = (key, {namedArgs}) => key;
}

/// Extension to provide localized names for [Muscle].
extension MuscleLocalization on Muscle {
  /// Returns the localized name of this muscle.
  String get localizedName => MuscleAnatomyLocalization.translator('muscles.$name');
}

/// Extension to provide localized names for [BodyView].
extension BodyViewLocalization on BodyView {
  /// Returns the localized name of this view.
  String get localizedName => MuscleAnatomyLocalization.translator('views.$name');
}

/// Extension to provide localized names for [MuscleSide].
extension MusclePositionLocalization on MuscleSide {
  /// Returns the localized name of this position.
  String get localizedName => MuscleAnatomyLocalization.translator('positions.$name');
}

/// Extension to provide localized names for genders.
extension GenderLocalization on String {
  /// Returns the localized name of the gender.
  String get localizedGender => MuscleAnatomyLocalization.translator('genders.$this');
}
