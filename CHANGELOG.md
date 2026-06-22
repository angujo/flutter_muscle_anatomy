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
