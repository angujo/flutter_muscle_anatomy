<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# flutter_muscle_anatomy

[![Pub](https://img.shields.io/pub/v/flutter_muscle_anatomy.svg)](https://pub.dartlang.org/packages/flutter_muscle_anatomy)

<img src="images/app-screenshot1.png" alt="Mobile App View" width="200"/>
<img src="images/screenshot1.png" alt="Female Back View" width="200"/>
<img src="images/screenshot2.png" alt="Female Front View" width="200"/>
<img src="images/screenshot3.png" alt="Male Back View" width="200"/>
<img src="images/screenshot4.png" alt="Male Front View" width="200"/>

<!--
![Mobile App View](images/app-screenshot1.png)
![Female Back View](images/screenshot1.png)
![Female Front View](images/screenshot2.png)
![Male Back View](images/screenshot3.png)
![Male Front View](images/screenshot4.png)
-->

A flutter library for showing muscle anatomy.

## Features

Use this library in your flutter app to:

* Show the muscle anatomy of the body.
* Highlight certain muscles.
* Create silhouette or outline of the body
* Show the Front and Back views of body muscles
* Show either male or female muscle anatomy

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

This library works well with any library that displays image from SVG string.
It also provides Paths for canvas drawing.

## Usage

It can be used in either of the following methods:

1. SVG strings
2. Path drawing in canvas

### SVG strings (Recommended)

Generate SVG strings for usage with library like flutter_svg to render the image.

```dart
// Show the male front view
final Male male = Male.front();
// Single views
//  final Male male = Male.back(); 
//  final Male male = Male.both();
// Front and back views
//  final Male male = Male.frontBack(); // Starts with front view, then back
//  final Male male = Male.backFront(); // Starts with back view, then front
// Muscle-based views
//  final Male male = Male.byMuscles([Muscle.biceps, Muscle.triceps,...]);


// Highlight a single muscle
male.highlight
(
Muscle.biceps,
position: MusclePosition.right,
color: Colors.green,
);
// Highlight multiple muscles

male.highlights([
Muscle.brachialis,
Muscle.extensorDigitorumLongus,
],
color: Colors.blue,
);
// Render the image using SVGPicture
SvgPicture.string(male.toString());
```

Female muscle anatomy has same syntax as Male with exception of default hair color.

```dart

final Female female = Female.front(hairColor: Colors.grey);
```

### Path drawing in canvas

Draw on a canvas using provided paths.

```dart
class MyCustomPainter extends CustomPainter {
  MyCustomPainter();

  @override
  void paint(Canvas canvas, Size size) {
    Female female = Female.front();
    // If more than 1 view e.g. frontBack, 2 outlines are available.
    final outlinePath = female.outlinePaths.first;
    // Hair Outline is only applicable for Female
    final hairOutlinePaths = female.hairOutlinePaths;
    // Get paths for specific muscle
    final highlightedMusclePaths = female.getMusclePaths(
        Muscle.biceps, position: MusclePosition.right);
    // Get paths for all muscles
    final musclesPath = female.getAllMusclePaths();

    final bounds = outlinePath.getBounds();

    final scaleX = size.width / bounds.width;
    final scaleY = size.height / bounds.height;
    final scale = math.min(scaleX, scaleY);

    final dx = (size.width - bounds.width * scale) / 2 - bounds.left * scale;
    final dy = (size.height - bounds.height * scale) / 2 - bounds.top * scale;

    final matrix = Matrix4.identity()
      ..translate(dx, dy)
      ..scale(scale);

    final transformedPath = outlinePath.transform(matrix.storage);

    canvas.save();

    // All muscles
    for (final path in musclesPath) {
      canvas.drawPath(
        path.transform(matrix.storage),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5
          ..color = Colors.grey,
      );
    }
    // Highlight the specific muscle
    for (final path in highlightedMusclePaths) {
      canvas.drawPath(
        path.transform(matrix.storage),
        Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.red,
      );
    }

    // Hair outline
    for (final path in hairOutlinePaths) {
      canvas.drawPath(
        path.transform(matrix.storage),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.3
          ..color = Colors.grey,
      );

      canvas.drawPath(
        path.transform(matrix.storage),
        Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.grey,
      );
    }
    // Outline
    canvas.drawPath(
      transformedPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5
        ..color = Colors.black26,
    );
    canvas.restore();
  }
}

```

## Contributing

Contributions are always welcome.

Check out the *source-\*.svg* files under assets that were designed using Inkspace.

Ensure you export as plain SVG to *female_\*.svg* and *male_\*.svg* files accordingly.

Left and right muscles added should have *left_* and *right_* prefixes respectively, and the muscle
should be added to the Muscle enum.

Grouping muscles might not provide desired output, as group attributes such as *transform* are not
handled currently.

## Additional information

Give us a like.
