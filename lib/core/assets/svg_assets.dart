library;

part 'male_front.dart';

part 'male_back.dart';

part 'female_back.dart';

part 'female_front.dart';

enum SvgAssetType { maleFront, maleBack, femaleBack, femaleFront }

String getSvgAssetString(SvgAssetType assetType) {
  return switch (assetType) {
    SvgAssetType.maleFront => _maleFront,
    SvgAssetType.maleBack => _maleBack,
    SvgAssetType.femaleBack => _femaleBack,
    SvgAssetType.femaleFront => _femaleFront,
  };
}
