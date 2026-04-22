# Overview

`splash_master_rive` provides `SplashMasterRive`, a Flutter widget that plays a Rive animation as your splash screen and automatically navigates to your app once the animation completes.

## Preview

| Android                                                                                                                                                                        | iOS                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| ![Splash Master Android Rive Splash Preview](https://raw.githubusercontent.com/SimformSolutionsPvtLtd/splash_master/master/splash_master_rive/preview/android_rive_splash.gif) | ![Splash Master iOS Rive Splash Preview](https://raw.githubusercontent.com/SimformSolutionsPvtLtd/splash_master/master/splash_master_rive/preview/ios_rive_splash.gif) |

## Features

- Plays a Rive animation as an animated splash screen.
- Auto-navigates to the next screen when the animation completes.
- Supports asset, network, and pre-loaded `RiveFile` sources.
- Full control over artboard, state machine, fit, alignment, and duration via `RiveConfig`.
- Custom navigation callback for advanced routing.
- `initialize()` / `resume()` static methods to coordinate with the native splash.

# Installation

## 1. Add dependency to `pubspec.yaml`

```yaml
dependencies:
  splash_master_rive: ^1.0.0
```

> `splash_master_rive` re-exports `splash_master`, so you do not need to add `splash_master` separately.

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

## 3. Declare the Rive asset

```yaml
flutter:
  assets:
    - assets/animation.riv
```

## 4. Install packages

```bash
flutter pub get
```

## 5. Import the package

```dart
import 'package:splash_master_rive/splash_master_rive.dart';
```

# Basic Usage

## Step 1: Call `initialize()` before `runApp()`

`SplashMasterRive.initialize()` holds the native splash screen visible while Flutter initialises. The native splash is released automatically once the Rive animation finishes loading.

## Step 2: Use `SplashMasterRive` as your root widget

```dart
import 'package:flutter/material.dart';
import 'package:splash_master_rive/splash_master_rive.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SplashMasterRive.initialize();
  runApp(const MaterialApp(home: MySplash()));
}

class MySplash extends StatelessWidget {
  const MySplash({super.key});

  @override
  Widget build(BuildContext context) {
    return SplashMasterRive(
      source: AssetSource('assets/animation.riv'),
      nextScreen: const MyApp(),
    );
  }
}
```

# Advanced Usage

## Custom Navigation

Use `customNavigation` to control navigation yourself instead of providing `nextScreen`:

```dart
SplashMasterRive(
  source: AssetSource('assets/animation.riv'),
  customNavigation: () {
    Navigator.of(context).pushReplacementNamed('/home');
  },
)
```

## Use a Pre-loaded Rive File

Skip load time by passing a pre-loaded `rive.File` via `RiveFileSource`:

```dart
SplashMasterRive(
  source: RiveFileSource(myPreloadedRiveFile),
  nextScreen: const MyApp(),
)
```

## Customize Playback Behavior

```dart
SplashMasterRive(
  source: AssetSource('assets/animation.riv'),
  riveConfig: const RiveConfig(
    splashDuration: Duration(seconds: 5),
    fit: Fit.cover,
    alignment: Alignment.center,
  ),
  nextScreen: const MyApp(),
)
```

## Select Artboard and State Machine

```dart
SplashMasterRive(
  source: AssetSource('assets/animation.riv'),
  riveConfig: RiveConfig(
    artboardSelector: ArtboardName('SplashArtboard'),
    stateMachineSelector: StateMachineName('SplashStateMachine'),
  ),
  nextScreen: const MyApp(),
)
```

## Access the Rive Controller

```dart
SplashMasterRive(
  source: AssetSource('assets/animation.riv'),
  riveConfig: RiveConfig(
    onInit: (controller) {
      // Interact with the RiveWidgetController
    },
  ),
  nextScreen: const MyApp(),
)
```

## Show a Placeholder While Loading

```dart
SplashMasterRive(
  source: AssetSource('assets/animation.riv'),
  riveConfig: RiveConfig(
    placeHolder: const CircularProgressIndicator(),
  ),
  nextScreen: const MyApp(),
)
```

## Manual Resume

If you provide an `onSourceLoaded` callback, you are responsible for calling `SplashMasterRive.resume()` to release the native splash:

```dart
SplashMasterRive(
  source: AssetSource('assets/animation.riv'),
  onSourceLoaded: () {
    // Perform additional work, then release native splash
    SplashMasterRive.resume();
  },
  nextScreen: const MyApp(),
)
```

# Widget Reference

## SplashMasterRive

| Property | Type | Required | Description |
|---|---|---|---|
| `source` | `RiveSource` | ✅ | The Rive animation source |
| `riveConfig` | `RiveConfig` | ❌ | Playback and appearance configuration |
| `nextScreen` | `Widget?` | ❌ | Screen to navigate to after animation completes |
| `customNavigation` | `VoidCallback?` | ❌ | Custom navigation logic (replaces `nextScreen`) |
| `onSourceLoaded` | `VoidCallback?` | ❌ | Called when the Rive file is loaded; you must call `resume()` manually if provided |
| `backGroundColor` | `Color?` | ❌ | Background color behind the animation |

**Static methods:**

| Method | Description |
|---|---|
| `SplashMasterRive.initialize()` | Holds the native splash until `resume()` is called |
| `SplashMasterRive.resume()` | Releases the native splash and allows Flutter to render |

## RiveConfig Parameters

| Property | Type | Default | Description |
|---|---|---|---|
| `artboardSelector` | `ArtboardSelector` | `ArtboardDefault()` | Select artboard from the Rive file |
| `stateMachineSelector` | `StateMachineSelector` | `StateMachineDefault()` | Select state machine to run |
| `fit` | `Fit` | `Fit.contain` | How the animation fits within its bounds |
| `alignment` | `Alignment` | `Alignment.center` | Alignment of the animation within the parent |
| `splashDuration` | `Duration?` | `null` (3 s fallback) | Explicit splash duration; defaults to 3 s if `null` |
| `placeHolder` | `Widget?` | `null` | Widget shown while the Rive file is loading |
| `onInit` | `void Function(RiveWidgetController)?` | `null` | Access the Rive widget controller after initialisation |

## Source Types

| Type | Usage |
|---|---|
| `AssetSource(path)` | Flutter bundled asset (most common) |
| `NetworkFileSource(url)` | Remote `.riv` file URL |
| `RiveFileSource(file)` | Pre-loaded `rive.File` instance (skips load time) |

> `DeviceFileSource` and `BytesSource` are **not supported** for Rive.

# Platform Notes

## Android 16 KB Page Size

If you target devices with 16 KB memory page size (Android 15+), add the following to `android/gradle.properties`:

```properties
rive.ndk.version=28.1.13356709
```

# Migration Guide

## From `splash_master` 0.0.3

| Before (0.0.3) | After (1.0.0) |
|---|---|
| `SplashMaster.rive(...)` | `SplashMasterRive(...)` |
| `SplashMaster.initialize()` | `SplashMasterRive.initialize()` |
| `SplashMaster.resume()` | `SplashMasterRive.resume()` |

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
