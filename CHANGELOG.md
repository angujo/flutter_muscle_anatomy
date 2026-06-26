## 1.2.5

* Introduced `ViewScale` interface for advanced scaling, centering, and transformation logic.
* Added `getViewScale` to `MuscleAnatomy` (deprecated `scaledSize`) and `customPainter` to return a configured painter.
* Enhanced `MuscleInteractiveView`:
    - Replaced custom `AxisSide` with Flutter's `Alignment` for control positioning.
    - Improved layout to prevent UI controls from obstructing the anatomy model.
    - Integrated localized tooltips for Zoom In, Zoom Out, and Flip View controls across all 10 supported languages.
* Added comprehensive documentation for all public classes, including `MuscleInteractiveView` and `ViewScale`.
* Updated README with detailed API references, `Muscle.search` documentation, and modernized code examples.
* Exposed muscle grouping and fuzzy search capability for easier muscle discovery.

## 1.2.4

* Enhanced documentation for interactivity, including `InteractiveViewer` integration and hit-testing examples.
* Refined advanced path drawing examples in README.
* Added full doc comments for all public classes and methods.

## 1.2.3

* Replaced preview video with an animated GIF for better compatibility on pub.dev.
* Minor documentation refinements.

## 1.2.2

* Added comprehensive documentation for all classes, methods, and functions.
* Updated README with a preview GIF and detailed guide for interactivity (hit testing and InteractiveViewer).
* Improved advanced path drawing example in documentation.

## 1.2.1

* Updated minimum Flutter version to 3.27.0 to support `withValues` API.
* Minor documentation updates and fixes.

## 1.2.0

* **Breaking Change**: Refactored `Male` and `Female` classes to utility classes (they no longer extend `_Body`).
* Fixed Wasm compatibility by removing hard dependency on `easy_localization`.
* Decoupled localization using a customizable translator.
* Exported localization extensions and configuration.

## 1.1.2

* Fixed Wasm compatibility by removing hard dependency on `easy_localization`.
* Decoupled localization using a customizable translator.
* Exported localization extensions and configuration.

## 1.1.1

* Improved translation coverage and fixed minor issues.

## 1.1.0

* Added localization support using `easy_localization`.
* Integrated translations for 10 languages: English, Spanish, Portuguese (Brazil), Hindi, Arabic, French, Indonesian, German, Japanese, and Korean.
* Added `MuscleLocalization`, `BodyViewLocalization`, and `MusclePositionLocalization` extensions for easy access to translated names.
* Updated example app with a language picker and localized UI strings.
* Improved error handling for gender parsing with localized error messages.

## 1.0.0

* Major refactoring of the internal engine for better performance and smaller codebase.
* Added `Anatomy` factory for easier gender-agnostic usage.
* Unified `Male` and `Female` implementation using shared skeletal muscle logic.
* Improved support for hair color and gender-specific traits.
* Enhanced documentation and example app with random muscle selection.

## 0.0.2

* Updates for repo scores.

## 0.0.1

* Initial release
