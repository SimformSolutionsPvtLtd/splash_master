# Splash Master — GitHub Copilot Skill

> Copy this file into your project's `.github/copilot-instructions.md` (or `.github/instructions/`) to give Copilot full knowledge of the Splash Master package ecosystem.

## Copilot Files Usage

Use this file together with the matching `.github` support files:

- `prompts/fresh-install.prompt.md` for fresh install setup.
- `prompts/auto-migration.prompt.md` for migration from legacy `SplashMaster.*` APIs.
- `skills/splash_master_lottie/SKILL.md` for package knowledge while Copilot works.

You can copy the full `.github/` folder from this repository (or from any renderer package) into your app project and use it directly with GitHub Copilot.

---

## Package Overview

Splash Master is a Flutter plugin for adding native splash screens with optional animation support.

### Package Structure

| Package | Purpose | Import |
|---|---|---|
| `splash_master` | CLI tool, native splash generation (Android/iOS), shared types | `package:splash_master/splash_master.dart` |
| `splash_master_rive` | `SplashMasterRive` widget + `RiveConfig` + `RiveFileSource` | `package:splash_master_rive/splash_master_rive.dart` |
| `splash_master_video` | `SplashMasterVideo` widget + `VideoConfig` | `package:splash_master_video/splash_master_video.dart` |
| `splash_master_lottie` | `SplashMasterLottie` widget + `LottieConfig` | `package:splash_master_lottie/splash_master_lottie.dart` |

All sub-packages re-export `splash_master`, so only one import is needed per file.

---

## Installation

### Image / Color only (no animation library required)
```yaml
dependencies:
  splash_master: ^1.0.0
```

### With animation widgets (pick one or more)
```yaml
dependencies:
  splash_master: ^1.0.0
  splash_master_rive: ^1.0.0    # Rive animations
  splash_master_video: ^1.0.0   # Video splash
  splash_master_lottie: ^1.0.0  # Lottie animations
```

---

## pubspec.yaml Configuration Keys

All keys go under the `splash_master:` section in `pubspec.yaml`.

### Common (Android + iOS), Light Mode
```yaml
splash_master:
  color: '#FFFFFF'                           # Background color
  image: 'assets/splash.png'                 # Main splash image
  ios_content_mode: 'center'                 # iOS image content mode
  android_gravity: 'center'                  # Android image gravity (pre-12)
  background_image: 'assets/bg.png'          # Optional background image
  ios_background_content_mode: 'scaleToFill' # iOS background content mode
  android_background_image_gravity: 'fill'   # Android background image gravity
```

### Common (Android + iOS), Dark Mode
```yaml
splash_master:
  color_dark: '#000000'
  image_dark: 'assets/splash_dark.png'
  android_dark_gravity: 'center'
  background_image_dark: 'assets/bg_dark.png'
```

### Android 12+ Specific
```yaml
splash_master:
  android_12_and_above:
    color: '#FFFFFF'
    color_dark: '#000000'
    image: 'assets/splash_12.png'
    image_dark: 'assets/splash_12_dark.png'
    branding_image: 'assets/branding.png'       # Bottom branding, Android 12+ only
    branding_image_dark: 'assets/branding_dark.png'
```

### ios_content_mode / android_gravity valid values
- `ios_content_mode`: `scaleToFill`, `scaleAspectFit`, `scaleAspectFill`, `redraw`, `center`, `top`, `bottom`, `left`, `right`, `topLeft`, `topRight`, `bottomLeft`, `bottomRight`
- `android_gravity`: `center`, `clip_horizontal`, `clip_vertical`, `fill_horizontal`, `fill`, `center_vertical`, `bottom`, `fill_vertical`, `center_horizontal`, `top`, `end`, `left`, `right`, `start`

---

## Flutter Widget Usage

### Rive
```dart
import 'package:splash_master_rive/splash_master_rive.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SplashMasterRive.initialize();
  runApp(
    MaterialApp(
      home: SplashMasterRive(
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
  SplashMasterVideo.initialize();
  runApp(
    MaterialApp(
      home: SplashMasterVideo(
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
  SplashMasterLottie.initialize();
  runApp(
    MaterialApp(
      home: SplashMasterLottie(
        source: AssetSource('assets/animation.json'),
        nextScreen: const MyApp(),
      ),
    ),
  );
}
```

### Image-only (no animation widget needed)
```dart
import 'package:splash_master/splash_master.dart';
// No widget needed — native splash is configured purely via pubspec.yaml + CLI.
// The native splash transitions to your Flutter app automatically.
```

---

## CLI Command

After configuring `pubspec.yaml`, generate native splash assets:
```bash
dart run splash_master create
```

---

## Shared Types (from splash_master)

| Type | Description |
|---|---|
| `Source` | Base class for asset sources |
| `AssetSource` | Asset source from Flutter assets |
| `NetworkSource` | Asset source from a URL |
| `VisibilityEnum` | Controls splash visibility behavior |

---

## Migration from 0.0.3 to 1.0.0

| Before (0.0.3)             | After (1.0.0)       | New package |
|----------------------------|---------------------|---|
| `SplashMaster.rive(...)`   | `SplashMasterRive(...)`   | `splash_master_rive` |
| `SplashMaster.video(...)`  | `SplashMasterVideo(...)`  | `splash_master_video` |
| `SplashMaster.lottie(...)` | `SplashMasterLottie(...)` | `splash_master_lottie` |
| `SplashMaster.initialize()` | `No need of it`     | same sub-package |
| `SplashMaster.resume()`    | `No need of it`              | same sub-package |

Apps using **only** native image/color splash (CLI only, no animation widget) are **not affected**.

---

## Platform Notes

- **iOS dark mode**: fully supported via `color_dark`, `image_dark`, `background_image_dark` keys.
- **Branding images**: Android 12+ only — `branding_image` and `branding_image_dark` are ignored on iOS.
- **Android 16 KB page size (Rive)**: Add `rive.ndk.version=28.1.13356709` to `android/gradle.properties`.

---

## Copilot Guidance

When assisting with this project:
- Always suggest the correct sub-package for the animation type: `splash_master_rive` for Rive, `splash_master_video` for video, `splash_master_lottie` for Lottie.
- Never add animation widget code directly to `splash_master` — it belongs in the renderer-specific sub-packages.
- For documentation changes, update `doc/documentation.md` and the relevant package `README.md`.
- For examples, update `example/` (core) or `packages/<pkg>/example/` (renderer-specific).
- After any `pubspec.yaml` config change, remind the user to run `dart run splash_master create`.
