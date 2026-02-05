import 'package:flutter/material.dart';
import 'package:flutter_muscle_anatomy/core/core.dart';
import 'package:flutter_muscle_anatomy/flutter_muscle_anatomy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Test Canvas drawings', () {
    testWidgets('Render Outline', (WidgetTester tester) async {
      final mf = MaleFront(muscles: [MaleFront.muscles.trapezius]);
      mf.highlight(
        MaleFront.muscles.biceps,
        position: MusclePosition.right,
        color: Colors.green,
      );
      mf.highlights([
        MaleFront.muscles.brachialis,
        MaleFront.muscles.extensorDigitorumLongus,
      ], color: Colors.blue);
      print(mf.toString());
    });
  });
}
