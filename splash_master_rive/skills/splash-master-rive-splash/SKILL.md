---
name: splash-master-rive-splash
description: >-
  Show a Rive (.riv) animation as the app's splash screen with
  SplashMasterRive and RiveConfig (Rive 0.14 API), handing off from the native
  splash and navigating to the next screen. Use when adding, configuring or
  debugging a Rive splash, or when code uses SplashMasterRive, RiveConfig or
  RiveFileSource.
---

# splash_master_rive: Rive splash screen

`SplashMasterRive` plays a Rive file full-screen, then navigates to the next
screen. It runs after the native splash, which `splash_master` generates.

## Workflow

1. **Inspect the project.** Find the `.riv` file, the app entry point
   (`main()`), and how the app navigates (`MaterialApp` routes, go_router,
   auto_route…). Check for an existing `splash_master:` block in
   `pubspec.yaml`.
2. **Add the dependency:** `flutter pub add splash_master_rive` (Dart SDK
   ≥ 3.6). It already includes `splash_master`, which provides the
   `dart run splash_master create` CLI; no need to add it separately.
3. **Declare the asset** under `flutter: assets:` in `pubspec.yaml`.
4. **Wire `main()` and the widget** as in the examples below.
5. **Set up the native splash** (same background color as the Rive splash, so
   the hand-off is seamless): follow
   `references/native-splash.md` (all keys: `references/config-keys.md`).
6. Run `flutter analyze`, then test with a cold start on a device.

## Rules

- Import only `package:splash_master_rive/splash_master_rive.dart`. It
  re-exports `splash_master` (`AssetSource`, `NetworkFileSource`, …).
- Rive types used in `RiveConfig` (`Fit`, `ArtboardSelector`,
  `StateMachineSelector`, `RiveWidgetController`) come from
  `package:rive/rive.dart`. When the app references them, also run
  `flutter pub add rive` so the import is a direct dependency.
- Call `SplashMasterRive.initialize()` in `main()` after
  `WidgetsFlutterBinding.ensureInitialized()` and before `runApp`. It holds
  the native splash on screen until the Rive file has loaded, so there is no
  blank frame in between.
- The widget calls `SplashMasterRive.resume()` when the file loads (or fails).
  Passing `onSourceLoaded` **replaces** that call: your callback must call
  `SplashMasterRive.resume()`, or the app stays frozen on the native splash.
- `initialize()` without a `SplashMasterRive` in the first route has the same
  effect: nothing ever calls `resume()`.
- Navigation happens `splashDuration` after the file loads (default **3
  seconds**). It does not wait for the animation to end: set `splashDuration`
  to the animation's length.
- Navigate with `nextScreen` (uses `Navigator.pushReplacement`, so the widget
  needs a `Navigator` above it, e.g. `MaterialApp.home`) or with
  `customNavigation`, which takes precedence. With neither, the splash stays.
- Sources: `AssetSource`, `NetworkFileSource`, or `RiveFileSource` (an already
  loaded `rive.File`). `DeviceFileSource` and `BytesSource` are **not
  supported**: the widget skips the animation, shows `placeHolder` (or a
  fallback message when it is null), and navigates after `splashDuration`.
- If the file fails to load, the widget shows an error text, still resumes,
  and navigates after `splashDuration`. Prefer `AssetSource` for the splash.
- Match `backGroundColor` to the native splash `color`.

## Examples

Basic:

```dart
import 'package:flutter/material.dart';
import 'package:splash_master_rive/splash_master_rive.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SplashMasterRive.initialize();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashMasterRive(
        source: AssetSource('assets/splash.riv'),
        backGroundColor: Colors.white,
        riveConfig: const RiveConfig(
          splashDuration: Duration(milliseconds: 2400),
        ),
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

Specific artboard and state machine, with access to the controller:

```dart
import 'package:rive/rive.dart' show ArtboardSelector, Fit, StateMachineSelector;

Widget buildSplash() => SplashMasterRive(
      source: AssetSource('assets/splash.riv'),
      riveConfig: RiveConfig(
        artboardSelector: ArtboardSelector.byName('Splash'),
        stateMachineSelector: StateMachineSelector.byName('Intro'),
        fit: Fit.cover,
        splashDuration: const Duration(seconds: 2),
        onInit: (controller) {
          // controller.artboard, controller.stateMachine
        },
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
    builder: (context, state) => SplashMasterRive(
      source: AssetSource('assets/splash.riv'),
      customNavigation: () => router.go('/home'),
    ),
  ),
  GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
]);
```

Custom `onSourceLoaded`: always resume.

```dart
Widget buildSplash() => SplashMasterRive(
      source: AssetSource('assets/splash.riv'),
      onSourceLoaded: () {
        debugPrint('splash loaded'); // your own work here
        SplashMasterRive.resume();
      },
      nextScreen: const HomeScreen(),
    );
```

## RiveConfig

| Field | Default | Notes |
|---|---|---|
| `artboardSelector` | `ArtboardDefault()` | `ArtboardSelector.byName/byIndex` |
| `stateMachineSelector` | `StateMachineDefault()` | `StateMachineSelector.byName/byIndex` |
| `fit` | `Fit.contain` | Rive `Fit`, not Flutter `BoxFit` |
| `alignment` | `Alignment.center` | |
| `splashDuration` | `null` → 3 s | Time on screen after load |
| `placeHolder` | `null` → progress indicator | Shown while loading |
| `onInit` | `null` | Receives `RiveWidgetController` |
| `useSafeArea` | `false` | |
| `hitTestBehavior`, `cursor`, `layoutScaleFactor` | Rive defaults | |
| `riveFactory`, `dataBind`, `controller` | `null` | Advanced Rive 0.14 options |

## Troubleshooting

- App frozen on the native splash → `onSourceLoaded` without `resume()`, or
  `initialize()` called but the splash widget is not the first route.
- "Unsupported source type for Rive 0.14.x" → switch from `DeviceFileSource` /
  `BytesSource` to a supported source.
- Animation cut off or ends early → set `splashDuration` to its length.
- Android build error about the NDK version → Rive 0.14 builds with the
  app's NDK. Set `ndkVersion` in `android/app/build.gradle(.kts)`; Rive
  recommends `27.2.12479018`. `rive.ndk.version` in `gradle.properties` is a
  Rive 0.13 setting and has no effect.
- Migrating old `RiveConfig` fields (`artboardName`, `stateMachineName`,
  `BoxFit`, `animations`) → use the `splash-master-migration` skill. It ships
  with `splash_master` and is installed only when `splash_master` is a direct
  dependency: `flutter pub add splash_master`, then `dart run skills@ get`.
