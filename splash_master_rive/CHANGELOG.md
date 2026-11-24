## [Unreleased]

- Feature - Added the AI coding-agent skill `splash-master-rive-splash` in `skills/`. Install it in your app with [`dart run skills@ get`](https://dart.dev/tools/pub/package-skills).
- Improvement - Removed the GitHub Copilot instructions, prompts and skill files from `.github/`; they are replaced by the package's agent skills.
- Improvement - Replaced the outdated `rive.ndk.version` instructions in the documentation: Rive 0.14 supports 16 KB pages out of the box and builds with the app's `ndkVersion`.

## [1.0.0+1]

- Documentation changes

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
