# Overview

`splash_master_video` provides `SplashMasterVideo`, a Flutter widget that plays a video as your splash screen and automatically navigates to your app once playback finishes.

## Preview

| Android                                                                                                                                                                           | iOS                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| ![Splash Master Android Video Splash Preview](https://raw.githubusercontent.com/SimformSolutionsPvtLtd/splash_master/master/splash_master_video/preview/android_video_splash.gif) | ![Splash Master iOS Video Splash Preview](https://raw.githubusercontent.com/SimformSolutionsPvtLtd/splash_master/master/splash_master_video/preview/ios_video_splash.gif) |

## Features

- Plays a video (asset, file, network, or bytes) as an animated splash screen.
- Auto-navigates to the next screen when playback finishes.
- Configurable fullscreen or aspect-ratio display via `VisibilityEnum`.
- Manual playback control via `VideoPlayerController` callback.
- Custom navigation callback for advanced routing.
- `initialize()` / `resume()` static methods to coordinate with the native splash.

# Installation

## 1. Add dependency to `pubspec.yaml`

```yaml
dependencies:
  splash_master_video: ^1.0.0
```

> `splash_master_video` re-exports `splash_master`, so you do not need to add `splash_master` separately.

## 2. Configure native splash in `pubspec.yaml`

Add a `splash_master` section to set up the native (before-Flutter) splash screen:

```yaml
splash_master:
  color: '#FFFFFF'
  image: 'assets/splash.png'
```

Then generate native assets:

```bash
dart run splash_master create
```

For the full configuration key reference, see [splash_master documentation](https://simform-flutter-packages.web.app/splashMaster).

## 3. Declare the video asset

```yaml
flutter:
  assets:
    - assets/splash.mp4
```

## 4. Install packages

```bash
flutter pub get
```

## 5. Import the package

```dart
import 'package:splash_master_video/splash_master_video.dart';
```

# Basic Usage

## Step 1: Call `initialize()` before `runApp()`

`SplashMasterVideo.initialize()` holds the native splash screen visible while Flutter initialises. The native splash is released automatically once the video finishes playing.

## Step 2: Use `SplashMasterVideo` as your root widget

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
      nextScreen: const MyApp(),
    );
  }
}
```

# Advanced Usage

## Manual Playback Control

Set `playImmediately: false` and use the `onVideoControllerInitialised` callback to control playback yourself:

```dart
SplashMasterVideo(
  source: AssetSource('assets/splash.mp4'),
  videoConfig: VideoConfig(
    playImmediately: false,
    onVideoControllerInitialised: (controller) {
      // Perform setup, then start playback
      controller.play();
    },
  ),
  nextScreen: const MyApp(),
)
```

## Custom Navigation

Use `customNavigation` to control navigation yourself instead of providing `nextScreen`:

```dart
SplashMasterVideo(
  source: AssetSource('assets/splash.mp4'),
  customNavigation: () {
    Navigator.of(context).pushReplacementNamed('/home');
  },
)
```

## Display Modes

Control how the video fills the screen using `videoVisibilityEnum`:

```dart
// Fullscreen with letterboxing (default)
VideoConfig(videoVisibilityEnum: VisibilityEnum.useFullScreen)

