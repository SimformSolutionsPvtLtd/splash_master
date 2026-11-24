## [Unreleased]

- Feature - Added the AI coding-agent skill `splash-master-video-splash` in `skills/`. Install it in your app with [`dart run skills@ get`](https://dart.dev/tools/pub/package-skills).
- Improvement - Removed the GitHub Copilot instructions, prompts and skill files from `.github/`; they are replaced by the package's agent skills.
- Improvement - Corrected the `VisibilityEnum` descriptions in the documentation: `useFullScreen` stretches the video, and `none` also fills the available space.

## [1.0.0+1]

- Documentation changes

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
