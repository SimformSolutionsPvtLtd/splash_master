# Splash Master Video Documentation

## Overview

`splash_master_video` provides `SplashMasterVideo`, a Flutter splash widget for playing video sources and then navigating to your app's next screen.

## Installation

```yaml
dependencies:
  splash_master_video: ^1.0.0
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

### 1. Declare video asset

```yaml
flutter:
  assets:
    - assets/splash.mp4
```

### 2. Initialize and use SplashMasterVideo

```dart
import 'package:flutter/material.dart';
import 'package:splash_master_video/splash_master_video.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SplashMasterVideo.initialize();
  runApp(const MaterialApp(home: MySplash()));
}

class MySplash extends StatelessWidget {
  const MySplash({super.key});

  @override
  Widget build(BuildContext context) {
    return SplashMasterVideo(
      source: AssetSource('assets/splash.mp4'),
      videoConfig: const VideoConfig(
        videoVisibilityEnum: VisibilityEnum.useAspectRatio,
      ),
      backGroundColor: Colors.black,
      nextScreen: const Placeholder(),
    );
  }
}
```

## Advanced Usage

### Manual playback control

```dart
const VideoConfig(
  playImmediately: false,
  onVideoControllerInitialised: (controller) {
    controller.play();
  },
)
```

### Custom navigation callback

```dart
SplashMasterVideo(
  source: AssetSource('assets/splash.mp4'),
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

### SplashMasterVideo

- `source`: `Source` (required)
- `videoConfig`: `VideoConfig?`
- `nextScreen`: `Widget?`
- `customNavigation`: `VoidCallback?`
- `onSourceLoaded`: `VoidCallback?`
- `backGroundColor`: `Color?`

Static methods:

- `SplashMasterVideo.initialize()`
- `SplashMasterVideo.resume()`

## Migration

Legacy API mappings:

- `SplashMaster.video(...)` -> `SplashMasterVideo(...)`
- `SplashMaster.initialize()` -> `SplashMasterVideo.initialize()`
- `SplashMaster.resume()` -> `SplashMasterVideo.resume()`