// Preserve video aspect ratio
VideoConfig(videoVisibilityEnum: VisibilityEnum.useAspectRatio)
```

## Safe Area

Wrap the video in a `SafeArea` to avoid system UI overlap:

```dart
SplashMasterVideo(
  source: AssetSource('assets/splash.mp4'),
  videoConfig: const VideoConfig(useSafeArea: true),
  nextScreen: const MyApp(),
)
```

## Network Video

```dart
SplashMasterVideo(
  source: NetworkSource('https://example.com/splash.mp4'),
  nextScreen: const MyApp(),
)
```

## Manual Resume

If you provide an `onSourceLoaded` callback, you are responsible for calling `SplashMasterVideo.resume()`:

```dart
SplashMasterVideo(
  source: AssetSource('assets/splash.mp4'),
  onSourceLoaded: () {
    // Perform additional work, then release native splash
    SplashMasterVideo.resume();
  },
  nextScreen: const MyApp(),
)
```

# Widget Reference

## SplashMasterVideo

| Property | Type | Required | Description |
|---|---|---|---|
| `source` | `Source` | ✅ | The video source |
| `videoConfig` | `VideoConfig?` | ❌ | Playback and display configuration |
| `nextScreen` | `Widget?` | ❌ | Screen to navigate to after video ends |
| `customNavigation` | `VoidCallback?` | ❌ | Custom navigation logic (replaces `nextScreen`) |
| `onSourceLoaded` | `VoidCallback?` | ❌ | Called when the video is loaded; you must call `resume()` manually if provided |
| `backGroundColor` | `Color?` | ❌ | Background color behind the video |

**Static methods:**

| Method | Description |
|---|---|
| `SplashMasterVideo.initialize()` | Holds the native splash until `resume()` is called |
| `SplashMasterVideo.resume()` | Releases the native splash and allows Flutter to render |

## VideoConfig Parameters

| Property | Type | Default | Description |
|---|---|---|---|
| `playImmediately` | `bool` | `true` | Auto-play once the controller is initialised |
| `videoVisibilityEnum` | `VisibilityEnum` | `useFullScreen` | How to display the video (`useFullScreen`, `useAspectRatio`, `none`) |
| `useSafeArea` | `bool` | `false` | Wrap the video in a `SafeArea` |
| `onVideoControllerInitialised` | `Function(VideoPlayerController)?` | `null` | Callback to access the `VideoPlayerController` |

## VisibilityEnum Values

| Value | Description |
|---|---|
| `VisibilityEnum.useFullScreen` | Fills the screen while maintaining aspect ratio with letterboxing (default) |
| `VisibilityEnum.useAspectRatio` | Displays the video at its natural aspect ratio within available space |
| `VisibilityEnum.none` | No special layout handling |

## Source Types

| Type | Usage |
|---|---|
| `AssetSource(path)` | Flutter bundled asset |
| `DeviceFileSource(path)` | Local device file path |
| `NetworkSource(url)` | Remote video URL |
| `BytesSource(bytes)` | In-memory `Uint8List` |

# Migration Guide

## From `splash_master` 0.0.3

| Before (0.0.3) | After (1.0.0) |
|---|---|
| `SplashMaster.video(...)` | `SplashMasterVideo(...)` |
| `SplashMaster.initialize()` | `SplashMasterVideo.initialize()` |
| `SplashMaster.resume()` | `SplashMasterVideo.resume()` |

Apps that used only the native image/color splash with no animation widget are **not affected**.

# Contributors

The following individuals have played a key role in developing and maintaining the Splash Master package.

## Main Contributors

| ![img](https://avatars.githubusercontent.com/u/56400956?v=4&s=200) | ![img](https://avatars.githubusercontent.com/u/65003381?v=4&s=200) | ![img](https://avatars.githubusercontent.com/u/44993081?v=4&s=200) |
|:------------------------------------------------------------------:|:------------------------------------------------------------------:|:------------------------------------------------------------------:|
| [Ujas Majithiya](https://github.com/Ujas-Majithiya)                | [Apurva Kanthraviya](https://github.com/apurva780)                 | [Dhaval Kansara](https://github.com/DhavalRKansara)                |

## Contribute

We welcome contributions! To get started:

1. Fork the repository to your GitHub account.
2. Create a new branch (`git checkout -b feature/your-feature-name`).
3. Make your changes and commit them (`git commit -m 'Describe your change'`).
4. Push your branch (`git push origin feature/your-feature-name`).
5. Submit a Pull Request for review.

For more details, visit the [Splash Master GitHub repository](https://github.com/SimformSolutionsPvtLtd/splash_master).

# License

```
MIT License

Copyright (c) 2024 Simform Solutions

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
