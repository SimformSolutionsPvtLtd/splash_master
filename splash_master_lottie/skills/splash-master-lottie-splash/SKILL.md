---
name: splash-master-lottie-splash
description: >-
  Show a Lottie (.json) animation as the app's splash screen with
  SplashMasterLottie and LottieConfig, handing off from the native splash and
  navigating to the next screen when the animation ends. Use when adding,
  configuring or debugging a Lottie splash, or when code uses
  SplashMasterLottie or LottieConfig.
---

# splash_master_lottie: Lottie splash screen

`SplashMasterLottie` plays a Lottie animation with the `lottie` package, then
navigates to the next screen after one run of the animation. It runs after the
native splash, which `splash_master` generates.

## Workflow

1. **Inspect the project.** Find the Lottie file, the app entry point
   (`main()`), and how the app navigates (`MaterialApp` routes, go_router,
   auto_route…). Check for an existing `splash_master:` block in
   `pubspec.yaml`.
2. **Add the dependency:** `flutter pub add splash_master_lottie`.
   It already includes `splash_master`, which provides the
   `dart run splash_master create` CLI; no need to add it separately.
3. **Declare the asset** under `flutter: assets:` in `pubspec.yaml`.
4. **Wire `main()` and the widget** as in the examples below.
5. **Set up the native splash** (same background color, ideally the
   animation's first frame as the image, so the hand-off is seamless):
   follow `references/native-splash.md` (all keys: `references/config-keys.md`).
6. Run `flutter analyze`, then test with a cold start on a device.

## Rules

- Import only `package:splash_master_lottie/splash_master_lottie.dart`. It
  re-exports `splash_master` (`AssetSource`, `VisibilityEnum`, …). Lottie types
  (`FrameRate`, `LottieDelegates`, `LottieOptions`) need
  `package:lottie/lottie.dart`; add `lottie` as a direct dependency when the
  app references them.
- Call `SplashMasterLottie.initialize()` in `main()` after
  `WidgetsFlutterBinding.ensureInitialized()` and before `runApp`. It holds
  the native splash on screen until the animation has loaded, so there is no
  blank frame in between.
- The widget calls `SplashMasterLottie.resume()` when the animation loads.
  Passing `onSourceLoaded` **replaces** that call: your callback must call
  `SplashMasterLottie.resume()`, or the app stays frozen on the native splash.
- `initialize()` without a `SplashMasterLottie` in the first route has the same
  effect: nothing ever calls `resume()`.
- **If the animation fails to load, `resume()` is never called**, so with
  `initialize()` the app stays on the native splash. Use a bundled
  `AssetSource`. For `NetworkFileSource` / `DeviceFileSource`, do not call
  `initialize()`.
- Navigation happens after **one run** of the animation (the composition's
  duration), even when `repeat: true`.
- Navigate with `nextScreen` (uses `Navigator.pushReplacement`, so the widget
  needs a `Navigator` above it, e.g. `MaterialApp.home`) or with
  `customNavigation`, which takes precedence. With neither, the splash stays.
- `overrideBoxFit` defaults to `true` and forces `BoxFit.fill`, which ignores
  `fit`. Set `overrideBoxFit: false` to use `fit` (e.g. `BoxFit.contain`).
- Match `backGroundColor` to the native splash `color`.

## Examples

Basic:

```dart
import 'package:flutter/material.dart';
import 'package:splash_master_lottie/splash_master_lottie.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SplashMasterLottie.initialize();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashMasterLottie(
        source: AssetSource('assets/splash.json'),
        backGroundColor: Colors.white,
        nextScreen: const HomeScreen(),
      ),
    );
  }
}

// Stands in for the app's real first screen.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold();
}
```

The examples below use the imports and `HomeScreen` from **Basic**.

Keep the animation's aspect ratio instead of stretching it:

```dart
Widget buildSplash() => SplashMasterLottie(
      source: AssetSource('assets/splash.json'),
      lottieConfig: const LottieConfig(
        visibilityEnum: VisibilityEnum.none,
        overrideBoxFit: false,
        fit: BoxFit.contain,
        width: 240,
      ),
      nextScreen: const HomeScreen(),
    );
```

Router-based app (go_router, after `flutter pub add go_router`): navigate
with a top-level router reference, not a context, and pass `router` to
`MaterialApp.router(routerConfig: router)`.

```dart
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => SplashMasterLottie(
      source: AssetSource('assets/splash.json'),
      customNavigation: () => router.go('/home'),
    ),
  ),
  GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
]);
```

## LottieConfig

| Field | Default | Notes |
|---|---|---|
| `visibilityEnum` | `VisibilityEnum.useFullScreen` | `useFullScreen` sizes to the screen; `useAspectRatio` uses `aspectRatio`; `none` uses `width`/`height` |
| `aspectRatio` | `9 / 16` | Only with `useAspectRatio` |
| `overrideBoxFit` | `true` | Forces `BoxFit.fill`; set `false` to honor `fit` |
| `fit`, `alignment`, `width`, `height` | `null` | Passed to `LottieBuilder` |
| `repeat` | `false` | Does not extend the splash time |
| `animate`, `reverse`, `frameRate`, `controller` | `null` | Passed to `LottieBuilder` |
| `onLoaded` | `null` | Receives the `LottieComposition` |
| `delegates`, `options`, `renderCache`, `filterQuality`, `addRepaintBoundary` | `null` | Passed to `LottieBuilder` |
| `errorBuilder`, `onWarning` | `null` | Error widget and warnings |

## Troubleshooting

- App frozen on the native splash → the animation failed to load, or
  `onSourceLoaded` does not call `resume()`, or `initialize()` was called but
  the splash widget is not the first route.
- Animation looks stretched → `overrideBoxFit: false` with a `fit`, or a
  different `visibilityEnum`.
- Splash ends before the user sees the loop → navigation always follows one
  composition duration; lengthen the animation itself.
