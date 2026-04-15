![Banner](https://raw.githubusercontent.com/SimformSolutionsPvtLtd/splash_master/master/preview/banner.png)

# Splash Master

[![splash master](https://img.shields.io/pub/v/splash_master?label=splash_master)](https://pub.dev/packages/splash_master)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/SimformSolutionsPvtLtd/splash_master/blob/master/LICENSE)


Splash Master is a Flutter plugin designed to make adding splash screens to your app quick, effortless, and highly customizable. It handles all the native-side setup for you, saving valuable development time and effort.

_Check out other amazing open-source [Flutter libraries](https://simform-flutter-packages.web.app) and [Mobile libraries](https://github.com/SimformSolutionsPvtLtd/Awesome-Mobile-Libraries) developed by Simform Solutions!_

## Preview

| Android                                                                                                                                                                                                                                                | iOS                                                                                                                                                                                                                                                     |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| <a href="https://raw.githubusercontent.com/SimformSolutionsPvtLtd/splash_master/master/preview/android_preview.gif"><img src="https://raw.githubusercontent.com/SimformSolutionsPvtLtd/splash_master/master/preview/android_preview.gif"  height="600px;"/></a> | <a href="https://raw.githubusercontent.com/SimformSolutionsPvtLtd/splash_master/master/preview/ios_preview.gif"><img src="https://raw.githubusercontent.com/SimformSolutionsPvtLtd/splash_master/master/preview/ios_preview.gif" height="600px;"/></a> |

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

Add the sub-package for the renderer you need:

```yaml
dependencies:
  splash_master: ^1.0.0         # always needed for the CLI / shared types

  # pick one or more:
  splash_master_rive: ^0.0.1        # Rive animations
  splash_master_video: ^0.0.1       # Video splash
  splash_master_lottie: ^0.0.1      # Lottie animations
```

## Package structure

| Package                  | Contents                                                                  |
|--------------------------|---------------------------------------------------------------------------|
| `splash_master`          | CLI tool, native splash generation (Android/iOS), shared types (`Source`, `SplashMediaType`, `VisibilityEnum`) |
| `splash_master_rive`     | `RiveSplash` widget + `RiveConfig` + `RiveArtboardSource`                 |
| `splash_master_video`    | `VideoSplash` widget + `VideoConfig`                                      |
| `splash_master_lottie`   | `LottieSplash` widget + `LottieConfig`                                    |

All sub-packages re-export `splash_master` so you only need to import one package in your Dart code.

## Usage — animation splash screens

### Rive

```dart
import 'package:splash_master_rive/splash_master_rive.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  RiveSplash.initialize();
  runApp(MaterialApp(home: RiveSplash(
    source: AssetSource('assets/animation.riv'),
    nextScreen: const MyApp(),
  )));
}
```

### Video

```dart
import 'package:splash_master_video/splash_master_video.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  VideoSplash.initialize();
  runApp(MaterialApp(home: VideoSplash(
    source: AssetSource('assets/splash.mp4'),
    nextScreen: const MyApp(),
  )));
}
```

### Lottie

```dart
import 'package:splash_master_lottie/splash_master_lottie.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LottieSplash.initialize();
  runApp(MaterialApp(home: LottieSplash(
    source: AssetSource('assets/animation.json'),
    nextScreen: const MyApp(),
  )));
}
```

## Migration from 1.x

**Breaking change**: `SplashMaster.rive(...)`, `SplashMaster.video(...)`, and `SplashMaster.lottie(...)` have been removed from the `splash_master` package. Add the relevant sub-package and rename the widget:

| Before (1.x)                | After (2.x)              | New package              |
|-----------------------------|--------------------------|--------------------------|
| `SplashMaster.rive(...)`    | `RiveSplash(...)`        | `splash_master_rive`     |
| `SplashMaster.video(...)`   | `VideoSplash(...)`       | `splash_master_video`    |
| `SplashMaster.lottie(...)`  | `LottieSplash(...)`      | `splash_master_lottie`   |
| `SplashMaster.initialize()` | `<Widget>.initialize()`  | same sub-package widget  |
| `SplashMaster.resume()`     | `<Widget>.resume()`      | same sub-package widget  |

Apps that use **only** the native image/color splash (CLI only, no Flutter animation widget) are **not affected** — continue using `splash_master` alone with no code changes.

`RiveArtboardSource` has moved to `splash_master_rive`. Import `package:splash_master_rive/splash_master_rive.dart` to access it.

## Support

For questions, issues, or feature requests, [create an issue](https://github.com/SimformSolutionsPvtLtd/splash_master/issues) on GitHub or reach out via the GitHub Discussions tab. We're happy to help and encourage community contributions.  
To contribute documentation updates specifically, please make changes to the `doc/documentation.md` file and submit a pull request.

## Android 16 KB Page Size Support (Rive)

If you're using Rive animations with Splash Master and encounter the 16 KB page size error when uploading your APK to Google Play Console, you can resolve this by overriding the NDK version used by Rive.

Add the following line to your app's `android/gradle.properties` file:

```properties
rive.ndk.version=28.1.13356709
```

This enables 16 KB page size support required by Google Play for apps targeting Android 15+. For more details, see the [Rive Flutter issue #547](https://github.com/rive-app/rive-flutter/issues/547).

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/SimformSolutionsPvtLtd/splash_master/blob/master/LICENSE) file for details.

