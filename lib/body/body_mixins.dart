part of 'body.dart';

/// Represents the gender types supported by the body anatomy model.
enum _GenderType {
  /// Male body type.
  male,

  /// Female body type.
  female;

  /// Converts a [gender] string into a [_GenderType].
  ///
  /// Matches the first character of the string (case-insensitive):
  /// - 'm' -> [male]
  /// - 'f' -> [female]
  ///
  /// It also supports matching against localized names.
  ///
  /// Throws an [ArgumentError] if [gender] is empty or does not start with 'm' or 'f'.
  static _GenderType fromName(String gender) {
    String g = gender.trim().toLowerCase();
    if (g.isEmpty) {
      throw ArgumentError(
        MuscleAnatomyLocalization.translator(
          'errors.invalid_gender',
          namedArgs: {'gender': gender, 'expected': names().join(', ')},
        ),
      );
    }

    for (final type in values) {
      if (type.name.toLowerCase() == g ||
          type.name.substring(0, 1).toLowerCase() == g ||
          type.name.localizedGender.toLowerCase() == g) {
        return type;
      }
    }

    return switch (g.substring(0, 1)) {
      'm' => male,
      'f' => female,
      _ => throw ArgumentError(
        MuscleAnatomyLocalization.translator(
          'errors.invalid_gender',
          namedArgs: {'gender': gender, 'expected': names().join(', ')},
        ),
      ),
    };
  }

  /// Returns a list of short and full names for all available genders, including localized ones.
  static List<String> names() => values
      .expand((e) => [e.name.substring(0, 1), e.name, e.name.localizedGender])
      .toSet()
      .toList();
}

/// Interface for classes that support highlighting muscles on the body.
abstract class _IMuscleHighlights {
  /// Highlights a specific [muscle] in the view.
  ///
  /// [position] specifies which side to highlight (defaults to MusclePosition.both).
  /// [color] and [opacity] can override the default highlight styling.
  void highlight(
    Muscle muscle, {
    MuscleSide position,
    Color? color,
    double? opacity,
  });

  /// Highlights a collection of [muscles] in the view.
  ///
  /// [position] specifies which side to highlight (defaults to MusclePosition.both).
  /// [color] and [opacity] can override the default highlight styling.
  void highlights(
    Iterable<Muscle> muscles, {
    MuscleSide position,
    Color? color,
    double? opacity,
  });

  void dehighlight(Muscle muscle, {MuscleSide position = MuscleSide.both});
}

/// A mixin that provides functionality for building an [SvgFileWriter] and
/// managing the SVG generation process.
mixin _BuildsSvgWriter {
  /// The writer used to generate SVG content.
  late SvgFileWriter _svgFileWriter;
  ViewScale? _viewScale;

  /// Tracks whether the SVG has already been built.
  bool _built = false;

  /// Returns the root [SvgElement]s that compose the body's SVG structure.
  ///
  /// This must be implemented by the class using the mixin.
  List<SvgElement> _getRootBuilds();

  /// The physical dimensions (width and height) of the SVG view box.
  Size get dimension;

  /// Forces a rebuild of the SVG content by resetting the [_built] flag and calling [build].
  void rebuild() {
    _built = false;
    build();
  }

  /// Returns the string representation of the generated SVG.
  ///
  /// Automatically calls [build] if it hasn't been called yet.
  @override
  String toString() {
    build();
    return _svgFileWriter.toString();
  }

  /// Builds the SVG document if it hasn't been built yet.
  ///
  /// Initializes the [_svgFileWriter] with the current [dimension],
  /// adds the root elements from [_getRootBuilds], and finalizes the build.
  void build() {
    if (_built) return;
    _svgFileWriter = SvgFileWriter(dimension);
    final build = _getRootBuilds();
    _svgFileWriter.addElements(build);
    _svgFileWriter.build();
    _built = true;
  }

  /// Computes and returns a [ViewScale] for mapping the anatomy model to a target [size].
  ///
  /// The [ViewScale] handles the math for scaling (fit vs fill) and centering
  /// the model within the provided [size].
  ///
  /// [size] is the target canvas or widget size.
  /// [filled] determines if the model should cover the entire [size] (true)
  /// or be contained within it (false).
  ViewScale getViewScale(Size size, {bool filled = false}) {
    _viewScale ??= _ViewScale._(
      dimension: dimension,
      size: size,
      filled: filled,
    );
    return _viewScale!;
  }
}

