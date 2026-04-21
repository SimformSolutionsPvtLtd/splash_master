# Changelog

## [1.0.0]

- Initial release as a standalone package.
- [Breaking] - Extracted `SplashMasterVideo` widget from `splash_master` into its own dedicated package.
- [Breaking] - `SplashMaster.video(...)` replaced by `SplashMasterVideo(...)`.
- [Breaking] - `SplashMaster.initialize()` replaced by `SplashMasterVideo.initialize()`.
- [Breaking] - `SplashMaster.resume()` replaced by `SplashMasterVideo.resume()`.
- Feature - Added `VideoConfig` with control over auto-play, visibility mode, safe area, and `VideoPlayerController` access.
- Feature - Supports asset, device file, network, and in-memory byte video sources.
- Improvement - Added dedicated example app for easier integration and issue reproduction.
- Improvement - Re-exports `splash_master` types (`Source`, `VisibilityEnum`, `SplashMediaType`) so only a single import is needed.
