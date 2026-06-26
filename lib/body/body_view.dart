part of 'body.dart';

const double _btnAllowance = 5;

/// A widget that provides an interactive view of muscle anatomy.
///
/// This widget allows users to visualize, zoom, and interact with a muscle anatomy model.
/// It supports highlighting specific muscles, zooming in/out, and flipping between
/// front and back views.
class MuscleInteractiveView extends StatefulWidget {
  /// The anatomy model to display.
  final Anatomy anatomy;

  /// The size of the canvas where the anatomy model is rendered.
  final Size size;

  /// The initial set of muscles to highlight, along with their side (left/right).
  final Set<(Muscle, MuscleSide)> highlightedMuscles;

  /// The multiplier factor for each zoom action. Defaults to 1.0.
  final double zoomStep;

  /// The minimum scale allowed for zooming. Defaults to 0.5.
  final double minScale;

  /// The maximum scale allowed for zooming. Defaults to 5.0.
  final double maxScale;

  /// Whether the anatomy model should fill the available [size] (true)
  /// or fit within it (false). Defaults to false.
  final bool filled;

  /// Callback function triggered when a muscle is tapped.
  ///
  /// Receives the tapped muscle/side and the current set of all highlighted muscles.
  final void Function((Muscle, MuscleSide), Set<(Muscle, MuscleSide)>)? onTap;

  /// A builder function for a custom zoom-in button.
  ///
  /// The provided callback should be called to trigger the zoom-in action.
  final Widget Function(BuildContext, void Function())? zoomIn;

  /// A builder function for a custom zoom-out button.
  ///
  /// The provided callback should be called to trigger the zoom-out action.
  final Widget Function(BuildContext, void Function())? zoomOut;

  /// A builder function for a custom flip-view button.
  ///
  /// The provided callback should be called to trigger the flip-view action.
  /// It optionally accepts a specific [BodyView] to switch to.
  final Widget Function(BuildContext, void Function([BodyView?])?)? flipView;

  /// The icon to use for the default zoom-in button.
  final IconData? zoomInIcon;

  /// The icon to use for the default zoom-out button.
  final IconData? zoomOutIcon;

  /// The icon to use for the default flip-view button.
  final IconData? flipViewIcon;

  /// The alignment of the action buttons relative to the anatomy model.
  /// Defaults to [Alignment.centerRight].
  final Alignment alignment;

  const MuscleInteractiveView({
    super.key,
    required this.anatomy,
    required this.highlightedMuscles,
    required this.size,
    this.zoomStep = 1.0,
    this.minScale = 0.5,
    this.maxScale = 5.0,
    this.filled = false,
    this.onTap,
    this.zoomIn,
    this.zoomOut,
    this.flipView,
    this.zoomInIcon,
    this.zoomOutIcon,
    this.flipViewIcon,
    this.alignment = Alignment.centerRight,
  });

  @override
  State<MuscleInteractiveView> createState() => _MuscleInteractiveViewState();
}

class _MuscleInteractiveViewState extends State<MuscleInteractiveView> {
  final TransformationController _controller = TransformationController();
  late MuscleAnatomy _muscleAnatomy;
  late ViewScale _viewScale;
  late BodyView _view;
  final Set<(Muscle, MuscleSide)> _highlightedMuscles = {};
  late Size _size;

  @override
  void initState() {
    super.initState();
    _size = widget.size;
    _view = Muscle.dominantView(
      widget.highlightedMuscles.map((hm) => hm.$1).toSet(),
    );
    _highlightedMuscles.addAll(widget.highlightedMuscles);
    _setAnatomy();
  }

  void _setAnatomy() {
    _muscleAnatomy = widget.anatomy.byView(_view);
    for (var (muscle, side) in _highlightedMuscles) {
      _muscleAnatomy.highlight(muscle, position: side);
    }
    _viewScale = _muscleAnatomy.getViewScale(_size, filled: widget.filled);
  }

