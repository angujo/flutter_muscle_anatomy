import 'package:flutter/material.dart';
import 'package:flutter_muscle_anatomy/core/core.dart';
import 'package:flutter_muscle_anatomy/flutter_muscle_anatomy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Test Canvas drawings', () {
    testWidgets('Render Front Male', (WidgetTester tester) async {
      final mf = Male.front(muscles: [Male.muscles.trapezius]);
      mf.highlight(
        Male.muscles.biceps,
        position: MusclePosition.right,
        color: Colors.green,
      );
      mf.highlights([
        Male.muscles.brachialis,
        Male.muscles.extensorDigitorumLongus,
      ], color: Colors.blue);
      print(mf.toString());
    });
    testWidgets('Render Back Male', (WidgetTester tester) async {
      final mf = Male.back(muscles: [Male.muscles.trapezius]);
      mf.highlight(
        Male.muscles.biceps,
        position: MusclePosition.right,
        color: Colors.green,
      );
      mf.highlights([
        Male.muscles.brachialis,
        Male.muscles.extensorDigitorumLongus,
      ], color: Colors.blue);
      print(mf.toString());
    });
  });
}
