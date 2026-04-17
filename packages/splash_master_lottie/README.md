![Banner](preview/banner.png)

# splash Master Lottie

[![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/SimformSolutionsPvtLtd/splash_master/blob/master/LICENSE)

Lottie animation splash screen widget for the [Splash Master](../../README.md) ecosystem. Display a Lottie JSON animation as your Flutter app's animated splash screen, with automatic transition to your main app once playback finishes.

> **Part of the splash_master family** — the core CLI/native-image package is [`splash_master`](../../README.md). For other animation types, see [`splash_master_rive`](../splash_master_rive/README.md) (Rive) and [`splash_master_video`](../splash_master_video/README.md) (Video).

## Preview

| Android                                                                                                                                                                                                                    | iOS                                                                                                                                                                                                                                                                                                                            |
|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| <a href="https://raw.githubusercontent.com/SimformSolutionsPvtLtd/splash_master/master/packages/splash_master_lottie/preview/android_lottie_splash.gif"><img src="https://raw.githubusercontent.com/SimformSolutionsPvtLtd/splash_master/master/packages/splash_master_lottie/preview/android_lottie_splash.gif" height="600px;"/></a> | <a href="https://raw.githubusercontent.com/SimformSolutionsPvtLtd/splash_master/master/packages/splash_master_lottie/preview/ios_lottie_splash.gif"><img src="https://raw.githubusercontent.com/SimformSolutionsPvtLtd/splash_master/master/packages/splash_master_lottie/preview/ios_lottie_splash.gif" height="600px;"/></a> |

---

## Features

- Play **asset, device file, network, or in-memory byte** Lottie animations as a splash screen.
- Automatically defers Flutter's first frame until the animation is ready, keeping the native splash visible during loading.
- Configurable **background color** behind the animation.
- **Fullscreen** or **aspect-ratio-preserving** display modes.
- Fine-grained control over **repeat, reverse, frame rate**, and other Lottie options via `LottieConfig`.
- Navigate to the next screen automatically or via a **custom navigation callback**.

---

## Installation

`splash_master_lottie` already depends on `splash_master`, so you only need one entry:

```yaml
dependencies:
  splash_master_lottie: ^1.0.0
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

> `splash_master_lottie` already includes `splash_master`, so you don't need to add `splash_master` separately for package usage.

## GitHub Copilot Support

This package now supports GitHub Copilot instruction, skill, and prompt files.

- Copy this package's `.github/` files into your app project's `.github/` folder and use them with Copilot.
- Use `.github/prompts/fresh-install.prompt.md` for fresh install flow.
- Use `.github/prompts/auto-migration.prompt.md` for migration flow.
- Use `.github/copilot-instructions.md` and `.github/skills/splash_master_lottie/SKILL.md` for package-aware setup and migration guidance.

---

## Quick start

### 1. Declare the asset

```yaml
# pubspec.yaml
flutter:
  assets:
    - assets/animation.json
```

### 2. Initialize and display

```dart
import 'package:flutter/material.dart';
import 'package:splash_master_lottie/splash_master_lottie.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LottieSplash.initialize(); // keeps native splash visible while animation loads
  runApp(const MaterialApp(home: MySplash()));
}

class MySplash extends StatelessWidget {
  const MySplash({super.key});

