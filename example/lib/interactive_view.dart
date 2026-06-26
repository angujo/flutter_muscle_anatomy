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
  Widget _zoomInBtn(BuildContext ctx, void Function() zoom) {
    return IconButton.filledTonal(
      onPressed: zoom,
      icon: const Icon(Icons.add),
      tooltip: MuscleAnatomyLocalization.translator('ui.zoom_in'),
    );
  }

  Widget _zoomOutBtn(BuildContext ctx, void Function() zoom) {
    return IconButton.filledTonal(
      onPressed: zoom,
      icon: const Icon(Icons.remove),
      tooltip: MuscleAnatomyLocalization.translator('ui.zoom_out'),
    );
  }

  Widget _flipViewBtn(BuildContext ctx, void Function([BodyView?])? flip) {
    return IconButton.filledTonal(
      onPressed: flip,
      icon: const Icon(Icons.flip_camera_android),
      tooltip: MuscleAnatomyLocalization.translator('ui.flip_view'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SelectionView(
        child: (gender, muscles, onMusclesChanged) {
          final anatomyFactory = Anatomy(gender.name);
          return MuscleInteractiveView(
            alignment: Alignment.centerLeft,
            zoomStep: 1.2,
            size: Size(200, 300),
            anatomy: anatomyFactory,
            highlightedMuscles: muscles.toSet(),
            onTap: (_, ms) => onMusclesChanged(ms),
            zoomIn: _zoomInBtn,
            zoomOut: _zoomOutBtn,
            flipView: _flipViewBtn,
          );
        },
      ),
    );
  }
}
