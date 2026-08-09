library;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_muscle_anatomy/core/utils.dart';

enum SvgAssetType { maleFront, maleBack, femaleBack, femaleFront }

class SvgAssets {
  static Map<SvgAssetType, String>? _svgAssets;

  static String getSvgAssetString(SvgAssetType assetType) {
    if (_svgAssets == null) throw FlutterError('SvgAssets not initialized');
    return _svgAssets![assetType]!;
  }

  static Future<void> initialize() async {
    if (_svgAssets != null) return;
    _svgAssets = {
      for (final assetType in SvgAssetType.values) assetType: await _loadAsset(assetType),
    };
  }

  static Future<String> _loadAsset(SvgAssetType assetType) async {
    final fileName = "${camelToSnake(assetType.name)}.svg";

    final paths = ['packages/flutter_muscle_anatomy/assets/$fileName', 'assets/$fileName'];
    for (final path in paths) {
      try {
        return await rootBundle.loadString(path);
      } catch (_) {
        // Continue to next path
      }
    }
    throw FlutterError(
      'SvgPathReader: Unable to load asset: "$fileName". '
      'Ensure the asset is included in your pubspec.yaml under flutter/assets.',
    );
  }
}