  @override
  void didUpdateWidget(covariant MuscleInteractiveView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!(const SetEquality<(Muscle, MuscleSide)>().equals(
          widget.highlightedMuscles,
          oldWidget.highlightedMuscles,
        )) ||
        widget.anatomy != oldWidget.anatomy ||
        oldWidget.size != widget.size) {
      _size = widget.size;
      // Update the highlighted muscles
      _highlightedMuscles.clear();
      _highlightedMuscles.addAll(widget.highlightedMuscles);
      _setAnatomy();
    }
  }

  void _onDoubleTap() {
    _zoom(widget.zoomStep * 2);
  }

  void _onTapped(TapUpDetails details) {
    // 1. Convert from GestureDetector viewport to CustomPaint local coordinates
    final Matrix4 viewMatrix = _controller.value;
    final Offset scenePoint = MatrixUtils.transformPoint(
      Matrix4.inverted(viewMatrix),
      details.localPosition,
    );

    final Offset modelPoint = MatrixUtils.transformPoint(
      Matrix4.inverted(_viewScale.painterTransform),
      scenePoint,
    );

    for (final muscleMember in _muscleAnatomy.getMuscleMembers()) {
      final key = (muscleMember.muscle, muscleMember.position);
      for (final path in muscleMember.paths) {
        if (path.contains(modelPoint)) {
          if (_highlightedMuscles.contains(key)) {
            _highlightedMuscles.remove(key);
            _muscleAnatomy.dehighlight(key.$1, position: key.$2);
          } else {
            _highlightedMuscles.add(key);
            _muscleAnatomy.highlight(key.$1, position: key.$2);
          }
          widget.onTap?.call(key, _highlightedMuscles);
          return;
        }
      }
    }
  }

  void _zoom(double factor) {
    final matrix = _controller.value.clone();
    _controller.value =
        _viewScale.getZoomTransform(
          factor,
          matrix,
          minScale: widget.minScale,
          maxScale: widget.maxScale,
        ) *
        matrix;
  }

  Widget _build() {
    final painter = GestureDetector(
      onTapUp: _onTapped,
      onDoubleTap: _onDoubleTap,
      child: InteractiveViewer(
        transformationController: _controller,
        minScale: widget.minScale,
        maxScale: widget.maxScale,
        child: CustomPaint(
          size: _size,
          painter: _AnatomyPainter(
            anatomy: _muscleAnatomy,
            viewScale: _viewScale,
          ),
        ),
      ),
    );

    final buttons = _buttons();

    if (widget.alignment.y == 0) {
      // Horizontal bias (left/right)
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.alignment.x < 0) ...[
            buttons,
            const SizedBox(width: _btnAllowance),
          ],
          painter,
          if (widget.alignment.x > 0) ...[
            const SizedBox(width: _btnAllowance),
            buttons,
          ],
        ],
      );
    } else {
      // Vertical bias (top/bottom)
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.alignment.y < 0) ...[
            buttons,
            const SizedBox(height: _btnAllowance),
          ],
          painter,
          if (widget.alignment.y > 0) ...[
            const SizedBox(height: _btnAllowance),
            buttons,
          ],
        ],
      );
    }
  }

  Widget _buttons() {
    if (widget.alignment.y != 0) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [..._zoomInBtn(), ..._zoomOutBtn(), ..._flipViewBtn()],
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [..._zoomInBtn(), ..._zoomOutBtn(), ..._flipViewBtn()],
    );
  }

  List<Widget> _zoomInBtn() {
    return [
      if (widget.zoomIn != null)
        widget.zoomIn!(context, () => _zoom(widget.zoomStep)),
      if (widget.zoomIn == null && widget.zoomInIcon != null)
        IconButton.filledTonal(
          onPressed: () => _zoom(widget.zoomStep),
          icon: Icon(widget.zoomInIcon),
          tooltip: MuscleAnatomyLocalization.translator('ui.zoom_in'),
        ),
      if (widget.zoomIn != null || widget.zoomInIcon != null)
        const SizedBox(height: 5),
    ];
  }

  List<Widget> _zoomOutBtn() {
    return [
      if (widget.zoomOut != null)
        widget.zoomOut!(context, () => _zoom(1.0 / widget.zoomStep)),
      if (widget.zoomOut == null && widget.zoomOutIcon != null)
        IconButton.filledTonal(
          onPressed: () => _zoom(1.0 / widget.zoomStep),
          icon: Icon(widget.zoomOutIcon),
          tooltip: MuscleAnatomyLocalization.translator('ui.zoom_out'),
        ),
      if (widget.zoomOut != null || widget.zoomOutIcon != null)
        const SizedBox(height: 5),
    ];
  }

  List<Widget> _flipViewBtn() {
    return [
      if (widget.flipView != null)
        widget.flipView!(
          context,
          ([BodyView? v]) => setState(() {
            _view = v ?? _view.inverse();
            _setAnatomy();
          }),
        ),
      if (widget.flipView == null && widget.flipViewIcon != null)
        IconButton.filledTonal(
          onPressed: () => setState(() {
            _view = _view.inverse();
            _setAnatomy();
          }),
          icon: Icon(widget.flipViewIcon),
          tooltip: MuscleAnatomyLocalization.translator('ui.flip_view'),
        ),
      if (widget.flipView != null || widget.flipViewIcon != null)
        const SizedBox(height: 5),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return _build();
  }
}

class _AnatomyPainter extends CustomPainter {
  final MuscleAnatomy anatomy;
  final ViewScale viewScale;

  _AnatomyPainter({required this.anatomy, required this.viewScale});

  @override
  void paint(Canvas canvas, Size size) {
    final matrix = viewScale.painterTransform;

    // Draw outline
    for (final path in anatomy.outlinePaths) {
      canvas.drawPath(path.transform(matrix.storage), anatomy.outlinePaint);
    }

    // Draw all muscles
    for (final muscleMember in anatomy.getMuscleMembers()) {
      for (final path in muscleMember.paths) {
        canvas.drawPath(
          path.transform(matrix.storage),
          muscleMember.decoration.strokePaint(),
        );
        canvas.drawPath(
          path.transform(matrix.storage),
          muscleMember.decoration.fillPaint(),
        );
      }
    }

    // Draw hair
    for (final path in anatomy.hairPaths) {
      canvas.drawPath(path.transform(matrix.storage), anatomy.hairFillPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _AnatomyPainter oldDelegate) {
    return anatomy != oldDelegate.anatomy;
  }
}
