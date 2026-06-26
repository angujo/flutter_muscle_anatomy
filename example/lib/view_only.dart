import 'package:example/selection_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_muscle_anatomy/body/body.dart';
import 'package:flutter_muscle_anatomy/core/core.dart';
import 'package:flutter_svg/svg.dart';

enum Gender { male, female }

const Size viewSize = Size(200, 300);

class ViewOnly extends StatefulWidget {
  const ViewOnly({super.key});

  @override
  State<ViewOnly> createState() => _ViewOnlyState();
}

class _ViewOnlyState extends State<ViewOnly> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SelectionView(
        child: (gender, muscles, _) {
          final anatomyFactory = Anatomy(gender.name);
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _anatomyView(
                anatomyFactory.front(),
                BodyView.front.localizedName,
                muscles,
              ),
              _anatomyView(
                anatomyFactory.back(),
                BodyView.back.localizedName,
                muscles,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _anatomyView(
    MuscleAnatomy anatomy,
    String name,
    Set<(Muscle, MuscleSide)> selectedMuscles,
  ) {
    for (var m in selectedMuscles) {
      anatomy.highlight(m.$1, position: m.$2);
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.string(
          anatomy.toString(),
          width: viewSize.width,
          height: viewSize.height,
        ),
        Text('SVG: $name'),
        const SizedBox(height: 16),
        SizedBox.fromSize(
          size: viewSize,
          child: CustomPaint(painter: anatomy.customPainter(viewSize)),
        ),
        Text('Path Drawing: $name'),
      ],
    );
  }
}
