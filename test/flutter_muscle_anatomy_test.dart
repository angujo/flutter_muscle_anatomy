import 'package:flutter/material.dart';
import 'package:flutter_muscle_anatomy/flutter_muscle_anatomy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Test Canvas drawings', () {
    testWidgets('Render Front Male', (WidgetTester tester) async {
      final mf = Male.front();
      mf.highlight(
        Muscle.biceps,
        position: MuscleSide.right,
        color: Colors.green,
      );
      mf.highlights([
        Muscle.brachialis,
        Muscle.extensorDigitorumLongus,
      ], color: Colors.blue);

      final svg = mf.toString();
      expect(svg, contains('<svg'));
      expect(svg, contains('id="right_biceps_front"'));
      expect(svg, contains('id="brachialis_front"'));
      expect(svg, contains('id="extensorDigitorumLongus_front"'));
      expect(svg, contains('fill:#4CAF50')); // Colors.green
      expect(svg, contains('fill:#2196F3')); // Colors.blue
    });

    testWidgets('Render Back Male', (WidgetTester tester) async {
      final mf = Male.back();
      mf.highlight(
        Muscle.triceps,
        position: MuscleSide.right,
        color: Colors.green,
      );
      mf.highlights([
        Muscle.trapezius,
        Muscle.extensorDigitorumLongus,
      ], color: Colors.blue);

      final svg = mf.toString();
      expect(svg, contains('<svg'));
      expect(svg, contains('id="right_triceps_back"'));
      expect(svg, contains('id="trapezius_back"'));
      expect(svg, contains('fill:#4CAF50')); // Colors.green
    });

    testWidgets('Render Both Male', (WidgetTester tester) async {
      final mf = Male.backFront();
      mf.highlight(
        Muscle.triceps,
        position: MuscleSide.right,
        color: Colors.green,
      );
      mf.highlights([
        Muscle.soleus,
      ], color: Colors.blue);

      final svg = mf.toString();
      expect(svg, contains('id="skeletal_0"'));
      expect(svg, contains('id="skeletal_1"'));
      expect(svg, contains('id="right_triceps_back"'));
      expect(svg, contains('id="soleus_front"'));
    });

    testWidgets('Render Front Female', (WidgetTester tester) async {
      final mf = Female.front();
      mf.highlight(
        Muscle.biceps,
        position: MuscleSide.right,
        color: Colors.green,
      );

      final svg = mf.toString();
      expect(svg, contains('<svg'));
      expect(svg, contains('id="right_biceps_front"'));
    });

    testWidgets('Render ByMuscles Female', (WidgetTester tester) async {
      final mf = Female.byMuscles(Muscle.values);
      final svg = mf.toString();
      expect(svg, contains('id="skeletal_0"'));
      expect(svg, contains('id="skeletal_1"'));
    });
  });

  group('Localization', () {
    test('Default translator returns key', () {
      expect(Muscle.biceps.localizedName, equals('muscles.biceps'));
      expect(BodyView.front.localizedName, equals('views.front'));
      expect(MuscleSide.left.localizedName, equals('positions.left'));
      expect('male'.localizedGender, equals('genders.male'));
    });

    test('Custom translator works', () {
      MuscleAnatomyLocalization.translator = (key, {namedArgs}) {
        if (key == 'muscles.biceps') return 'Biceps Muscle';
        if (key == 'genders.female') return 'Woman';
        return key;
      };

      expect(Muscle.biceps.localizedName, equals('Biceps Muscle'));
      expect('female'.localizedGender, equals('Woman'));

      // Reset translator
      MuscleAnatomyLocalization.translator = (key, {namedArgs}) => key;
    });
  });

  group('Anatomy Parsing', () {
    test('Invalid gender throws ArgumentError', () {
      expect(() => Anatomy('invalid'), throwsArgumentError);
    });

    test('Valid gender names work', () {
      expect(Anatomy('male').front(), isNotNull);
      expect(Anatomy('M').front(), isNotNull);
      expect(Anatomy('female').front(), isNotNull);
      expect(Anatomy('f').front(), isNotNull);
    });
  });
}
