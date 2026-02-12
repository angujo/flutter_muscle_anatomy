import 'package:flutter/material.dart';
import 'package:flutter_muscle_anatomy/core/core.dart';
import 'package:flutter_muscle_anatomy/core/utils.dart';
import 'package:flutter_muscle_anatomy/flutter_muscle_anatomy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Test Canvas drawings', () {
    testWidgets('Translate Path', (WidgetTester tester) async {
      final path =
          'm 105.56336,43.170242 0.22397,1.086198 0.29864,0.561827 0.0746,1.048743 0.0373,0.749102 -0.18665,1.273474 0.0746,1.498204 -0.0746,1.610571 0.14931,0.973833 0.22398,1.048743 0.0373,0.786557 0.0746,0.898923 0.14932,0.599282 0.0373,0.936378 0.14932,0.861467 v 0.749103 l 0.26131,0.412006 -0.0373,0.861468 0.22398,0.262186 -0.0373,0.524371 -0.37329,-0.29964 -0.22397,-0.412007 -0.0746,-0.898923 -0.22397,-0.412006 -0.22398,-1.048744 -0.14932,-0.412006 -0.0746,-0.711646 -0.18665,-0.449462 -0.11199,-0.674192 -0.26131,-0.749103 -0.14931,-0.936378 -0.2613,-0.786556 -0.14932,-0.898923 -0.14931,-0.412007 -0.18665,-0.449461 -0.18665,-1.722935 0.11199,-1.872756 0.18665,-0.374552 0.2613,-0.449461 0.29863,-0.449461 -0.11198,-0.786557 0.11198,-0.561827 0.18665,-0.524372 z';
      final translated = translatePath(path, -10);
      print(path);
      print(translated);
    });
    testWidgets('Render Front Male', (WidgetTester tester) async {
      final mf = Male.front();
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
      final mf = Male.back();
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
