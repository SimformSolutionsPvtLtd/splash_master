# Splash Master Lottie Documentation

## Overview

`splash_master_lottie` provides `SplashMasterLottie`, a Flutter splash widget for playing Lottie animations and navigating to your app's next screen.

## Installation

```yaml
dependencies:
  splash_master_lottie: ^1.0.0
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

### 1. Declare animation asset

```yaml
flutter:
  assets:
    - assets/animation.json
```

### 2. Initialize and use SplashMasterLottie

```dart
import 'package:flutter/material.dart';
import 'package:splash_master_lottie/splash_master_lottie.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SplashMasterLottie.initialize();
  runApp(const MaterialApp(home: MySplash()));
}

class MySplash extends StatelessWidget {
  const MySplash({super.key});

  @override
  Widget build(BuildContext context) {
    return SplashMasterLottie(
      source: AssetSource('assets/animation.json'),
      lottieConfig: const LottieConfig(repeat: false),
      backGroundColor: Colors.white,
      nextScreen: const Placeholder(),
    );
  }
}
```

## Advanced Usage

### Configure Lottie behavior

```dart
const LottieConfig(
  repeat: false,
  reverse: false,
  visibilityEnum: VisibilityEnum.useAspectRatio,
)
```

### Custom navigation callback

```dart
SplashMasterLottie(
  source: AssetSource('assets/animation.json'),
  customNavigation: () {
    Navigator.of(context).pushReplacementNamed('/home');
  },
)
```

### Source options

- `AssetSource(path)`
- `DeviceFileSource(path)`
- `NetworkFileSource(url)`
- `BytesSource(bytes)`

## API Reference

### SplashMasterLottie

- `source`: `Source` (required)
- `lottieConfig`: `LottieConfig`
- `nextScreen`: `Widget?`
- `customNavigation`: `VoidCallback?`
- `onSourceLoaded`: `VoidCallback?`
- `backGroundColor`: `Color?`

Static methods:

- `SplashMasterLottie.initialize()`
- `SplashMasterLottie.resume()`

## Migration

Legacy API mappings:

- `SplashMaster.lottie(...)` -> `SplashMasterLottie(...)`
- `SplashMaster.initialize()` -> `SplashMasterLottie.initialize()`
- `SplashMaster.resume()` -> `SplashMasterLottie.resume()`
