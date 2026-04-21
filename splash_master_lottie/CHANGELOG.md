# Changelog

## [1.0.0]

- Initial release as a standalone package.
- [Breaking] - Extracted `SplashMasterLottie` widget from `splash_master` into its own dedicated package.
- [Breaking] - `SplashMaster.lottie(...)` replaced by `SplashMasterLottie(...)`.
- [Breaking] - `SplashMaster.initialize()` replaced by `SplashMasterLottie.initialize()`.
- [Breaking] - `SplashMaster.resume()` replaced by `SplashMasterLottie.resume()`.
- Feature - Added `LottieConfig` with full control over repeat, reverse, frame rate, delegates, visibility, aspect ratio, and more.
- Feature - Supports asset, device file, network, and in-memory byte Lottie sources.
- Improvement - Added dedicated example app for easier integration and issue reproduction.
- Improvement - Re-exports `splash_master` types (`Source`, `VisibilityEnum`, `SplashMediaType`) so only a single import is needed.
