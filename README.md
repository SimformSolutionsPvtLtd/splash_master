![Banner](preview/banner.png)

# Splash Master

[![splash master](https://img.shields.io/pub/v/splash_master?label=splash_master)](https://pub.dev/packages/splash_master)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/SimformSolutionsPvtLtd/splash_master/blob/master/LICENSE)


Splash Master is a Flutter plugin designed to make adding splash screens to your app quick, effortless, and highly customizable. It handles all the native-side setup for you, saving valuable development time and effort.

_Check out other amazing open-source [Flutter libraries](https://simform-flutter-packages.web.app) and [Mobile libraries](https://github.com/SimformSolutionsPvtLtd/Awesome-Mobile-Libraries) developed by Simform Solutions!_

## Preview

| Android                                                                                                                                                                                                                                                | iOS                                                                                                                                                                                                                                                            |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| <a href="https://raw.githubusercontent.com/SimformSolutionsPvtLtd/splash_master/master/preview/android_image_splash.gif"><img src="https://raw.githubusercontent.com/SimformSolutionsPvtLtd/splash_master/master/preview/android_image_splash.gif"  height="600px;"/></a> | <a href="https://raw.githubusercontent.com/SimformSolutionsPvtLtd/splash_master/master/preview/ios_image_splash.gif"><img src="https://raw.githubusercontent.com/SimformSolutionsPvtLtd/splash_master/master/preview/ios_image_splash.gif" height="600px;"/></a> |

## Features

- Native Integration: Automatically sets up native splash screens for Android and iOS.
- Dark Mode Support: Configure dark appearance splash assets for both Android and iOS.
- Multiple Media Support: Use videos, Lottie, Rive, images, or custom widgets.
- Easy Configuration: Define splash details in your pubspec.yaml.
- Smooth Transition: Ensures seamless transition from native splash to Flutter app.
- Highly Customizable: Control duration, background color, and more.

## Documentation

Visit our [documentation](https://simform-flutter-packages.web.app/splashMaster) site for all implementation details, usage instructions, code examples, and advanced features.


## Installation

### Image / Color splash only (no animation library required)

Add only `splash_master`:

```yaml
dependencies:
  splash_master: ^1.0.0
```

### With animation widgets

Each animation sub-package **already depends on `splash_master`** internally, so you **don't need to add `splash_master` separately**. Just add the sub-package you need — it works standalone:

```yaml
dependencies:
  # Just pick one or more — no need to add splash_master separately:
  splash_master_rive: ^1.0.0        # Rive animations (includes splash_master)
  splash_master_video: ^1.0.0       # Video splash (includes splash_master)
  splash_master_lottie: ^1.0.0      # Lottie animations (includes splash_master)
```

> **Note:** You only need `splash_master` directly if you're using the CLI for native splash generation **without** any animation widget, or if you want to pin a specific version.

## Migration from 0.0.3 to 1.0.0

**Breaking change**: `SplashMaster.rive(...)`, `SplashMaster.video(...)`, and `SplashMaster.lottie(...)` have been removed from the `splash_master` package. Add the relevant sub-package and rename the widget:

| Before (0.0.3)              | After (1.0.0)            | New package              |
|-----------------------------|--------------------------|--------------------------|
| `SplashMaster.rive(...)`    | `RiveSplash(...)`        | `splash_master_rive`     |
| `SplashMaster.video(...)`   | `VideoSplash(...)`       | `splash_master_video`    |
| `SplashMaster.lottie(...)`  | `LottieSplash(...)`      | `splash_master_lottie`   |
| `SplashMaster.initialize()` | `<Widget>.initialize()`  | same sub-package widget  |
| `SplashMaster.resume()`     | `<Widget>.resume()`      | same sub-package widget  |

Apps that use **only** the native image/color splash (CLI only, no Flutter animation widget) are **not affected** — continue using `splash_master` alone with no code changes.

`RiveFileSource` is available in `splash_master_rive`. Import `package:splash_master_rive/splash_master_rive.dart` to access it.

## Package structure

| Package                  | Contents                                                                  |
|--------------------------|---------------------------------------------------------------------------|
| `splash_master` | CLI tool, native splash generation (Android/iOS), shared types (`Source`, `VisibilityEnum`) |
| [`splash_master_rive`](packages/splash_master_rive/README.md)     | `RiveSplash` widget + `RiveConfig` + `RiveFileSource`                     |
| [`splash_master_video`](packages/splash_master_video/README.md)    | `VideoSplash` widget + `VideoConfig`                                      |
| [`splash_master_lottie`](packages/splash_master_lottie/README.md)   | `LottieSplash` widget + `LottieConfig`                                    |

All sub-packages re-export `splash_master`, so one import gives you both the splash widget and shared types.

```dart
// Choose one:
import 'package:splash_master_rive/splash_master_rive.dart';
import 'package:splash_master_video/splash_master_video.dart';
import 'package:splash_master_lottie/splash_master_lottie.dart';
```

## GitHub Copilot Support

Splash Master now supports GitHub Copilot instruction, skill, and prompt files for direct package usage.

- Copy these files to your app's `.github/` folder and use them with Copilot.
- Use `prompts/fresh-install.prompt.md` for first-time setup.
- Use `prompts/auto-migration.prompt.md` for migration from legacy `SplashMaster.*` APIs.
- Use `copilot-instructions.md` and `skills/splash-master/SKILL.md` for package-aware guidance while working on splash-related tasks.

The same support files are available at repository root and also inside each renderer package, so opening a sub-package directly still provides the same Copilot workflow.

## Sub-packages on pub.dev

Use these links to open each renderer package directly on pub.dev:

| Package | pub.dev |
|---|---|
| `splash_master_rive` | [pub.dev/packages/splash_master_rive](https://pub.dev/packages/splash_master_rive) |
| `splash_master_video` | [pub.dev/packages/splash_master_video](https://pub.dev/packages/splash_master_video) |
| `splash_master_lottie` | [pub.dev/packages/splash_master_lottie](https://pub.dev/packages/splash_master_lottie) |

---

## Usage — native splash (CLI)

The core `splash_master` package provides a CLI tool that generates native splash screens for **Android** and **iOS** from your `pubspec.yaml` configuration. This splash is displayed by the OS **before** Flutter renders its first frame.

### 1. Add configuration to `pubspec.yaml`

```yaml
splash_master:
  # Light mode
  color: '#FFFFFF'
  image: 'assets/splash.png'
  background_image: 'assets/bg.png'          # optional

  # Dark mode (Android & iOS)
  color_dark: '#000000'
  image_dark: 'assets/splash_dark.png'
  background_image_dark: 'assets/bg_dark.png' # optional

  # iOS positioning
  ios_content_mode: 'center'                  # default: scaleToFill
  ios_background_content_mode: 'scaleToFill'

  # Android pre-12 positioning
  android_gravity: 'center'                   # default: fill
  android_dark_gravity: 'center'
  android_background_image_gravity: 'fill'

  # Android 12+ (API 31+)
  android_12_and_above:
    color: '#FFFFFF'
    image: 'assets/splash_12.png'
    color_dark: '#000000'
    image_dark: 'assets/splash_12_dark.png'
    branding_image: 'assets/branding.png'
    branding_image_dark: 'assets/branding_dark.png'
```

### 2. Run the generator

```bash
dart run splash_master create
```

This will generate and set the native splash resources in your `android/` and `ios/` directories.

### Shared types

The core package exports types used by all companion packages:

| Type | Description |
|------|-------------|
| `Source` | Sealed class with `AssetSource`, `DeviceFileSource`, `NetworkFileSource`, `BytesSource` |
| `VisibilityEnum` | `useFullScreen`, `useAspectRatio`, `none` — controls how media fills the screen |

## Usage — animation splash screens

### Rive

```dart
import 'package:splash_master_rive/splash_master_rive.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  RiveSplash.initialize();
  runApp(
    MaterialApp(
      home: RiveSplash(
        source: AssetSource('assets/animation.riv'),
        nextScreen: const MyApp(),
      ),
    ),
  );
}

```

→ [Full API reference and configuration options](packages/splash_master_rive/README.md)

### Video

```dart
import 'package:splash_master_video/splash_master_video.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  VideoSplash.initialize();
  runApp(
    MaterialApp(
      home: VideoSplash(
        source: AssetSource('assets/splash.mp4'),
        nextScreen: const MyApp(),
      ),
    ),
  );
}

```

→ [Full API reference and configuration options](packages/splash_master_video/README.md)

### Lottie

```dart
import 'package:splash_master_lottie/splash_master_lottie.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LottieSplash.initialize();
  runApp(
    MaterialApp(
      home: LottieSplash(
        source: AssetSource('assets/animation.json'),
        nextScreen: const MyApp(),
      ),
    ),
  );
}
```

→ [Full API reference and configuration options](packages/splash_master_lottie/README.md)

## Support

For questions, issues, or feature requests, [create an issue](https://github.com/SimformSolutionsPvtLtd/splash_master/issues) on GitHub or reach out via the GitHub Discussions tab. We're happy to help and encourage community contributions.  
To contribute documentation updates specifically, please make changes to the `doc/documentation.md` file and submit a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/SimformSolutionsPvtLtd/splash_master/blob/master/LICENSE) file for details.

