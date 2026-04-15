# splash_master_rive

Rive animation splash screen widget for the [`splash_master`](../../README.md) ecosystem.

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  splash_master_rive:
    path: ../packages/splash_master_rive  # adjust path as needed
```

## Usage

```dart
import 'package:splash_master_rive/splash_master_rive.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  RiveSplash.initialize(); // defers first frame while loading
  runApp(
    const MaterialApp(
      home: RiveSplashScreen(),
    ),
  );
}

class RiveSplashScreen extends StatelessWidget {
  const RiveSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RiveSplash(
      source: AssetSource('assets/animation.riv'),
      riveConfig: const RiveConfig(autoplay: true),
      backGroundColor: Colors.white,
      nextScreen: const MyApp(),
    );
  }
}
```

### Using a pre-loaded Artboard

```dart
RiveSplash(
  source: RiveArtboardSource(myPreloadedArtboard),
  nextScreen: const MyApp(),
);
```

## API

### `RiveSplash`

| Parameter          | Type                     | Description                                      |
|--------------------|--------------------------|--------------------------------------------------|
| `source`           | `RiveSource`             | Asset/file/network/bytes or pre-loaded artboard  |
| `riveConfig`       | `RiveConfig`             | Animation configuration (optional)               |
| `nextScreen`       | `Widget?`                | Screen to push after splash completes            |
| `customNavigation` | `VoidCallback?`          | Custom nav — overrides `nextScreen`              |
| `onSourceLoaded`   | `VoidCallback?`          | Called when source finishes loading              |
| `backGroundColor`  | `Color?`                 | Splash background color                          |

### `RiveConfig`

All properties from the original `RiveConfig` are available. Key ones:

| Property          | Default             | Description                          |
|-------------------|---------------------|--------------------------------------|
| `autoplay`        | `true`              | Play automatically on load           |
| `animations`      | `[]`                | Named animations to play             |
| `stateMachineName`| `[]`                | State machine names to activate      |
| `splashDuration`  | `null` (auto)       | Override splash duration             |
| `fit`             | `BoxFit.contain`    | How animation fits in bounds         |

## Migration from `splash_master` 1.x

```dart
// Before (splash_master 1.x)
SplashMaster.rive(
  source: AssetSource('assets/animation.riv'),
  nextScreen: const MyApp(),
);

// After (splash_master_rive 2.x)
RiveSplash(
  source: AssetSource('assets/animation.riv'),
  nextScreen: const MyApp(),
);
```
