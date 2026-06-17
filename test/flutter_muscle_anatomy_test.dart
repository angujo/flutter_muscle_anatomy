import 'package:flutter/material.dart';
import 'package:flutter_muscle_anatomy/flutter_muscle_anatomy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Test Canvas drawings', () {
    testWidgets('Render Front Male', (WidgetTester tester) async {
      final mf = Male.front();
      mf.highlight(
        Muscle.biceps,
        position: MusclePosition.right,
        color: Colors.green,
      );
      mf.highlights([
        Muscle.brachialis,
        Muscle.extensorDigitorumLongus,
      ], color: Colors.blue);
      debugPrint(mf.toString());
    });

    testWidgets('Render Back Male', (WidgetTester tester) async {
      final mf = Male.back();
      mf.highlight(
        Muscle.triceps,
        position: MusclePosition.right,
        color: Colors.green,
      );
      mf.highlights([
        Muscle.trapezius,
        Muscle.extensorDigitorumLongus,
      ], color: Colors.blue);
      debugPrint(mf.toString());
    });

    testWidgets('Render Both Male', (WidgetTester tester) async {
      final mf = Male.backFront();
      mf.highlight(
        Muscle.triceps,
        position: MusclePosition.right,
        color: Colors.green,
      );
      mf.highlights([
        // Muscle.trapezius,
        // Muscle.extensorDigitorumLongus,
        // Muscle.biceps
        Muscle.soleus,
      ], color: Colors.blue);
      debugPrint(mf.toString());
    });

    testWidgets('Render Front Female', (WidgetTester tester) async {
      final mf = Female.front();
      mf.highlight(
        Muscle.biceps,
        position: MusclePosition.right,
        color: Colors.green,
      );
      mf.highlights([
        Muscle.brachialis,
        Muscle.extensorDigitorumLongus,
      ], color: Colors.blue);
      debugPrint(mf.toString());
    });

    testWidgets('Render Back Female', (WidgetTester tester) async {
      final mf = Female.back();
      mf.highlight(
        Muscle.triceps,
        position: MusclePosition.right,
        color: Colors.green,
      );
      mf.highlights([
        Muscle.trapezius,
        Muscle.extensorDigitorumLongus,
      ], color: Colors.blue);
      debugPrint(mf.toString());
    });

    testWidgets('Render Both Female', (WidgetTester tester) async {
      final mf = Female.backFront();
      mf.highlight(
        Muscle.triceps,
        position: MusclePosition.right,
        color: Colors.green,
      );
      mf.highlights([
        // Muscle.trapezius,
        // Muscle.extensorDigitorumLongus,
        // Muscle.biceps
        Muscle.soleus,
      ], color: Colors.blue);
      debugPrint(mf.toString());
    });
    testWidgets('Render ByMuscles Female', (WidgetTester tester) async {
      final mf = Female.byMuscles(Muscle.values);
      debugPrint(mf.toString());
    });
  });
}
