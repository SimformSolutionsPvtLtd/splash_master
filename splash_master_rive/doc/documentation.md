# Splash Master Rive Documentation

## Overview

`splash_master_rive` provides `SplashMasterRive`, a Flutter splash widget for playing Rive animations and automatically navigating to your app's next screen.

## Installation

```yaml
dependencies:
  splash_master_rive: ^1.0.0
```

### Minimal splash_master setup (`pubspec.yaml`)

```yaml
splash_master:
  color: '#FFFFFF'
  image: 'assets/splash.png'
```

Then run:

```bash
dart run splash_master create
```

For full key reference, check our [documentation](https://simform-flutter-packages.web.app/splashMaster).

## Basic Usage

### 1. Declare Rive asset

```yaml
flutter:
  assets:
    - assets/animation.riv
```

### 2. Initialize and use SplashMasterRive

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
      riveConfig: const RiveConfig(),
      backGroundColor: Colors.white,
      nextScreen: const Placeholder(),
    );
  }
}
```

## Advanced Usage

### Custom navigation callback

```dart
SplashMasterRive(
  source: AssetSource('assets/animation.riv'),
  customNavigation: () {
    Navigator.of(context).pushReplacementNamed('/home');
  },
)
```

### Use a preloaded Rive file

```dart
SplashMasterRive(
  source: RiveFileSource(myPreloadedRiveFile),
  nextScreen: const Placeholder(),
)
```

### Customize playback behavior

```dart
const RiveConfig(
  splashDuration: Duration(seconds: 5),
  fit: Fit.cover,
)
```

## API Reference

### SplashMasterRive

- `source`: `RiveSource` (required)
- `riveConfig`: `RiveConfig`
- `nextScreen`: `Widget?`
- `customNavigation`: `VoidCallback?`
- `onSourceLoaded`: `VoidCallback?`
- `backGroundColor`: `Color?`

Static methods:

- `SplashMasterRive.initialize()`
- `SplashMasterRive.resume()`

### Source Types

- `AssetSource(path)`
- `NetworkFileSource(url)`
- `RiveFileSource(file)`

## Migration

Legacy API mappings:

- `SplashMaster.rive(...)` -> `SplashMasterRive(...)`
- `SplashMaster.initialize()` -> `SplashMasterRive.initialize()`
- `SplashMaster.resume()` -> `SplashMasterRive.resume()`
