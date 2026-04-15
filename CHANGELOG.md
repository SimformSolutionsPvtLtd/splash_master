# Changelog

## [1.0.0]

- Improvement - Added dedicated example(s) for each package to make integration and issue reproduction easier.
- [Breaking] - Split Flutter animation widgets into dedicated packages: `splash_master_rive`, `splash_master_lottie`, and `splash_master_video`, while keeping `splash_master` focused on CLI/native generation and shared types.
- [Breaking] - Renamed `image_dark_android` to `image_dark` for consistency across platforms.
- [Breaking] - Renamed `color_dark_android` to `color_dark` for consistency across platforms.
- [Breaking] - Android 12+ configuration is treated as an explicit nested block under `android_12_and_above` and validated independently.
- [Breaking] - `android_dark_gravity` now falls back to `android_gravity` instead of behaving as an independent default.
- [Breaking] - Legacy/unsupported keys are now rejected by validation with explicit unsupported-key errors.
- [Breaking] - iOS content mode aliases `aspectFit` and `aspectFill` were removed/renamed; use `scaleAspectFit` and `scaleAspectFill`.
- Feature [#69](https://github.com/SimformSolutionsPvtLtd/splash_master/issues/69) - Added dark mode splash support across iOS and Android with platform-specific generation.
- Fixed [#71](https://github.com/SimformSolutionsPvtLtd/splash_master/issues/71) - Added Android dark background color support using night resources.
- Feature - Added `background_image_dark` for dark-mode background assets.
- Improvement - `android_background_image_gravity` now also applies when `background_image_dark` is used on Android.
- Feature - Added Android 12+ dark overrides via `android_12_and_above.image_dark` and `android_12_and_above.color_dark`.
- Feature - Added Android 12+ dark branding image support via `android_12_and_above.branding_image_dark`.
- Fixed [#78](https://github.com/SimformSolutionsPvtLtd/splash_master/issues/78) - Updated example app and docs with a comprehensive light/dark and Android 12+ configuration.
- Fixed [#80](https://github.com/SimformSolutionsPvtLtd/splash_master/issues/80) - Prevented duplicate `LaunchScreen.storyboard` entries when running `create` multiple times.
- [Migration] - See `doc/MIGRATION.md` for a full upgrade walkthrough and before/after config examples.

## [0.0.3]

- Feature: Add support for rive animations

## [0.0.2]

- Feature: Add branding image support for the Android 12+
- Feature: Add background image support
- Feature: Add dark mode support for Android

## [0.0.1]

- Initial release.
