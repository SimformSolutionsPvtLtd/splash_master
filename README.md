![Banner](preview/banner.png)

# Splash Master

[![splash master](https://img.shields.io/pub/v/splash_master?label=splash_master)](https://pub.dev/packages/splash_master)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/SimformSolutionsPvtLtd/splash_master/blob/master/LICENSE)

Splash Master is a Flutter package ecosystem for native and animated splash screens across Android and iOS.

## Migration Guide

| Before (legacy) | After (current) | Package |
|---|---|---|
| `SplashMaster.rive(...)` | `SplashMasterRive(...)` | `splash_master_rive` |
| `SplashMaster.video(...)` | `SplashMasterVideo(...)` | `splash_master_video` |
| `SplashMaster.lottie(...)` | `SplashMasterLottie(...)` | `splash_master_lottie` |
| `SplashMaster.initialize()` | `<Widget>.initialize()` | renderer package |
| `SplashMaster.resume()` | `<Widget>.resume()` | renderer package |

For more details, check our [documentation](https://simform-flutter-packages.web.app/splashMaster).

## Features

- Native splash generation from `pubspec.yaml` configuration
- Light and dark mode splash support
- Android 12+ splash configuration support
- Renderer packages for Rive, Video, and Lottie splash animations
- Shared source/config types across packages

## Documentation

Visit our [documentation](https://simform-flutter-packages.web.app/splashMaster) site for all implementation details, usage instructions, code examples, and advanced features.

## Sub Packages

| Sub Package | pub.dev | Repository | Documentation                                                                       |
|---|---|---|-------------------------------------------------------------------------------------|
| `splash_master_rive` | [pub.dev/packages/splash_master_rive](https://pub.dev/packages/splash_master_rive) | [packages/splash_master_rive](https://github.com/SimformSolutionsPvtLtd/splash_master/tree/master/packages/splash_master_rive) | [Rive documentaion](https://simform-flutter-packages.web.app/splashMasterRive)      |
| `splash_master_video` | [pub.dev/packages/splash_master_video](https://pub.dev/packages/splash_master_video) | [packages/splash_master_video](https://github.com/SimformSolutionsPvtLtd/splash_master/tree/master/packages/splash_master_video) | [Video documentation](https://simform-flutter-packages.web.app/splashMasterVideo)   |
| `splash_master_lottie` | [pub.dev/packages/splash_master_lottie](https://pub.dev/packages/splash_master_lottie) | [packages/splash_master_lottie](https://github.com/SimformSolutionsPvtLtd/splash_master/tree/master/packages/) | [Lottie documentation](https://simform-flutter-packages.web.app/splashMasterLottie) |

## Installation

### Core package

```yaml
dependencies:
  splash_master: <latest-version>
```

### Animation packages

```yaml
dependencies:
  splash_master_rive: <latest-version>
  splash_master_video: <latest-version>
  splash_master_lottie: <latest-version>
```

> Note: `splash_master_rive`, `splash_master_video`, and `splash_master_lottie` already include `splash_master` as a dependency.

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

For full key reference, check our [documentation](https://simform-flutter-packages.web.app/splashMaster).

## Support

For questions, issues, or feature requests, [create an issue](https://github.com/SimformSolutionsPvtLtd/splash_master/issues) on GitHub.

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE).
