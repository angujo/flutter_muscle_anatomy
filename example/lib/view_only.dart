
import 'package:example/selection_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_muscle_anatomy/body/body.dart';
import 'package:flutter_muscle_anatomy/core/core.dart';
import 'package:flutter_svg/svg.dart';

enum Gender { male, female }

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
        SvgPicture.string(anatomy.toString(), width: 200, height: 300),
        Text('SVG: $name'),
        const SizedBox(height: 16),
        SizedBox(
          width: 200,
          height: 300,
          child: CustomPaint(painter: AnatomyPainter(anatomy: anatomy)),
        ),
        Text('Path Drawing: $name'),
      ],
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
  bool shouldRepaint(AnatomyPainter oldDelegate) {
    return oldDelegate.anatomy != anatomy;
  }
}
