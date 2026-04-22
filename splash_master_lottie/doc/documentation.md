# Overview

`splash_master_lottie` provides `SplashMasterLottie`, a Flutter widget that plays a Lottie animation as your splash screen and automatically navigates to your app once the animation completes.

## Preview

| Android                                                                                                                                                                              | iOS                                                                                                                                                                                                                                                                                                                                                          |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| ![Splash Master Android Lottie Splash Preview](https://raw.githubusercontent.com/SimformSolutionsPvtLtd/splash_master/master/splash_master_lottie/preview/android_lottie_splash.gif) | ![Splash Master Android Lottie Splash Preview](https://raw.githubusercontent.com/SimformSolutionsPvtLtd/splash_master/master/splash_master_lottie/preview/ios_lottie_splash.gif) |

## Features

- Plays a Lottie animation (asset, file, network, or bytes) as an animated splash screen.
- Auto-navigates to the next screen when the animation completes.
- Full control over repeat, reverse, frame rate, and display mode via `LottieConfig`.
- Dynamic property overrides via `LottieDelegates`.
- Custom navigation callback for advanced routing.
- `initialize()` / `resume()` static methods to coordinate with the native splash.

# Installation

## 1. Add dependency to `pubspec.yaml`

```yaml
dependencies:
  splash_master_lottie: ^1.0.0
```

> `splash_master_lottie` re-exports `splash_master`, so you do not need to add `splash_master` separately.

## 2. Configure native splash in `pubspec.yaml`

Add a `splash_master` section to set up the native (before-Flutter) splash screen:

```yaml
splash_master:
  color: '#FFFFFF'
  image: 'assets/splash.png'
```

Then generate native assets:

```bash
dart run splash_master create
```

For the full configuration key reference, see [splash_master documentation](https://simform-flutter-packages.web.app/splashMaster).

## 3. Declare the animation asset

```yaml
flutter:
  assets:
    - assets/animation.json
```

## 4. Install packages

```bash
flutter pub get
```

## 5. Import the package

```dart
import 'package:splash_master_lottie/splash_master_lottie.dart';
```

# Basic Usage

## Step 1: Call `initialize()` before `runApp()`

`SplashMasterLottie.initialize()` holds the native splash screen visible while Flutter initialises. The native splash is released automatically once the animation completes.

## Step 2: Use `SplashMasterLottie` as your root widget

```dart
import 'package:flutter/material.dart';
import 'package:splash_master_lottie/splash_master_lottie.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SplashMasterLottie.initialize();
  runApp(const MaterialApp(home: MySplash()));
}

class MySplash extends StatelessWidget {
  const MySplash({super.key});

  @override
  Widget build(BuildContext context) {
    return SplashMasterLottie(
      source: AssetSource('assets/animation.json'),
      lottieConfig: const LottieConfig(repeat: false),
      backGroundColor: Colors.white,
      nextScreen: const MyApp(),
    );
  }
}
```

# Advanced Usage

## Configure Lottie Behavior

```dart
SplashMasterLottie(
  source: AssetSource('assets/animation.json'),
  lottieConfig: const LottieConfig(
    repeat: false,
    reverse: false,
    visibilityEnum: VisibilityEnum.useAspectRatio,
  ),
  nextScreen: const MyApp(),
)
```

## Loop Animation

```dart
SplashMasterLottie(
  source: AssetSource('assets/animation.json'),
  lottieConfig: const LottieConfig(repeat: true),
  nextScreen: const MyApp(),
)
```

## Control Aspect Ratio

```dart
SplashMasterLottie(
  source: AssetSource('assets/animation.json'),
  lottieConfig: const LottieConfig(
    visibilityEnum: VisibilityEnum.useAspectRatio,
    aspectRatio: 16 / 9,
  ),
  nextScreen: const MyApp(),
)
```

## Manual Animation Controller

```dart
class MySplash extends StatefulWidget {
  const MySplash({super.key});

  @override
  State<MySplash> createState() => _MySplashState();
}

class _MySplashState extends State<MySplash>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SplashMasterLottie(
      source: AssetSource('assets/animation.json'),
      lottieConfig: LottieConfig(controller: _controller),
      nextScreen: const MyApp(),
    );
  }
}
```

## Dynamic Color Override via Delegates

```dart
SplashMasterLottie(
  source: AssetSource('assets/animation.json'),
  lottieConfig: LottieConfig(
    delegates: LottieDelegates(
      values: [
        ValueDelegate.color(
          const ['**'],
          value: Colors.red,
        ),
      ],
    ),
  ),
  nextScreen: const MyApp(),
)
```

## Custom Navigation

```dart
SplashMasterLottie(
  source: AssetSource('assets/animation.json'),
  customNavigation: () {
    Navigator.of(context).pushReplacementNamed('/home');
  },
)
```

## Network Animation

```dart
SplashMasterLottie(
  source: NetworkSource('https://example.com/animation.json'),
  nextScreen: const MyApp(),
)
```

## Manual Resume

If you provide an `onSourceLoaded` callback, you are responsible for calling `SplashMasterLottie.resume()`:

```dart
SplashMasterLottie(
  source: AssetSource('assets/animation.json'),
  onSourceLoaded: () {
    // Perform additional work, then release native splash
    SplashMasterLottie.resume();
  },
  nextScreen: const MyApp(),
)
```

# Widget Reference

## SplashMasterLottie

| Property | Type | Required | Description |
|---|---|---|---|
| `source` | `Source` | ✅ | The Lottie animation source |
| `lottieConfig` | `LottieConfig` | ❌ | Animation and display configuration |
| `nextScreen` | `Widget?` | ❌ | Screen to navigate to after animation completes |
| `customNavigation` | `VoidCallback?` | ❌ | Custom navigation logic (replaces `nextScreen`) |
| `onSourceLoaded` | `VoidCallback?` | ❌ | Called when the animation loads; you must call `resume()` manually if provided |
| `backGroundColor` | `Color?` | ❌ | Background color behind the animation |

**Static methods:**

| Method | Description |
|---|---|
| `SplashMasterLottie.initialize()` | Holds the native splash until `resume()` is called |
| `SplashMasterLottie.resume()` | Releases the native splash and allows Flutter to render |

## LottieConfig Parameters

| Property | Type | Default | Description |
|---|---|---|---|
| `repeat` | `bool?` | `false` | Loop the animation |
| `animate` | `bool?` | `null` (auto) | Auto-play when loaded |
| `reverse` | `bool?` | `null` | Play in reverse |
| `controller` | `Animation<double>?` | `null` | Manual animation controller |
| `frameRate` | `FrameRate?` | `null` | Target frame rate |
| `visibilityEnum` | `VisibilityEnum` | `useFullScreen` | How to display the animation (`useFullScreen`, `useAspectRatio`, `none`) |
| `aspectRatio` | `double` | `9 / 16` | Aspect ratio used when `useAspectRatio` is set |
| `overrideBoxFit` | `bool` | `true` | Applies `BoxFit.fill` to reduce Lottie default padding |
| `onLoaded` | `void Function(LottieComposition)?` | `null` | Called when the composition is fully loaded |
| `delegates` | `LottieDelegates?` | `null` | Dynamic property overrides (colors, transforms, etc.) |

## VisibilityEnum Values

| Value | Description |
|---|---|
| `VisibilityEnum.useFullScreen` | Fills the screen while maintaining aspect ratio with letterboxing (default) |
| `VisibilityEnum.useAspectRatio` | Displays the animation at its natural aspect ratio within available space |
| `VisibilityEnum.none` | No special layout handling |

## Source Types

| Type | Usage |
|---|---|
| `AssetSource(path)` | Flutter bundled asset |
| `DeviceFileSource(path)` | Local device file path |
| `NetworkSource(url)` | Remote animation URL |
| `BytesSource(bytes)` | In-memory `Uint8List` |

# Migration Guide

## From `splash_master` 0.0.3

| Before (0.0.3) | After (1.0.0) |
|---|---|
| `SplashMaster.lottie(...)` | `SplashMasterLottie(...)` |
| `SplashMaster.initialize()` | `SplashMasterLottie.initialize()` |
| `SplashMaster.resume()` | `SplashMasterLottie.resume()` |

Apps that used only the native image/color splash with no animation widget are **not affected**.

# Contributors

The following individuals have played a key role in developing and maintaining the Splash Master package.

## Main Contributors

| ![img](https://avatars.githubusercontent.com/u/56400956?v=4&s=200) | ![img](https://avatars.githubusercontent.com/u/65003381?v=4&s=200) | ![img](https://avatars.githubusercontent.com/u/44993081?v=4&s=200) |
|:------------------------------------------------------------------:|:------------------------------------------------------------------:|:------------------------------------------------------------------:|
| [Ujas Majithiya](https://github.com/Ujas-Majithiya)                | [Apurva Kanthraviya](https://github.com/apurva780)                 | [Dhaval Kansara](https://github.com/DhavalRKansara)                |

## Contribute

We welcome contributions! To get started:

1. Fork the repository to your GitHub account.
2. Create a new branch (`git checkout -b feature/your-feature-name`).
3. Make your changes and commit them (`git commit -m 'Describe your change'`).
4. Push your branch (`git push origin feature/your-feature-name`).
5. Submit a Pull Request for review.

For more details, visit the [Splash Master GitHub repository](https://github.com/SimformSolutionsPvtLtd/splash_master).

# License

```
MIT License

Copyright (c) 2024 Simform Solutions

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
