# flutter_muscle_anatomy

[![Pub](https://img.shields.io/pub/v/flutter_muscle_anatomy.svg)](https://pub.dartlang.org/packages/flutter_muscle_anatomy)

A Flutter library for displaying and interacting with muscle anatomy models. It supports both male and female body types, front and back views, and allows for precise muscle highlighting.

<div align="center">
  <img src="images/screen-record-short-fma.gif" alt="Watch the Preview Video" width="135"/>
</div>
<div align="center">
  <img src="images/app-screenshot1.png" alt="Mobile App View" width="135"/>
  <img src="images/screenshot1.png" alt="Female Back View" width="153"/>
  <img src="images/screenshot2.png" alt="Female Front View" width="151"/>
  <img src="images/screenshot3.png" alt="Male Back View" width="144"/>
  <img src="images/screenshot4.png" alt="Male Front View" width="128"/>
</div>

## Features

* **Anatomical Models**: High-quality SVG-based male and female muscle models.
* **Front & Back Views**: Display front, back, or both views simultaneously.
* **Muscle Highlighting**: Highlight specific muscles with custom colors and opacity.
* **Dynamic Gender Support**: Easily switch between male and female models at runtime.
* **Localization**: Built-in support for 10+ languages.
* **Interactivity**: Easy-to-implement hit testing for muscle selection and custom interactions.
* **Path Access**: Access raw `Path` objects for custom rendering, animations, or hit testing.
* **Styling**: Customize stroke widths, colors, and default fill styles.
* **Full Documentation**: Comprehensive doc comments for all classes and methods for excellent IDE support.

## Getting started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_muscle_anatomy: ^1.2.3
  flutter_svg: ^2.0.0
```

## Usage

### 1. Simple Views (Male & Female)

Quickly display a specific view.

```dart
// Male Front View
final maleFront = Male.front();

// Female Back View with custom hair color
final femaleBack = Female.back(hairColor: Colors.brown);

// Render using SvgPicture (from flutter_svg)
Widget picture = SvgPicture.string(maleFront.toString());
```

### 2. Multi-View Displays

Display multiple views together. The library automatically manages layout and alignment.

```dart
// Front then Back
final maleBoth = Male.frontBack();

// Back then Front
final femaleBoth = Female.backFront();

// Shortcut for front then back
final anatomy = Male.both();
```

### 3. Smart View (By Muscles)

Automatically select the views (front, back, or both) that contain a specific list of muscles.

```dart
final anatomy = Male.byMuscles([
  Muscle.biceps,
  Muscle.trapezius,
]);
// Since biceps are on the front and trapezius on the back, this shows both views.
```

### 4. Highlighting Muscles

Highlight muscles with specific colors. You can highlight a muscle on a specific side (left/right) or both.

```dart
final anatomy = Male.front();

// Highlight a specific muscle on one side
anatomy.highlight(
  Muscle.biceps,
  position: MuscleSide.right,
  color: Colors.green,
  opacity: 0.7,
);

// Highlight multiple muscles on both sides (default)
anatomy.highlights(
  [Muscle.abs, Muscle.quadriceps],
  color: Colors.red,
);
```

### 5. Custom Styling

Customize the look of the anatomy model, including outlines and default muscle fills.

```dart
final anatomy = Male.front();

// Set default stroke (outline) color and width
anatomy.setStroke(color: Colors.blueGrey, width: 0.5);

// Set default fill for non-highlighted muscles
anatomy.setFill(color: Colors.grey.withOpacity(0.1), opacity: 1.0);

// Set default highlight style for subsequent highlights
anatomy.setDefaultHighlight(color: Colors.orange, opacity: 0.8);
```

### 6. Dynamic Gender Selection

Use `Anatomy` for scenarios where gender is determined at runtime.

```dart
final gender = 'female'; // Accepts 'male', 'm', 'female', 'f' (case-insensitive)
final factory = Anatomy(gender, hairColor: Colors.black);

final anatomy = factory.both();
```

### 7. Localization

The library is localization-ready. To use localized muscle names, you can provide a translator function. This allows the library to work with any localization package (like `easy_localization`, `slang`, or Flutter's built-in `intl`) without being tied to a specific one, ensuring compatibility with all platforms including **WebAssembly (WASM)**.

#### Usage with easy_localization:

1. Initialize your localization package as usual.
2. Set the `MuscleAnatomyLocalization.translator` in your `main()` function:
    
    ```dart
    void main() async {
      WidgetsFlutterBinding.ensureInitialized();
      await EasyLocalization.ensureInitialized();
    
      // Link the library to easy_localization
      MuscleAnatomyLocalization.translator = (key, {namedArgs}) => key.tr(namedArgs: namedArgs);
    
      runApp(EasyLocalization(...));
    }
    ```

3. Use the extensions:

```dart
import 'package:flutter_muscle_anatomy/flutter_muscle_anatomy.dart';

// Get localized muscle name
String name = Muscle.biceps.localizedName;

// Get localized gender name
String gender = 'male'.localizedGender;

// Get localized view name
String view = BodyView.front.localizedName;
```

### 8. Advanced Path Drawing (Canvas)

Access raw `Path` objects for high-performance custom painters or animations. The library provides pre-configured `Paint` objects and decoration data to make custom rendering easy.

```dart
class AnatomyPainter extends CustomPainter {
  final MuscleAnatomy anatomy;

  AnatomyPainter({required this.anatomy});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Calculate scale and offset to center the anatomy model
    final scaledSize = anatomy.scaledSize(size);
    final scale = scaledSize.width / anatomy.dimension.width;
    final dx = (size.width - scaledSize.width) / 2;
    final dy = (size.height - scaledSize.height) / 2;

    final matrix = Matrix4.identity()
      ..translate(dx, dy)
      ..scale(scale);

    // 2. Draw body outlines
    for (final path in anatomy.outlinePaths) {
      canvas.drawPath(path.transform(matrix.storage), anatomy.outlinePaint);
    }

    // 3. Draw all muscles (with their current highlights/styling)
    for (final member in anatomy.getMuscleMembers()) {
      for (final path in member.paths) {
        // Draw muscle fill
        canvas.drawPath(path.transform(matrix.storage), member.decoration.fillPaint());
        // Draw muscle stroke/outline
        canvas.drawPath(path.transform(matrix.storage), member.decoration.strokePaint());
      }
    }

    // 4. Draw hair (if visible)
    for (final path in anatomy.hairOutlinePaths) {
      canvas.drawPath(path.transform(matrix.storage), anatomy.hairFillPaint);
    }
  }

  @override
  bool shouldRepaint(covariant AnatomyPainter oldDelegate) => 
      oldDelegate.anatomy != anatomy;
}
```

### 9. Scaling Utilities

Scale a given `Size` to fit or fill the anatomy model's dimensions.

```dart
final anatomy = Male.both();
Size screenSize = MediaQuery.of(context).size;

// Get the size that fits the anatomy model within screen bounds
Size scaled = anatomy.scaledSize(screenSize, fill: false);
```

### 10. Interactivity & Hit Testing

The library's raw `Path` access makes it easy to build fully interactive anatomical maps. By combining `InteractiveViewer`, `GestureDetector`, and `CustomPaint`, you can create a viewport that supports **pinch-to-zoom**, **panning**, and **tap-to-select** muscles.

#### Step 1: Layout the Widget
Wrap your `CustomPaint` in an `InteractiveViewer` for navigation and a `GestureDetector` to capture interactions.

```dart
GestureDetector(
  onTapUp: _onTapped,
  child: InteractiveViewer(
    transformationController: _controller, // Used to track zoom/pan state
    minScale: 0.1,
    maxScale: 10,
    child: CustomPaint(
      size: const Size(200.0, 300.0),
      painter: AnatomyPainter(anatomy: anatomy),
    ),
  ),
)
```

#### Step 2: Handle Taps with Zoom Support
When using `InteractiveViewer`, you must account for the current transformation matrix to accurately convert a screen tap into model coordinates.

```dart
void _onTapped(TapUpDetails details) {
  final RenderBox box = context.findRenderObject() as RenderBox;
  final size = box.size;

  // 1. Account for InteractiveViewer zoom/pan
  final Matrix4 viewMatrix = _controller.value;
  final Offset scenePoint = MatrixUtils.transformPoint(
    Matrix4.inverted(viewMatrix),
    details.localPosition,
  );

  // 2. Calculate model-to-screen scaling
  final scaledSize = anatomy.scaledSize(size);
  final scale = scaledSize.width / anatomy.dimension.width;
  final dx = (size.width - scaledSize.width) / 2;
  final dy = (size.height - scaledSize.height) / 2;

  // 3. Convert to model coordinates
  final Offset modelPoint = Offset(
    (scenePoint.dx - dx) / scale,
    (scenePoint.dy - dy) / scale,
  );

  // 4. Hit test muscles
  for (final member in anatomy.getMuscleMembers()) {
    for (final path in member.paths) {
      if (path.contains(modelPoint)) {
        setState(() {
           anatomy.highlight(member.muscle, position: member.position);
        });
        return;
      }
    }
  }
}
```

## Contributing

Contributions are welcome! 

### Designing Muscles
* Source files are available as SVG in `assets/`.
* Designed using Inkscape.
* Ensure you export as **plain SVG**.
* Muscle IDs should follow the naming convention: `left_{muscle_name}` or `right_{muscle_name}`.
* Avoid using `transform` attributes on groups as they are currently not fully supported by the internal parser.

## Additional information

If you find this package useful, please give it a like on [pub.dev](https://pub.dev/packages/flutter_muscle_anatomy)!
