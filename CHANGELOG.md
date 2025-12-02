## [0.0.4-dev.1] (Pre-release)

* **Breaking Change**: Updated Rive dependency to `^0.14.0-dev.14` which includes:
  * Complete API overhaul using new C++ runtime-based implementation
  * New widgets: `RiveWidget`, `RiveWidgetBuilder`, `RiveWidgetController` replace `RiveAnimation`
  * New `RiveConfig` parameters aligned with Rive 0.14.x API
  * Added `RiveFileSource` for pre-loaded Rive files
  * **Removed** `RiveArtboardSource` (use `RiveFileSource` instead)
  * **Note**: `DeviceFileSource` and `BytesSource` are no longer supported for Rive splash - use `AssetSource`, `NetworkFileSource`, or `RiveFileSource` instead
  * Minimum Flutter requirement: `>=3.27.0` and Dart SDK `>=3.6.0`
* Added support for new Rive features:
  * Rive Renderer
  * Data Binding
  * Layouts
  * Scrolling
  * N-Slicing
  * Vector Feathering

## [0.0.3] 

* Feature: Add support for rive animations

## [0.0.2]

* Feature: Add branding image support for the Android 12+
* Feature: Add background image support
* Feature: Add dark mode support for Android

## [0.0.1]

* Initial release.
