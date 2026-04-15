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
      riveConfig: const RiveConfig(),
      backGroundColor: Colors.white,
      nextScreen: const MyApp(),
    );
  }
}
```

### Using a pre-loaded Rive File

```dart
RiveSplash(
  source: RiveFileSource(myPreloadedRiveFile),
  nextScreen: const MyApp(),
);
```

> Note: `DeviceFileSource` and `BytesSource` are not supported by Rive 0.14.x.
> Use `AssetSource`, `NetworkFileSource`, or `RiveFileSource`.

## API

### `RiveSplash`

| Parameter          | Type                     | Description                                      |
|--------------------|--------------------------|--------------------------------------------------|
| `source`           | `RiveSource`             | Asset/network source or pre-loaded Rive file     |
| `riveConfig`       | `RiveConfig`             | Animation configuration (optional)               |
| `nextScreen`       | `Widget?`                | Screen to push after splash completes            |
| `customNavigation` | `VoidCallback?`          | Custom nav — overrides `nextScreen`              |
| `onSourceLoaded`   | `VoidCallback?`          | Called when source finishes loading              |
| `backGroundColor`  | `Color?`                 | Splash background color                          |

### `RiveConfig`

Key `RiveConfig` properties:

| Property          | Default             | Description                          |
|-------------------|---------------------|--------------------------------------|
| `artboardSelector` | `ArtboardDefault()` | Select artboard from file            |
| `stateMachineSelector` | `StateMachineDefault()` | Select state machine             |
| `fit`             | `Fit.contain`       | How animation fits in bounds         |
| `splashDuration`  | `null` (3s fallback) | Optional splash duration override    |
| `riveFactory`     | `null`              | Optional renderer factory override   |
| `dataBind`        | `null`              | Optional data binding selection      |

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
