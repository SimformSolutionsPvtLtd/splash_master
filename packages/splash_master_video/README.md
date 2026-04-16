![Banner](../../preview/banner.png)

# splash_master_video

[![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/SimformSolutionsPvtLtd/splash_master/blob/master/LICENSE)

Video splash screen widget for the [Splash Master](../../README.md) ecosystem. Display a video file as your Flutter app's animated splash screen, with automatic transition to your main app once playback finishes.

> **Part of the splash_master family** — the core CLI/native-image package is [`splash_master`](../../README.md). For other animation types, see [`splash_master_rive`](../splash_master_rive/README.md) (Rive) and [`splash_master_lottie`](../splash_master_lottie/README.md) (Lottie).

## Preview

| Android                                                                                                                                                                                                                 | iOS                                                                                                                                                                                                                                                                                                                        |
|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| <a href="https://raw.githubusercontent.com/SimformSolutionsPvtLtd/splash_master/master/packages/splash_master_video/preview/android_video_splash.gif"><img src="https://raw.githubusercontent.com/SimformSolutionsPvtLtd/splash_master/master/packages/splash_master_video/preview/android_video_splash.gif" height="600px;"/></a> | <a href="https://raw.githubusercontent.com/SimformSolutionsPvtLtd/splash_master/master/packages/splash_master_video/preview/ios_video_splash.gif"><img src="https://raw.githubusercontent.com/SimformSolutionsPvtLtd/splash_master/master/packages/splash_master_video/preview/ios_video_splash.gif" height="600px;"/></a> |

---

## Features

- Play **asset, device file, network, or in-memory byte** videos as a splash screen.
- Automatically defers Flutter's first frame until the video is ready, keeping the native splash visible during loading.
- Configurable **background color** behind the video.
- **Fullscreen** or **aspect-ratio-preserving** display modes.
- Exposes `VideoPlayerController` for manual playback control.
- Navigate to the next screen automatically or via a **custom navigation callback**.

---

## Installation

`splash_master_video` already depends on `splash_master`, so you only need one entry:

```yaml
dependencies:
  splash_master_video: ^1.0.0
```

### Native splash setup (optional, CLI)

When you also want a native pre-Flutter splash, add a small `splash_master:` block in your app `pubspec.yaml`:

```yaml
splash_master:
  color: '#FFFFFF'
  image: 'assets/splash.png'
```

Then run:

```bash
dart run splash_master create
```

> `splash_master_video` already includes `splash_master`, so you don't need to add `splash_master` separately for package usage.

---

## Quick start

### 1. Declare the asset

```yaml
# pubspec.yaml
flutter:
  assets:
    - assets/splash.mp4
```

### 2. Initialize and display

```dart
import 'package:flutter/material.dart';
import 'package:splash_master_video/splash_master_video.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  VideoSplash.initialize(); // keeps native splash visible while video loads
  runApp(const MaterialApp(home: MySplash()));
}

class MySplash extends StatelessWidget {
  const MySplash({super.key});

  @override
  Widget build(BuildContext context) {
    return VideoSplash(
      source: AssetSource('assets/splash.mp4'),
      videoConfig: const VideoConfig(
        videoVisibilityEnum: VisibilityEnum.useAspectRatio,
      ),
      backGroundColor: Colors.black,
      nextScreen: const MyHomePage(),
    );
  }
}
```

---

## API Reference

### `VideoSplash`

| Parameter          | Type                  | Default          | Description |
|--------------------|-----------------------|------------------|-------------|
| `source`           | `Source`              | —                | Video source. **Required.** See [Source types](#source-types) below. |
| `videoConfig`      | `VideoConfig?`        | `VideoConfig()`  | Playback and display configuration. |
| `nextScreen`       | `Widget?`             | `null`           | Widget to navigate to after the video ends. |
| `customNavigation` | `VoidCallback?`       | `null`           | Custom navigation callback — overrides `nextScreen` when set. |
| `onSourceLoaded`   | `VoidCallback?`       | `null`           | Called when the video finishes loading. Also resumes Flutter frames unless you override this. |
| `backGroundColor`  | `Color?`              | `null`           | Background color visible behind the video. |

#### Static methods

| Method                       | Description |
|------------------------------|-------------|
| `VideoSplash.initialize()`   | Defers Flutter's first frame. Call in `main()` before `runApp`. |
| `VideoSplash.resume()`       | Resumes frame rendering. Called automatically when the video loads unless `onSourceLoaded` is overridden. |

---

### `VideoConfig`

| Property                       | Type                               | Default                          | Description |
|--------------------------------|------------------------------------|----------------------------------|-------------|
| `playImmediately`              | `bool`                             | `true`                           | Auto-play once initialized. Set `false` to control playback manually via `onVideoControllerInitialised`. |
| `videoVisibilityEnum`          | `VisibilityEnum`                   | `VisibilityEnum.useFullScreen`   | `useFullScreen` stretches to fill; `useAspectRatio` preserves the video's native ratio. |
| `useSafeArea`                  | `bool`                             | `false`                          | Wraps the video widget in a `SafeArea`. |
| `onVideoControllerInitialised` | `Function(VideoPlayerController)?` | `null`                           | Callback with the initialized `VideoPlayerController` for manual control. |

**Example — manual playback:**

```dart
VideoConfig(
  playImmediately: false,
  onVideoControllerInitialised: (controller) {
    controller.play();
  },
)
```

---

### Source types

Source types are provided by [`splash_master`](../../README.md) and re-exported by this package.

| Type                        | Usage |
|-----------------------------|-------|
| `AssetSource(path)`         | Flutter bundled asset (most common). |
| `DeviceFileSource(path)`    | Local file path on the device. |
| `NetworkFileSource(url)`    | Remote video URL. |
| `BytesSource(bytes)`        | In-memory `Uint8List`. |

---

## Navigation

**Simple push** — provide `nextScreen`:

```dart
VideoSplash(
  source: AssetSource('assets/splash.mp4'),
  nextScreen: const HomeScreen(),
)
```

**Custom navigation** — use `customNavigation` for named routes, deep links, etc.:

```dart
VideoSplash(
  source: AssetSource('assets/splash.mp4'),
  customNavigation: () {
    Navigator.of(context).pushReplacementNamed('/home');
  },
)
```

---

## Migration from `splash_master` 0.0.3 to 1.0.0

```dart
// Before (splash_master 0.0.3)
SplashMaster.initialize();
SplashMaster.video(
  source: AssetSource('assets/splash.mp4'),
  nextScreen: const MyApp(),
);

// After (splash_master_video 1.0.0)
VideoSplash.initialize();
VideoSplash(
  source: AssetSource('assets/splash.mp4'),
  nextScreen: const MyApp(),
);
```

---

## Related packages

| Package | What it does |
|---------|--------------|
| [`splash_master`](../../README.md) | Core package — CLI-based native splash generation for Android & iOS, shared types (`Source`, `VisibilityEnum`). |
| [`splash_master_rive`](../splash_master_rive/README.md) | Rive animation splash screen widget (`RiveSplash`). |
| [`splash_master_lottie`](../splash_master_lottie/README.md) | Lottie animation splash screen widget (`LottieSplash`). |

---

## License

This project is licensed under the MIT License — see the [LICENSE](https://github.com/SimformSolutionsPvtLtd/splash_master/blob/master/LICENSE) file for details.