/// Interface representing the scaling and positioning logic for a view.
///
/// It provides scale factors, offsets, and transforms to map between
/// the SVG dimension and the actual render size.
abstract interface class ViewScale {
  /// Returns the width scale factor between the render size and the SVG dimension.
  double get widthScale;

  /// Returns the height scale factor between the render size and the SVG dimension.
  double get heightScale;

  /// Returns the effective scale factor, depending on whether the view should
  /// be filled or fitted.
  double get scale;

  /// Returns the size of the SVG content after scaling.
  Size get scaleSize;

  /// Returns the horizontal offset to center the scaled content.
  double get dx;

  /// Returns the vertical offset to center the scaled content.
  double get dy;

  /// Returns the center point of the render view.
  Offset get center;

  /// Returns a transformation matrix that translates and scales the content
  /// to fit and center within the render view.
  Matrix4 get painterTransform;

  /// Returns a transformation matrix for zooming the view by a given [factor]
  /// relative to the center.
  Matrix4 getZoomTransform(
    double factor,
    Matrix4 controllerMatrix, {
    double? minScale,
    double? maxScale,
  });
}

final class _ViewScale implements ViewScale {
  /// This is the dimension of the SVG view box.
  final Size _dimension;

  /// This is the size of the Render view.
  final Size _size;

  /// This is a flag to indicate whether the size should be filled or not.
  final bool _filled;

  @override
  double get widthScale => _size.width / _dimension.width;

  @override
  double get heightScale => _size.height / _dimension.height;

  @override
  double get scale => _filled
      ? math.max(widthScale, heightScale)
      : math.min(widthScale, heightScale);

  @override
  Size get scaleSize =>
      Size(_dimension.width * scale, _dimension.height * scale);

  @override
  double get dx => (_size.width - scaleSize.width) / 2;

  @override
  double get dy => (_size.height - scaleSize.height) / 2;

  @override
  Offset get center => Offset(_size.width / 2, _size.height / 2);

  @override
  Matrix4 get painterTransform => Matrix4.identity()
    ..translateByDouble(dx, dy, 0, 1)
    ..scaleByDouble(scale, scale, 1.0, 1.0);

  @override
  Matrix4 getZoomTransform(
    double factor,
    Matrix4 controllerMatrix, {
    double? minScale,
    double? maxScale,
  }) {
    final currentScale = controllerMatrix.getMaxScaleOnAxis();

    if (currentScale == 0) {
      return Matrix4.identity();
    }

    double targetScale = currentScale * factor;

    if (minScale != null) {
      targetScale = targetScale < minScale ? minScale : targetScale;
    }

    if (maxScale != null) {
      targetScale = targetScale > maxScale ? maxScale : targetScale;
    }

    final actualFactor = targetScale / currentScale;

    if (actualFactor == 1.0) {
      return Matrix4.identity();
    }

    return Matrix4.identity()
      ..translateByDouble(center.dx, center.dy, 0, 1)
      ..scaleByDouble(actualFactor, actualFactor, 1, 1)
      ..translateByDouble(-center.dx, -center.dy, 0, 1);
  }

  const _ViewScale._({
    required Size dimension,
    required Size size,
    required bool filled,
  }) : _dimension = dimension,
       _size = size,
       _filled = filled;
}

