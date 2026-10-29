part of 'core.dart';

/// Represents the lateral position of a muscle on the body.
enum MuscleSide {
  /// Positioned on the left side of the body.
  left,

  /// Positioned on the right side of the body.
  right,

  /// Positioned on both sides of the body.
  both;

  /// Checks if the given [pathId] represents a positioned path (starts with left_ or right_).
  static bool isPositionedPath(String pathId) => MuscleSide.values
      .whereNot((p) => p == MuscleSide.both)
      .any((pos) => pathId.startsWith("${pos.name}_"));

  /// Returns an iterable of actual sides (left and right).
  static Iterable<MuscleSide> actual() =>
      MuscleSide.values.whereNot((p) => p == MuscleSide.both);

  /// Returns the inverse side.
  MuscleSide inverse() => switch (this) {
    left => right,
    right => left,
    _ => both,
  };
}

/// Represents the perspective or view of the human body.
enum BodyView {
  /// View from the front.
  front,

  /// View from the back.
  back,

  /// Both front and back views.
  both;

  /// Returns the inverse view.
  BodyView inverse() => switch (this) {
    front => back,
    back => front,
    _ => both,
  };
}
