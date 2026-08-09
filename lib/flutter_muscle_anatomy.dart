/// A Flutter library for displaying and interacting with muscle anatomy models.
///
/// It supports both male and female body types, front and back views,
/// and allows for precise muscle highlighting.
library;

import 'core/assets/svg_assets.dart';
import 'core/core.dart';

export 'body/body.dart' show Male, Female, MuscleAnatomy, Anatomy, ViewScale, MuscleInteractiveView;
export 'core/core.dart'
    show
        Muscle,
        MuscleSide,
        MuscleDecoration,
        BodyView,
        MuscleLocalization,
        BodyViewLocalization,
        MusclePositionLocalization,
        GenderLocalization;

class FlutterMuscleAnatomy {
  static Future<void> initialize({MuscleAnatomyTranslator? translator}) async {
    await SvgAssets.initialize();
    if (translator != null) MuscleAnatomyLocalization.translator = translator;
  }
}
