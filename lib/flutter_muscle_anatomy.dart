library;

export 'src/core/core.dart';
export 'src/body/body.dart';

import 'src/core/assets/svg_assets.dart';
import 'src/core/core.dart';

class FlutterMuscleAnatomy {
  static Future<void> initialize({MuscleAnatomyTranslator? translator}) async {
    await SvgAssets.initialize();
    if (translator != null) MuscleAnatomyLocalization.translator = translator;
  }
}
