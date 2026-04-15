# splash_master_video

Video splash screen widget for the [`splash_master`](../../README.md) ecosystem.

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  splash_master_video:
    path: ../packages/splash_master_video  # adjust path as needed
```

## Usage

```dart
import 'package:splash_master_video/splash_master_video.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  VideoSplash.initialize(); // defers first frame while loading
  runApp(
    const MaterialApp(
      home: VideoSplashScreen(),
    ),
  );
}

class VideoSplashScreen extends StatelessWidget {
  const VideoSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return VideoSplash(
      source: AssetSource('assets/splash.mp4'),
      videoConfig: const VideoConfig(
        videoVisibilityEnum: VisibilityEnum.useAspectRatio,
      ),
      backGroundColor: Colors.white,
      nextScreen: const MyApp(),
    );
  }
}
```

## API

### `VideoSplash`

| Parameter          | Type            | Description                                      |
|--------------------|-----------------|--------------------------------------------------|
| `source`           | `Source`        | Asset / file / network / bytes source            |
| `videoConfig`      | `VideoConfig?`  | Video player configuration (optional)            |
| `nextScreen`       | `Widget?`       | Screen to push after splash completes            |
| `customNavigation` | `VoidCallback?` | Custom nav — overrides `nextScreen`              |
| `onSourceLoaded`   | `VoidCallback?` | Called when video finishes loading               |
| `backGroundColor`  | `Color?`        | Splash background color                          |

### `VideoConfig`

| Property                        | Default                            | Description                                       |
|---------------------------------|------------------------------------|---------------------------------------------------|
| `playImmediately`               | `true`                             | Auto-play once initialized                        |
| `videoVisibilityEnum`           | `VisibilityEnum.useFullScreen`     | Fullscreen, aspect ratio, or none                 |
| `useSafeArea`                   | `false`                            | Wrap in SafeArea                                  |
| `onVideoControllerInitialised`  | `null`                             | Callback with initialized `VideoPlayerController` |

## Migration from `splash_master` 1.x

```dart
// Before (splash_master 1.x)
SplashMaster.video(
  source: AssetSource('assets/splash.mp4'),
  nextScreen: const MyApp(),
);

// After (splash_master_video 2.x)
VideoSplash(
  source: AssetSource('assets/splash.mp4'),
  nextScreen: const MyApp(),
);
```
