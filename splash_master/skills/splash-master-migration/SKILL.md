---
name: splash-master-migration
description: >-
  Migrate a Flutter app from splash_master 0.0.x to 1.x: move
  SplashMaster.rive/video/lottie widgets to the splash_master_rive,
  splash_master_video and splash_master_lottie packages, rename legacy
  pubspec.yaml keys, and update RiveConfig to the Rive 0.14 API. Use when
  upgrading splash_master, or when code uses `SplashMaster.rive(`,
  `SplashMaster.video(`, `SplashMaster.lottie(`, `SplashMaster.initialize(`,
  `SplashMaster.resume(`, `RiveArtboardSource(`, `SplashMediaType` or keys
  like `image_dark_android`.
---

# splash_master: migrate 0.0.x → 1.x

In 1.x the animated splash widgets moved out of `splash_master` into one
package per renderer, and the `splash_master:` pubspec config is validated
strictly. The `SplashMaster` class is gone, including its static
`initialize()` and `resume()`. Apps that only use the native image/color splash
need the config changes (step 3) **and** must delete those two calls (see
"Native image/color splash only").

## Workflow

1. **Detect what is used.** Search `lib/` (and every package in a monorepo)
   for `SplashMaster.rive(`, `SplashMaster.video(`, `SplashMaster.lottie(`,
   `SplashMaster.initialize()`, `SplashMaster.resume()`, `RiveConfig(`,
   `RiveArtboardSource(`, `SplashMediaType`. Note
   whether any animation widget is used at all: image-only apps were told to
   call `initialize()` and `resume()` in `main`. Read the `splash_master:`
   block in each `pubspec.yaml`. Report the findings before editing.
2. **Update dependencies.** `flutter pub upgrade --major-versions splash_master`,
   then add one package per renderer found:
   `flutter pub add splash_master_rive` (and/or `splash_master_video`,
   `splash_master_lottie`). Never hard-code versions.
3. **Fix the pubspec config** using the key table below, then run
   `dart run splash_master create` and read its output: it exits with code 0
   even on errors.
4. **Migrate Dart code**: image-only apps follow "Native image/color splash
   only"; apps with an animation widget follow the widget table below.
   Constructor parameters
   (`source`, `nextScreen`, `customNavigation`, `onSourceLoaded`,
   `backGroundColor`, `videoConfig`, `lottieConfig`, `riveConfig`) keep their
   names.
5. **Rive only:** rewrite every `RiveConfig` and `RiveArtboardSource` with
   `references/rive-config.md`. The old fields and source do not compile.
6. Run `flutter analyze` and fix the remaining errors, then run
   `dart run skills@ get` so the new renderer packages' skills are installed.

## Widget changes

| 0.0.x | 1.x | Import |
|---|---|---|
| `SplashMaster.rive(...)` | `SplashMasterRive(...)` | `package:splash_master_rive/splash_master_rive.dart` |
| `SplashMaster.video(...)` | `SplashMasterVideo(...)` | `package:splash_master_video/splash_master_video.dart` |
| `SplashMaster.lottie(...)` | `SplashMasterLottie(...)` | `package:splash_master_lottie/splash_master_lottie.dart` |
| `SplashMaster.initialize()` | `SplashMasterRive.initialize()` / `SplashMasterVideo.initialize()` / `SplashMasterLottie.initialize()` | same package as the widget |
| `SplashMaster.resume()` | **Delete it.** Only inside a custom `onSourceLoaded` callback, rename it to `SplashMasterRive.resume()` / `SplashMasterVideo.resume()` / `SplashMasterLottie.resume()` | same package as the widget |

- Keep `initialize()` in `main`, renamed to the widget's class. It holds the
  native splash on screen until the animation is ready.
- The widget calls its own `resume()` once the source loads. A `resume()` call
  left in `main` releases the first frame before the animation is ready, so
  the user sees a blank frame.
- Replace `import 'package:splash_master/splash_master.dart'` with the renderer
  import. Renderer packages re-export `splash_master`, so `AssetSource`,
  `NetworkFileSource`, `VisibilityEnum` etc. still resolve.
- Two 0.0.x types were removed with no 1.x equivalent:
  - `RiveArtboardSource(artboard)`: see `references/rive-config.md`.
  - `SplashMediaType` (enum `image, video, lottie, rive, custom`): nothing in
    1.x reads it. Delete it, and replace any code that switches on it with
    the choice of widget itself.

Before:

```dart
import 'package:splash_master/splash_master.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SplashMaster.initialize();
  runApp(MaterialApp(
    home: SplashMaster.lottie(
      source: AssetSource('assets/splash.json'),
      nextScreen: const HomeScreen(),
    ),
  ));
}
```

After:

```dart
import 'package:flutter/material.dart';
import 'package:splash_master_lottie/splash_master_lottie.dart';

// HomeScreen is the app's existing first screen.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SplashMasterLottie.initialize();
  runApp(MaterialApp(
    home: SplashMasterLottie(
      source: AssetSource('assets/splash.json'),
      nextScreen: const HomeScreen(),
    ),
  ));
}
```

## Native image/color splash only

Apps without an animation widget don't need a renderer package, but code that
still calls `SplashMaster.initialize()` or `SplashMaster.resume()` fails to
compile (`Undefined name 'SplashMaster'`). Delete both calls, and the
`splash_master` import if nothing else uses it. The native splash stays on
screen until Flutter draws its first frame, so work awaited before `runApp`
still runs while it is visible.

Before:

```dart
import 'package:flutter/material.dart';
import 'package:splash_master/splash_master.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SplashMaster.initialize();
  // Setup your config before the resume.
  SplashMaster.resume();
  runApp(const MyApp());
}
```

After:

```dart
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Setup your config before runApp. MyApp is the app's existing root widget.
  runApp(const MyApp());
}
```

## pubspec config changes

| 0.0.x | 1.x |
|---|---|
| `image_dark_android` | `image_dark` (now also used on iOS) |
| `color_dark_android` | `color_dark` (now also used on iOS) |
| `ios_content_mode: 'aspectFit'` | `'scaleAspectFit'` |
| `ios_content_mode: 'aspectFill'` | `'scaleAspectFill'` |
| top-level `branding_image` (accepted but ignored in 0.0.x) | move it to `android_12_and_above.branding_image` |

These keys did not change: `image`, `color`, `background_image`,
`android_gravity`, `android_background_image_gravity`, `ios_content_mode`,
`ios_background_content_mode`, `android_12_and_above` (with `image`, `color`,
`branding_image` inside).

Behavior changes to check:

- **Strict keys.** Any key not supported in 1.x aborts the CLI with
  `Unsupported key(s) …`. Remove keys that 1.x does not list.
- **`android_dark_gravity`** was accepted but ignored in 0.0.x (the dark image
  used `android_gravity`). In 1.x it takes effect, and falls back to
  `android_gravity` when omitted. If the project already sets it, confirm the
  value is still wanted.
- **`android_12_and_above`** keys must be nested under it and never fall back
  to top-level keys.
- **iOS dark mode** is new: `image_dark` now also produces an iOS dark asset,
  and requires `image` to be set.
- New optional keys: `background_image_dark`, and inside
  `android_12_and_above`: `color_dark`, `image_dark`, `branding_image_dark`.
