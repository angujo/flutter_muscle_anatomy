part of 'core.dart';

/// An extension on the [Color] class to provide conversion to a hex string.
extension ColorHex on Color {
  /// Returns a hex string representation of the color.
  ///
  /// The format can be either RRGGBB or AARRGGBB, depending on the
  /// [includeAlpha] parameter.
  ///
  /// Example:
  /// ```dart
  /// Colors.red.toHex(); // '#FF0000'
  /// Colors.red.withAlpha(128).toHex(includeAlpha: true); // '#80FF0000'
  /// ```
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
