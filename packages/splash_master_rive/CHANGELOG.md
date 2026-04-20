# Changelog

## [1.0.0]

- Initial release as a standalone package.
- [Breaking] - Extracted `SplashMasterRive` widget from `splash_master` into its own dedicated package.
- [Breaking] - `SplashMaster.rive(...)` replaced by `SplashMasterRive(...)`.
- [Breaking] - `SplashMaster.initialize()` replaced by `SplashMasterRive.initialize()`.
- [Breaking] - `SplashMaster.resume()` replaced by `SplashMasterRive.resume()`.
- Feature - Added `RiveFileSource` for pre-loaded Rive file support.
- Feature - Added `RiveConfig` with full control over artboard, state machine, fit, alignment, splash duration, data binding, and more.
- Feature - Updated to Rive 0.14.5 with `RiveWidgetBuilder` API.
- Improvement - Added dedicated example app for easier integration and issue reproduction.
- Improvement - Re-exports `splash_master` types (`Source`, `VisibilityEnum`, `SplashMediaType`) so only a single import is needed.
