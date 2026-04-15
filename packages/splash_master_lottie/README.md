# splash_master_lottie

Lottie animation splash screen widget for the [`splash_master`](../../README.md) ecosystem.

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  splash_master_lottie:
    path: ../packages/splash_master_lottie  # adjust path as needed
```

## Usage

```dart
import 'package:splash_master_lottie/splash_master_lottie.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LottieSplash.initialize(); // defers first frame while loading
  runApp(
    const MaterialApp(
      home: LottieSplashScreen(),
    ),
  );
}

class LottieSplashScreen extends StatelessWidget {
  const LottieSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LottieSplash(
      source: AssetSource('assets/animation.json'),
      lottieConfig: const LottieConfig(repeat: false),
      backGroundColor: Colors.white,
      nextScreen: const MyApp(),
    );
  }
}
```

## API

### `LottieSplash`

| Parameter          | Type            | Description                                      |
|--------------------|-----------------|--------------------------------------------------|
| `source`           | `Source`        | Asset / file / network / bytes source            |
| `lottieConfig`     | `LottieConfig`  | Lottie animation configuration (optional)        |
| `nextScreen`       | `Widget?`       | Screen to push after splash completes            |
| `customNavigation` | `VoidCallback?` | Custom nav — overrides `nextScreen`              |
| `onSourceLoaded`   | `VoidCallback?` | Called when composition finishes loading         |
| `backGroundColor`  | `Color?`        | Splash background color                          |

### `LottieConfig`

Key properties:

| Property           | Default                            | Description                                   |
|--------------------|------------------------------------|-----------------------------------------------|
| `repeat`           | `false`                            | Loop the animation                            |
| `animate`          | `null` (auto)                      | Play automatically                            |
| `visibilityEnum`   | `VisibilityEnum.useFullScreen`     | Fullscreen, aspect ratio, or none             |
| `aspectRatio`      | `9/16`                             | Used when `visibilityEnum` is `useAspectRatio`|
| `overrideBoxFit`   | `true`                             | Apply `BoxFit.fill` to remove padding         |

## Migration from `splash_master` 1.x

```dart
// Before (splash_master 1.x)
SplashMaster.lottie(
  source: AssetSource('assets/animation.json'),
  nextScreen: const MyApp(),
);

// After (splash_master_lottie 2.x)
LottieSplash(
  source: AssetSource('assets/animation.json'),
  nextScreen: const MyApp(),
);
```
