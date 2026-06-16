part of 'core.dart';

/// Extension to provide localized names using easy_localization.
extension MuscleLocalization on Muscle {
  /// Returns the localized name of this muscle.
  String get localizedName => 'muscles.$name'.tr();
}

/// Extension to provide localized names for [BodyView].
extension BodyViewLocalization on BodyView {
  /// Returns the localized name of this view.
  String get localizedName => 'views.$name'.tr();
}

/// Extension to provide localized names for [MusclePosition].
extension MusclePositionLocalization on MusclePosition {
  /// Returns the localized name of this position.
  String get localizedName => 'positions.$name'.tr();
}

/// Extension to provide localized names for genders.
extension GenderLocalization on String {
  /// Returns the localized name of the gender.
  String get localizedGender => 'genders.$this'.tr();
}