/// A mixin that manages styling properties for strokes and default fills
/// of the body parts.
mixin _Decorates {
  MuscleDecoration _defDecoration = MuscleDecoration();
  MuscleDecoration _defHighlightDecoration = MuscleDecoration(
    fillColor: Colors.red,
    fillOpacity: 0.5,
  );

  /// @deprecated Use [setDefaultStroke] instead.
  @Deprecated('Use setDefaultStroke instead.')
  void setStroke({required Color color, required double width}) =>
      setDefaultStroke(color: color, width: width);

  /// Sets the default stroke [color] and [width].
  void setDefaultStroke({required Color color, required double width}) {
    _defDecoration = _defDecoration.copyWith(
      strokeColor: color,
      strokeWidth: width,
    );
  }

  /// @deprecated Use [setDefaultFill] instead.
  @Deprecated('Use setDefaultFill instead.')
  void setFill({required Color color, required double opacity}) =>
      setDefaultFill(color: color, opacity: opacity);

  /// Sets the default fill [color] and [opacity].
  void setDefaultFill({required Color color, required double opacity}) {
    _defDecoration = _defDecoration.copyWith(
      fillColor: color,
      fillOpacity: opacity,
    );
  }

  /// Sets the default highlight [color] and [opacity] to be used when not explicitly specified in [highlight].
  void setDefaultHighlight({required Color color, required double opacity}) {
    _defHighlightDecoration = _defHighlightDecoration.copyWith(
      fillColor: color,
      fillOpacity: opacity,
    );
  }
}

/// A mixin that implements the [_IMuscleHighlights] interface to track
/// and manage muscle highlighting state.
mixin _MusclesHighlights on _Decorates {
  /// The specific [BodyView] (e.g., front, back) this highlighting logic is applied to.
  BodyView get _view;

  /// Internal storage for tracked highlights, keyed by muscle and its position.
  final Map<MuscleInstance, MuscleDecoration> _highlights = {};

  /// Highlights a [muscle] at a specific [position].
  ///
  /// If [position] is MusclePosition.both, it removes any individual left/right highlights for that muscle.
  /// If [position] is left or right and a "both" highlight exists, it replaces the "both" highlight with the other side's highlight.
  void highlight(
    Muscle muscle, {
    MuscleSide position = MuscleSide.both,
    Color? color,
    double? opacity,
  }) {
    if (!muscle.isForView(_view)) return;
    final decoration = _defHighlightDecoration.copyWith(
      fillColor: color,
      fillOpacity: opacity,
    );
    if (position == MuscleSide.both) {
      for (final pst in MuscleSide.actual()) {
        _highlights.putIfAbsent(
          MuscleInstance(muscle: muscle, position: pst),
          () => decoration,
        );
      }
    } else {
      _highlights.putIfAbsent(
        MuscleInstance(muscle: muscle, position: position),
        () => decoration,
      );
    }
  }

  void dehighlight(Muscle muscle, {MuscleSide position = MuscleSide.both}) {
    if (!muscle.isForView(_view)) return;
    if (position == MuscleSide.both) {
      _highlights.removeWhere((key, value) => key.muscle == muscle);
    } else {
      _highlights.removeWhere(
        (key, value) => key.muscle == muscle && key.position == position,
      );
    }
  }

  bool _instanceHighlighted(MuscleInstance instance) =>
      isHighlighted(instance.muscle, position: instance.position);

  MuscleDecoration? _instanceDecoration(MuscleInstance instance) {
    if (!_instanceHighlighted(instance)) return null;
    if (MuscleSide.both == instance.position) {
      return MuscleSide.actual()
          .map(
            (ms) => _instanceDecoration(
              MuscleInstance(muscle: instance.muscle, position: ms),
            ),
          )
          .firstOrNull;
    }
    return _highlights[instance];
  }

  bool isHighlighted(Muscle muscle, {MuscleSide position = MuscleSide.both}) {
    if (!muscle.isForView(_view)) return false;
    final psts = position == MuscleSide.both ? MuscleSide.actual() : [position];
    return psts.any(
      (pst) => _highlights.containsKey(
        MuscleInstance(muscle: muscle, position: pst),
      ),
    );
  }

  /// Highlights multiple [muscles] with an optional [position], [color], and [opacity].
  void highlights(
    Iterable<Muscle> muscles, {
    MuscleSide position = MuscleSide.both,
    Color? color,
    double? opacity,
  }) {
    for (final muscle in muscles) {
      highlight(muscle, position: position, color: color, opacity: opacity);
    }
  }

  MuscleDecoration _decoration(MuscleInstance muscleInst) {
    if (MuscleSide.both == muscleInst.position) {
      return MuscleSide.actual()
          .map(
            (ms) => _decoration(
              MuscleInstance(muscle: muscleInst.muscle, position: ms),
            ),
          )
          .first;
    }
    return _defDecoration.copyFrom(_instanceDecoration(muscleInst));
  }
}
