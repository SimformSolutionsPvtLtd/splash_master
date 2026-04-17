![Banner](../../preview/banner.png)

# splash_master_rive

[![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/SimformSolutionsPvtLtd/splash_master/blob/master/LICENSE)

Rive animation splash screen widget for the [Splash Master](../../README.md) ecosystem. Display a Rive animation as your Flutter app's animated splash screen, with automatic transition to your main app once playback finishes.

> **Part of the splash_master family** — the core CLI/native-image package is [`splash_master`](../../README.md). For other animation types, see [`splash_master_video`](../splash_master_video/README.md) (Video) and [`splash_master_lottie`](../splash_master_lottie/README.md) (Lottie).

## Preview

| Android                                                                                                                                                                                                              | iOS                                                                                                                                                                                                                                                                                                                    |
|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| <a href="https://raw.githubusercontent.com/SimformSolutionsPvtLtd/splash_master/master/packages/splash_master_rive/preview/android_rive_splash.gif"><img src="https://raw.githubusercontent.com/SimformSolutionsPvtLtd/splash_master/master/packages/splash_master_rive/preview/android_rive_splash.gif" height="600px;"/></a> | <a href="https://raw.githubusercontent.com/SimformSolutionsPvtLtd/splash_master/master/packages/splash_master_rive/preview/ios_rive_splash.gif"><img src="https://raw.githubusercontent.com/SimformSolutionsPvtLtd/splash_master/master/packages/splash_master_rive/preview/ios_rive_splash.gif" height="600px;"/></a> |

---

## Features

- Play **asset, network, or pre-loaded Rive file** animations as a splash screen.
- Automatically defers Flutter's first frame until the animation is ready, keeping the native splash visible during loading.
- Configurable **background color** behind the animation.
- Full control over **artboard, state machine, fit, alignment**, and other Rive options via `RiveConfig`.
- Use a **pre-loaded `RiveFile`** via `RiveFileSource` to skip load time.
- Optional **splash duration** override — defaults to 3 seconds if not set.
- Navigate to the next screen automatically or via a **custom navigation callback**.

---

## Installation

`splash_master_rive` already depends on `splash_master`, so you only need one entry:

```yaml
dependencies:
  splash_master_rive: ^1.0.0
```

### Native splash setup (optional, CLI)

When you also want a native pre-Flutter splash, add a small `splash_master:` block in your app `pubspec.yaml`:

```yaml
splash_master:
  color: '#FFFFFF'
  image: 'assets/splash.png'
```

Then run:

```bash
dart run splash_master create
```

> `splash_master_rive` already includes `splash_master`, so you don't need to add `splash_master` separately for package usage.

## GitHub Copilot Support

This package now supports GitHub Copilot instruction, skill, and prompt files.

- Copy this package's `.github/` files into your app project's `.github/` folder and use them with Copilot.
- Use `.github/prompts/fresh-install.prompt.md` for fresh install flow.
- Use `.github/prompts/auto-migration.prompt.md` for migration flow.
- Use `.github/copilot-instructions.md` and `.github/skills/splash_master_rive/SKILL.md` for package-aware setup and migration guidance.

---

## Quick start

### 1. Declare the asset

```yaml
# pubspec.yaml
flutter:
  assets:
    - assets/animation.riv
```

### 2. Initialize and display

```dart
import 'package:flutter/material.dart';
import 'package:splash_master_rive/splash_master_rive.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  RiveSplash.initialize(); // keeps native splash visible while animation loads
  runApp(const MaterialApp(home: MySplash()));
}

class MySplash extends StatelessWidget {
  const MySplash({super.key});

  @override
  Widget build(BuildContext context) {
    return RiveSplash(
      source: AssetSource('assets/animation.riv'),
      riveConfig: const RiveConfig(),
      backGroundColor: Colors.white,
      nextScreen: const MyHomePage(),
    );
  }
}
```

---

## API Reference

### `RiveSplash`

| Parameter          | Type                     | Default         | Description                                              |
|--------------------|--------------------------|-----------------|----------------------------------------------------------|
| `source`           | `RiveSource`             | —               | Animation source. **Required.** See [Source types](#source-types) below. |
| `riveConfig`       | `RiveConfig`             | `RiveConfig()`  | Rive animation configuration.                            |
| `nextScreen`       | `Widget?`                | `null`          | Widget to navigate to after the splash completes.        |
| `customNavigation` | `VoidCallback?`          | `null`          | Custom navigation callback — overrides `nextScreen` when set. |
| `onSourceLoaded`   | `VoidCallback?`          | `null`          | Called when the source finishes loading. Also resumes Flutter frames unless you override this. |
| `backGroundColor`  | `Color?`                 | `null`          | Background color visible behind the animation.           |

#### Static methods

| Method                     | Description |
|----------------------------|-------------|
| `RiveSplash.initialize()`  | Defers Flutter's first frame. Call in `main()` before `runApp`. |
| `RiveSplash.resume()`      | Resumes frame rendering. Called automatically when the animation loads unless `onSourceLoaded` is overridden. |

---

### `RiveConfig`

| Property               | Type                               | Default                    | Description                                        |
|------------------------|------------------------------------|----------------------------|----------------------------------------------------|
| `artboardSelector`     | `ArtboardSelector`                 | `ArtboardDefault()`        | Select which artboard to use from the Rive file.   |
| `stateMachineSelector` | `StateMachineSelector`             | `StateMachineDefault()`    | Select which state machine to use.                 |
| `fit`                  | `Fit`                              | `Fit.contain`              | How the animation fits within its bounds.          |
| `alignment`            | `Alignment`                        | `Alignment.center`         | Alignment within the parent.                       |
| `onInit`               | `void Function(RiveWidgetController)?` | `null`                | Callback for accessing the Rive controller.        |
| `useSafeArea`          | `bool`                             | `false`                    | Wrap the animation in a `SafeArea`.                |
| `hitTestBehavior`      | `RiveHitTestBehavior`              | `RiveHitTestBehavior.opaque` | Hit-test behavior for the Rive widget.           |
| `cursor`               | `MouseCursor`                      | `MouseCursor.defer`        | Mouse cursor when hovering the animation.          |
| `layoutScaleFactor`    | `double`                           | `1.0`                      | Layout scale factor.                               |
| `placeHolder`          | `Widget?`                          | `null`                     | Placeholder widget while loading.                  |
| `splashDuration`       | `Duration?`                        | `null` (3s fallback)       | Explicit splash duration. Defaults to 3 seconds.   |
| `riveFactory`          | `Factory?`                         | `null`                     | Optional renderer factory override.                |
| `dataBind`             | `DataBind?`                        | `null`                     | Optional data binding selection.                   |
| `controller`           | `Controller?`                      | `null`                     | Optional Rive controller.                          |

**Example — custom splash duration and artboard:**

```dart
RiveConfig(
  splashDuration: const Duration(seconds: 5),
  artboardSelector: const ArtboardByName('MySplash'),
  fit: Fit.cover,
)
```

---

### Source types

Source types are provided by [`splash_master`](../../README.md) and re-exported by this package.

| Type                           | Usage |
|--------------------------------|-------|
| `AssetSource(path)`            | Flutter bundled asset (most common). |
| `NetworkFileSource(url)`       | Remote `.riv` file URL. |
| `RiveFileSource(file)`         | Pre-loaded `rive.File` instance. |

> **Note:** `DeviceFileSource` and `BytesSource` are **not supported** by Rive 0.14.x. Use `AssetSource`, `NetworkFileSource`, or `RiveFileSource` instead.

### Using a pre-loaded Rive File

If you've already loaded a Rive file (e.g., for caching), pass it directly:

```dart
RiveSplash(
  source: RiveFileSource(myPreloadedRiveFile),
  nextScreen: const MyApp(),
);
```

---

## Navigation

**Simple push** — provide `nextScreen`:

```dart
RiveSplash(
  source: AssetSource('assets/animation.riv'),
  nextScreen: const HomeScreen(),
)
```

**Custom navigation** — use `customNavigation` for named routes, deep links, etc.:

```dart
RiveSplash(
  source: AssetSource('assets/animation.riv'),
  customNavigation: () {
    Navigator.of(context).pushReplacementNamed('/home');
  },
)
```

---

## Migration from `splash_master` 0.0.3 to 1.0.0

```dart
// Before (splash_master 0.0.3)
SplashMaster.initialize();
SplashMaster.rive(
  source: AssetSource('assets/animation.riv'),
  nextScreen: const MyApp(),
);

// After (splash_master_rive 1.0.0)
RiveSplash.initialize();
RiveSplash(
  source: AssetSource('assets/animation.riv'),
  nextScreen: const MyApp(),
);
```

---

## Related packages

| Package | What it does |
|---------|--------------|
| [`splash_master`](../../README.md) | Core package — CLI-based native splash generation for Android & iOS, shared types (`Source`, `VisibilityEnum`). |
| [`splash_master_video`](../splash_master_video/README.md) | Video splash screen widget (`VideoSplash`). |
| [`splash_master_lottie`](../splash_master_lottie/README.md) | Lottie animation splash screen widget (`LottieSplash`). |

---

## License

This project is licensed under the MIT License — see the [LICENSE](https://github.com/SimformSolutionsPvtLtd/splash_master/blob/master/LICENSE) file for details.
