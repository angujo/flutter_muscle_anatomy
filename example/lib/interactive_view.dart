import 'package:example/selection_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_muscle_anatomy/body/body.dart';
import 'package:flutter_muscle_anatomy/core/core.dart';

class InteractiveView extends StatefulWidget {
  const InteractiveView({super.key});

  @override
  State<InteractiveView> createState() => _InteractiveViewState();
}

class _InteractiveViewState extends State<InteractiveView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SelectionView(
        child: (gender, muscles, onMusclesChanged) {
          final anatomyFactory = Anatomy(gender.name);
          return _InteractionWidget(
            anatomy: anatomyFactory,
            highlightedMuscles: muscles.toList(),
            onMusclesChanged: onMusclesChanged,
          );
        },
      ),
    );
  }
}

class _InteractionWidget extends StatefulWidget {
  final Anatomy anatomy;
  final List<(Muscle, MuscleSide)> highlightedMuscles;
  final void Function(Set<(Muscle, MuscleSide)>) onMusclesChanged;

  const _InteractionWidget({
    required this.anatomy,
    required this.highlightedMuscles,
    required this.onMusclesChanged,
  });

  @override
  State<_InteractionWidget> createState() => _InteractionWidgetState();
}

class _InteractionWidgetState extends State<_InteractionWidget> {
  final TransformationController _controller = TransformationController();
  final Set<(Muscle, MuscleSide)> _highlightedMuscles = {};
  late BodyView _view;
  late MuscleAnatomy _muscleAnatomy;

  @override
  void initState() {
    super.initState();
    _highlightedMuscles.addAll(widget.highlightedMuscles);
    _view = Muscle.dominantView(_highlightedMuscles.map((hm) => hm.$1).toSet());
    _updateAnatomy();
  }

  void _updateAnatomy() {
    _muscleAnatomy = widget.anatomy.byView(_view);
    for (var (muscle, side) in _highlightedMuscles) {
      _muscleAnatomy.highlight(muscle, position: side);
    }
  }

  @override
  void didUpdateWidget(covariant _InteractionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.highlightedMuscles != oldWidget.highlightedMuscles) {
      setState(() {
        _highlightedMuscles.clear();
        _highlightedMuscles.addAll(widget.highlightedMuscles);
        _updateAnatomy();
      });
    }
  }

  void _onTapped(TapUpDetails details) {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    final Size paintSize = renderBox?.size ?? const Size(200.0, 300.0);

    // 1. Convert from GestureDetector viewport to CustomPaint local coordinates
    final Matrix4 viewMatrix = _controller.value;
    final Offset scenePoint = MatrixUtils.transformPoint(
      Matrix4.inverted(viewMatrix),
      details.localPosition,
    );

    // 2. Convert from CustomPaint local coordinates to Anatomy model coordinates
    // This logic must match how AnatomyPainter transforms the paths
    final scaledSize = _muscleAnatomy.scaledSize(paintSize);
    final scale = scaledSize.width / _muscleAnatomy.dimension.width;
    final dx = (paintSize.width - scaledSize.width) / 2;
    final dy = (paintSize.height - scaledSize.height) / 2;

    final Offset modelPoint = Offset(
      (scenePoint.dx - dx) / scale,
      (scenePoint.dy - dy) / scale,
    );

    for (final muscleMember in _muscleAnatomy.getMuscleMembers()) {
      final key = (muscleMember.muscle, muscleMember.position);
      for (final path in muscleMember.paths) {
        if (path.contains(modelPoint)) {
          final newSelection = Set<(Muscle, MuscleSide)>.from(
            _highlightedMuscles,
          );
          if (newSelection.contains(key)) {
            newSelection.remove(key);
          } else {
            newSelection.add(key);
          }
          widget.onMusclesChanged(newSelection);
          return;
        }
      }
    }
  }

  void _zoom(double factor) {
    setState(() {
      final Matrix4 matrix = _controller.value.clone();

      // Zoom from the center of the viewport
      final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
      final Size size = renderBox?.size ?? const Size(200.0, 300.0);
      final Offset center = Offset(size.width / 2, size.height / 2);

      final Matrix4 transform = Matrix4.identity()
        ..translateByDouble(center.dx, center.dy, 0, 1.0)
        ..scaleByDouble(factor, factor, factor, 1.0)
        ..translateByDouble(-center.dx, -center.dy, 0, 1.0);

      _controller.value = transform * matrix;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTapUp: _onTapped,
              child: InteractiveViewer(
                transformationController: _controller,
                minScale: 0.5,
                maxScale: 10,
                child: CustomPaint(
                  size: const Size(200.0, 300.0),
                  painter: AnatomyPainter(anatomy: _muscleAnatomy),
                ),
              ),
            ),
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton.filledTonal(
                  onPressed: () => _zoom(1.2),
                  icon: const Icon(Icons.add),
                  tooltip: 'Zoom In',
                ),
                const SizedBox(height: 8),
                IconButton.filledTonal(
                  onPressed: () => _zoom(0.8),
                  icon: const Icon(Icons.remove),
                  tooltip: 'Zoom Out',
                ),
                const SizedBox(height: 8),
                IconButton.filledTonal(
                  onPressed: () {
                    setState(() {
                      _view = _view.inverse();
                      _updateAnatomy();
                    });
                  },
                  icon: const Icon(Icons.flip_camera_android),
                  tooltip: 'Flip View',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A custom painter that demonstrates how to use raw Path objects
/// from the MuscleAnatomy model for custom rendering.
class AnatomyPainter extends CustomPainter {
  final MuscleAnatomy anatomy;

  AnatomyPainter({required this.anatomy});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Calculate scale and offset to center the anatomy model into the available size
    final scaledSize = anatomy.scaledSize(size);
    final scale = scaledSize.width / anatomy.dimension.width;

    final dx = (size.width - scaledSize.width) / 2;
    final dy = (size.height - scaledSize.height) / 2;

    final matrix = Matrix4.identity()
      ..translateByDouble(dx, dy,0,1)
      ..scaleByDouble(scale,scale, scale, 1.0);

    // 2. Draw outline
    for (final path in anatomy.outlinePaths) {
      canvas.drawPath(path.transform(matrix.storage), anatomy.outlinePaint);
    }

    // 3. Draw all muscles
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

    // 4. Draw hair
    for (final path in anatomy.hairOutlinePaths) {
      canvas.drawPath(path.transform(matrix.storage), anatomy.hairFillPaint);
    }
  }

  @override
  bool shouldRepaint(covariant AnatomyPainter oldDelegate) {
    return true;
  }
}
