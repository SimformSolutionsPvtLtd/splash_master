---
name: splash_master_lottie
description: "**KNOWLEDGE SKILL** — Full domain knowledge for the Splash Master Flutter plugin. USE FOR: any Copilot question or task involving splash_master, splash_master_rive, splash_master_video, splash_master_lottie — including pubspec.yaml config, widget usage, CLI commands, iOS/Android platform behavior, dark mode setup, migration from 1.x, and package structure guidance. INVOKE when user asks how to use splash screen, configure splash keys, migrate from old splash_master API, or integrate any animation widget."
---

# Splash Master — Skill

## Copilot Files Usage

Use this skill together with:

- `copilot-instructions.md` for always-on package guidance.
- `prompts/fresh-install.prompt.md` for new project setup.
- `prompts/auto-migration.prompt.md` for migration from legacy `SplashMaster.*` APIs.

Copy these files into your app project's `.github/` folder to get package-aware Copilot guidance.

## Package Overview

Splash Master is a Flutter plugin for native splash screens with optional animation support, split into a core package and three renderer sub-packages.

### Package Structure

| Package | Purpose | Import |
|---|---|---|
| `splash_master` | CLI tool, native splash generation (Android/iOS), shared types | `package:splash_master/splash_master.dart` |
| `splash_master_rive` | `RiveSplash` widget + `RiveConfig` + `RiveFileSource` | `package:splash_master_rive/splash_master_rive.dart` |
| `splash_master_video` | `VideoSplash` widget + `VideoConfig` | `package:splash_master_video/splash_master_video.dart` |
| `splash_master_lottie` | `LottieSplash` widget + `LottieConfig` | `package:splash_master_lottie/splash_master_lottie.dart` |

> All sub-packages re-export `splash_master` — only one import is needed per Dart file.

---

## Installation

### Image / Color only
```yaml
dependencies:
  splash_master: ^1.0.0
```

### With animation (pick one or more)
```yaml
dependencies:
  splash_master: ^1.0.0
  splash_master_rive: ^1.0.0    # Rive animations
  splash_master_video: ^1.0.0   # Video splash
  splash_master_lottie: ^1.0.0  # Lottie animations
```

---

## pubspec.yaml Configuration Keys

All keys go under `splash_master:` in your project's `pubspec.yaml`.

### Light Mode (Common — Android + iOS)
```yaml
splash_master:
  color: '#FFFFFF'                           # Background color
  image: 'assets/splash.png'                 # Main splash image
  ios_content_mode: 'center'                 # iOS image content mode
  android_gravity: 'center'                  # Android image gravity (pre-12)
  background_image: 'assets/bg.png'          # Optional background image
  ios_background_content_mode: 'scaleToFill' # iOS background image mode
  android_background_image_gravity: 'fill'   # Android background image gravity
```

### Dark Mode
```yaml
splash_master:
  color_dark: '#000000'
  image_dark: 'assets/splash_dark.png'
  android_dark_gravity: 'center'
  background_image_dark: 'assets/bg_dark.png'
```

### Android 12+ Block
```yaml
splash_master:
  android_12_and_above:
    color: '#FFFFFF'
    color_dark: '#000000'
    image: 'assets/splash_12.png'                # 288x288dp recommended
    image_dark: 'assets/splash_12_dark.png'
    branding_image: 'assets/branding.png'        # Android 12+ only, max 80dp height
    branding_image_dark: 'assets/branding_dark.png'
```

### Valid Values

**`ios_content_mode`**: `scaleToFill`, `scaleAspectFit`, `scaleAspectFill`, `redraw`, `center`, `top`, `bottom`, `left`, `right`, `topLeft`, `topRight`, `bottomLeft`, `bottomRight`

**`android_gravity`**: `center`, `clip_horizontal`, `clip_vertical`, `fill_horizontal`, `fill`, `center_vertical`, `bottom`, `fill_vertical`, `center_horizontal`, `top`, `end`, `left`, `right`, `start`

---

## Flutter Widget Usage

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

### Image-only (no animation widget)
```dart
// No Flutter widget needed.
// Configure pubspec.yaml and run: dart run splash_master create
```

---

## CLI Command

After configuring `pubspec.yaml`, run:
```bash
dart run splash_master create
```

---

## Shared Types

| Type | Description |
|---|---|
| `Source` | Base class for asset sources |
| `AssetSource` | Asset from Flutter assets bundle |
| `NetworkSource` | Asset from a URL |
| `VisibilityEnum` | Controls splash visibility behavior |

---

## Migration from 0.0.3 to 1.0.0

| Before (0.0.3)              | After (1.0.0)       | New package |
|-----------------------------|---------------------|---|
| `SplashMaster.rive(...)`    | `RiveSplash(...)`   | `splash_master_rive` |
| `SplashMaster.video(...)`   | `VideoSplash(...)`  | `splash_master_video` |
| `SplashMaster.lottie(...)`  | `LottieSplash(...)` | `splash_master_lottie` |
| `SplashMaster.initialize()` | `No need of it`     | same sub-package |
| `SplashMaster.resume()`     | `No need of it`     | same sub-package |

Apps using only native image/color splash (no animation widget) are **not affected**.

---

## Platform Notes

- **iOS dark mode**: supported via `color_dark`, `image_dark`, `background_image_dark`.
- **Branding images**: Android 12+ only — ignored on iOS.
- **Android 16 KB page size (Rive)**: Add `rive.ndk.version=28.1.13356709` to `android/gradle.properties`.

---

## Copilot Guidance

- Always suggest the correct sub-package: `splash_master_rive` for Rive, `splash_master_video` for video, `splash_master_lottie` for Lottie.
- Never add animation widget code to `splash_master` core — belongs in renderer sub-packages.
- For documentation, update `doc/documentation.md` and the relevant package `README.md`.
- For examples, update `example/` (core) or `packages/<pkg>/example/` (renderer-specific).
- After any `pubspec.yaml` config change, remind the user to run `dart run splash_master create`.