  @override
  Widget build(BuildContext context) {
    return LottieSplash(
      source: AssetSource('assets/animation.json'),
      lottieConfig: const LottieConfig(repeat: false),
      backGroundColor: Colors.white,
      nextScreen: const MyHomePage(),
    );
  }
}
```

---

## API Reference

### `LottieSplash`

| Parameter          | Type            | Default         | Description                                              |
|--------------------|-----------------|-----------------|----------------------------------------------------------|
| `source`           | `Source`        | —               | Animation source. **Required.** See [Source types](#source-types) below. |
| `lottieConfig`     | `LottieConfig`  | `LottieConfig()`| Lottie animation configuration.                          |
| `nextScreen`       | `Widget?`       | `null`          | Widget to navigate to after the animation ends.          |
| `customNavigation` | `VoidCallback?` | `null`          | Custom navigation callback — overrides `nextScreen` when set. |
| `onSourceLoaded`   | `VoidCallback?` | `null`          | Called when the composition finishes loading. Also resumes Flutter frames unless you override this. |
| `backGroundColor`  | `Color?`        | `null`          | Background color visible behind the animation.           |

#### Static methods

| Method                       | Description |
|------------------------------|-------------|
| `LottieSplash.initialize()`  | Defers Flutter's first frame. Call in `main()` before `runApp`. |
| `LottieSplash.resume()`      | Resumes frame rendering. Called automatically when the animation loads unless `onSourceLoaded` is overridden. |

---

### `LottieConfig`

| Property           | Type                              | Default                          | Description                                                     |
|--------------------|-----------------------------------|----------------------------------|-----------------------------------------------------------------|
| `repeat`           | `bool?`                           | `false`                          | Loop the animation.                                             |
| `animate`          | `bool?`                           | `null` (auto)                    | Whether to play automatically.                                  |
| `reverse`          | `bool?`                           | `null`                           | Play the animation in reverse.                                  |
| `controller`       | `Animation<double>?`              | `null`                           | Custom animation controller for manual control.                 |
| `frameRate`        | `FrameRate?`                      | `null`                           | Target frame rate.                                              |
| `onLoaded`         | `void Function(LottieComposition)?` | `null`                         | Called when the composition is loaded.                           |
| `delegates`        | `LottieDelegates?`                | `null`                           | Dynamic property delegates.                                     |
| `options`          | `LottieOptions?`                  | `null`                           | Additional Lottie rendering options.                            |
| `width`            | `double?`                         | `null`                           | Fixed width.                                                    |
| `height`           | `double?`                         | `null`                           | Fixed height.                                                   |
| `fit`              | `BoxFit?`                         | `null`                           | How the animation fits within its bounds.                       |
| `alignment`        | `AlignmentGeometry?`              | `null`                           | Alignment within the parent.                                    |
| `filterQuality`    | `FilterQuality?`                  | `null`                           | Image filter quality.                                           |
| `onWarning`        | `WarningCallback?`                | `null`                           | Callback for Lottie warnings.                                   |
| `errorBuilder`     | `ImageErrorWidgetBuilder?`        | `null`                           | Widget builder for error states.                                |
| `renderCache`      | `RenderCache?`                    | `null`                           | Cache rendered frames for performance.                          |
| `overrideBoxFit`   | `bool`                            | `true`                           | Apply `BoxFit.fill` to remove padding.                          |
| `aspectRatio`      | `double`                          | `9 / 16`                         | Used when `visibilityEnum` is `useAspectRatio`.                 |
| `visibilityEnum`   | `VisibilityEnum`                  | `VisibilityEnum.useFullScreen`   | `useFullScreen` stretches to fill; `useAspectRatio` preserves ratio. |

---

### Source types

Source types are provided by [`splash_master`](../../README.md) and re-exported by this package.

| Type                        | Usage |
|-----------------------------|-------|
| `AssetSource(path)`         | Flutter bundled asset (most common). |
| `DeviceFileSource(path)`    | Local file path on the device. |
| `NetworkFileSource(url)`    | Remote animation URL. |
| `BytesSource(bytes)`        | In-memory `Uint8List`. |

---

## Navigation

**Simple push** — provide `nextScreen`:

```dart
LottieSplash(
  source: AssetSource('assets/animation.json'),
  nextScreen: const HomeScreen(),
)
```

**Custom navigation** — use `customNavigation` for named routes, deep links, etc.:

```dart
LottieSplash(
  source: AssetSource('assets/animation.json'),
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
SplashMaster.lottie(
  source: AssetSource('assets/animation.json'),
  nextScreen: const MyApp(),
);

// After (splash_master_lottie 1.0.0)
LottieSplash.initialize();
LottieSplash(
  source: AssetSource('assets/animation.json'),
  nextScreen: const MyApp(),
);
```

---

## Related packages

| Package | What it does |
|---------|--------------|
| [`splash_master`](../../README.md) | Core package — CLI-based native splash generation for Android & iOS, shared types (`Source`, `VisibilityEnum`). |
| [`splash_master_rive`](../splash_master_rive/README.md) | Rive animation splash screen widget (`RiveSplash`). |
| [`splash_master_video`](../splash_master_video/README.md) | Video splash screen widget (`VideoSplash`). |

---

## License

This project is licensed under the MIT License — see the [LICENSE](https://github.com/SimformSolutionsPvtLtd/splash_master/blob/master/LICENSE) file for details.
