import 'package:flutter/material.dart';
import 'package:flutter_muscle_anatomy/core/app_enums.dart';
import 'package:flutter_muscle_anatomy/flutter_muscle_anatomy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Test Canvas drawings', () {
    testWidgets('Render Outline', (WidgetTester tester) async {
      final mf = MaleFront(muscles: [FrontMuscle.trapezius]);
      mf.highlight(
        FrontMuscle.biceps,
        position: MusclePosition.right,
        color: Colors.green,
      );
      mf.highlights([
        FrontMuscle.brachialis,
        FrontMuscle.extensorDigitorumLongus,
      ], color: Colors.blue);
      print(mf.toString());
    });
  });
}
