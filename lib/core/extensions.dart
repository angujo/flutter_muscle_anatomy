part of 'core.dart';

extension ColorHex on Color {
  /// Returns hex string in AARRGGBB or RRGGBB format
  String toHex({bool includeAlpha = false}) {
    int toByte(double v) => (v * 255.0).round().clamp(0, 255);

    final aV = toByte(a).toRadixString(16).padLeft(2, '0');
    final rV = toByte(r).toRadixString(16).padLeft(2, '0');
    final gV = toByte(g).toRadixString(16).padLeft(2, '0');
    final bV = toByte(b).toRadixString(16).padLeft(2, '0');

    return includeAlpha
        ? '#$aV$rV$gV$bV'.toUpperCase()
        : '#$rV$gV$bV'.toUpperCase();
  }
}
