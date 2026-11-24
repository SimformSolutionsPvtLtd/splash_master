---
name: splash-master-video-splash
description: >-
  Play a video as the app's splash screen with SplashMasterVideo and
  VideoConfig (built on video_player), handing off from the native splash and
  navigating to the next screen when the video ends. Use when adding,
  configuring or debugging a video splash, or when code uses SplashMasterVideo
  or VideoConfig.
---

# splash_master_video: video splash screen

`SplashMasterVideo` plays a video with `video_player`, then navigates to the
next screen when the video's duration has elapsed. It runs after the native
splash, which `splash_master` generates.

## Workflow

1. **Inspect the project.** Find the video file, the app entry point
   (`main()`), and how the app navigates (`MaterialApp` routes, go_router,
   auto_route…). Check for an existing `splash_master:` block in
   `pubspec.yaml`.
2. **Add the dependency:** `flutter pub add splash_master_video`.
   It already includes `splash_master`, which provides the
   `dart run splash_master create` CLI; no need to add it separately.
3. **Declare the asset** under `flutter: assets:` in `pubspec.yaml`.
4. **Wire `main()` and the widget** as in the examples below.
5. **Set up the native splash** (ideally the video's first frame, or the same
   background color, so the hand-off is seamless): follow
   `references/native-splash.md` (all keys: `references/config-keys.md`).
6. Run `flutter analyze`, then test with a cold start on a real device.
   Simulators and emulators often decode video poorly.

## Rules

- Import only `package:splash_master_video/splash_master_video.dart`. It
  re-exports `splash_master` (`AssetSource`, `VisibilityEnum`, …).
- Call `SplashMasterVideo.initialize()` in `main()` after
  `WidgetsFlutterBinding.ensureInitialized()` and before `runApp`. It holds
  the native splash on screen until the video is ready, so there is no blank
  frame in between.
- The widget calls `SplashMasterVideo.resume()` once the video initializes
  (or fails). Passing `onSourceLoaded` **replaces** that call: your callback
  must call `SplashMasterVideo.resume()`, or the app stays frozen on the native
  splash.
- `initialize()` without a `SplashMasterVideo` in the first route has the same
  effect: nothing ever calls `resume()`.
- Navigation happens after the **video's duration**, counted from
  initialization, even when `playImmediately: false`. Trim the video to the
  wanted splash length.
- Navigate with `nextScreen` (uses `Navigator.pushReplacement`, so the widget
  needs a `Navigator` above it, e.g. `MaterialApp.home`) or with
  `customNavigation`, which takes precedence. With neither, the splash stays.
- **If the video fails to initialize, the widget never navigates** and the app
  shows an empty screen. Use a bundled `AssetSource` for the splash. Only use
  `NetworkFileSource` / `DeviceFileSource` when the app can tolerate that.
- Do not use `BytesSource` with this widget: its bytes are read as a file
  path, so the video fails to initialize and the splash never navigates.
- Use a format both platforms decode: H.264 video in an `.mp4` container.
  Keep it short and small, since it is bundled in the app.
- Match `backGroundColor` to the native splash `color`. Without it the
  background is transparent.

## Examples

Basic:

```dart
import 'package:flutter/material.dart';
import 'package:splash_master_video/splash_master_video.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SplashMasterVideo.initialize();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashMasterVideo(
        source: AssetSource('assets/splash.mp4'),
        backGroundColor: Colors.black,
        videoConfig: const VideoConfig(
          videoVisibilityEnum: VisibilityEnum.useAspectRatio,
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

Access the `VideoPlayerController` (e.g. to mute):

```dart
Widget buildSplash() => SplashMasterVideo(
      source: AssetSource('assets/splash.mp4'),
      videoConfig: VideoConfig(
        onVideoControllerInitialised: (controller) => controller.setVolume(0),
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
    builder: (context, state) => SplashMasterVideo(
      source: AssetSource('assets/splash.mp4'),
      customNavigation: () => router.go('/home'),
    ),
  ),
  GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
]);
```

## VideoConfig

| Field | Default | Notes |
|---|---|---|
| `playImmediately` | `true` | `false` leaves the video paused (start it via the controller); navigation still fires after the duration |
| `videoVisibilityEnum` | `VisibilityEnum.useFullScreen` | `useFullScreen` stretches to the screen size; `useAspectRatio` keeps the video ratio; `none` also fills the available space (the video texture takes all of it), so it stretches like `useFullScreen` |
| `useSafeArea` | `false` | |
| `onVideoControllerInitialised` | `null` | Receives the `VideoPlayerController` after initialization |

## Platform notes

- `NetworkFileSource` on Android release builds needs
  `<uses-permission android:name="android.permission.INTERNET"/>` in
  `android/app/src/main/AndroidManifest.xml`. On iOS, plain `http://` URLs
  are blocked by App Transport Security; use `https://`.

## Troubleshooting

- App frozen on the native splash → `onSourceLoaded` without `resume()`, or
  `initialize()` called but the splash widget is not the first route.
- Empty screen that never navigates → the video failed to initialize. Check
  the asset path and declaration, the codec, and the error in the logs
  (reported under library `splash_master_video`).
- Video stretched → use `VisibilityEnum.useAspectRatio`.
