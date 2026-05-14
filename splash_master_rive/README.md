![Banner](preview/banner.png)

# Splash Master Rive

[![splash master rive](https://img.shields.io/pub/v/splash_master?label=splash_master_rive)](https://pub.dev/packages/splash_master_rive)[![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/SimformSolutionsPvtLtd/splash_master/blob/master/LICENSE)

Splash Master Rive provides `SplashMasterRive`, a Flutter splash widget for Rive animations.

## Preview

| Android                                                                                                                                                                        | iOS                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| ![Splash Master Android Rive Splash Preview](https://raw.githubusercontent.com/SimformSolutionsPvtLtd/splash_master/master/splash_master_rive/preview/android_rive_splash.gif) | ![Splash Master iOS Rive Splash Preview](https://raw.githubusercontent.com/SimformSolutionsPvtLtd/splash_master/master/splash_master_rive/preview/ios_rive_splash.gif) |

## Features

- Rive animation splash with automatic next-screen navigation
- Supports `AssetSource`, `NetworkFileSource`, and `RiveFileSource`
- First-frame control via `SplashMasterRive.initialize()` and `SplashMasterRive.resume()`
- Configurable playback behavior via `RiveConfig`

## Documentation

Visit our [documentation](https://simform-flutter-packages.web.app/splashMasterRive) site for all implementation details, usage instructions, code examples, and advanced features.

## Installation

```yaml
dependencies:
  splash_master_rive: <latest-version>
```

> Note: `splash_master_rive` already includes `splash_master`, so you do not need to add `splash_master` separately.

For CLI and native image setup, check the `splash_master` package: https://pub.dev/packages/splash_master

### Minimal splash_master setup (`pubspec.yaml`)

```yaml
splash_master:
  color: '#FFFFFF'
  image: 'assets/splash.png'
```

Then run:

```bash
dart run splash_master create
```

For full key reference, check our [splash_master documentation](https://simform-flutter-packages.web.app/splashMaster/basic-usage).

## Support

For questions or issues, [create an issue](https://github.com/SimformSolutionsPvtLtd/splash_master/issues) on GitHub.

## License

This project is licensed under the MIT License. See [LICENSE](../../LICENSE).
