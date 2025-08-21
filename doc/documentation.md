# Overview

Splash Master is a Flutter plugin designed to make adding splash screens to your app quick, effortless, and highly customizable. It handles all the native-side setup for you, saving valuable development time and effort.

## Preview


| ![Android Preview](https://raw.githubusercontent.com/SimformSolutionsPvtLtd/splash_master/master/preview/android_preview.gif) | ![iOS Preview](https://raw.githubusercontent.com/SimformSolutionsPvtLtd/splash_master/master/preview/ios_preview.gif) |
|-------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------|
| Android                                                                                                                       | iOS                                                                                                                    |


## Features

- Native Integration: Automatically sets up native splash screens for Android and iOS.
- Multiple Media Support: Use videos, Lottie, Rive, images, or custom widgets.
- Easy Configuration: Define splash details in your pubspec.yaml.
- Smooth Transition: Ensures seamless transition from native splash to Flutter app.
- Highly Customizable: Control duration, background color, and more.

## Key Components

- SplashMediaType.lottie: Renders a Lottie animation as the splash screen.
- SplashMediaType.video: Plays a video splash screen.
- SplashMediaType.rive: Displays a Rive animation splash screen.
- Custom Widget: Allows integration of a custom Flutter widget as the splash screen for full flexibility.

# Installation

## 1. Add dependency to `pubspec.yaml`
Add `splash_master` as a dependency in your pubspec.yaml
from [pub.dev](https://pub.dev/packages/splash_master/install).

```yaml
dependencies:
  splash_master:<latest-version>
```

## 2. Install packages

Run the following command to install the package:

```bash
flutter pub get
```

## 3. Import the package

Add the following import to your Dart code:

```dart
import 'package:splash_master/splash_master.dart';
```

Now you're ready to use the splash_master package in your Flutter application!

# Basic Usage

This section guides you through the essential steps to implement Splash Master in your Flutter app.

## 1. Configure Splash Master in `pubspec.yaml`

Add a `splash_master` section to your `pubspec.yaml` file.

```yaml
    splash_master:
      # Use to specifies the color for the splash screen
      color: '#FFFFFF'
      # Use to specifies the splash image
      image: 'assets/splash.png'
      # Provides content mode for splash image in iOS
      # iOS content mode options: scaleToFill, scaleAspectFit, scaleAspectFill, redraw, center, top, bottom,
      # left, right, topLeft, topRight, bottomLeft, bottomRight.
      ios_content_mode: 'center'
      # Provides gravity for splash image in Android
      # Android gravity options: center, clip_horizontal, clip_vertical, fill_horizontal, fill, center_vertical, 
      # bottom, fill_vertical, center_horizontal, top, end, left, right, start
      android_gravity: 'center'
      # Use to specifies the splash image
      background_image: 'assets/background_image.png'
      # Provided content mode for splash image in background for iOS
      ios_background_content_mode: 'scaleToFill'
      # Provides gravity for background image in Android
      # Android gravity options: center, clip_horizontal, clip_vertical, fill_horizontal, fill, center_vertical, 
      # bottom, fill_vertical, center_horizontal, top, end, left, right, start
      android_background_image_gravity: 'fill'
      # Use to specifies image for android in dark mode
      image_dark_android: 'assets/splash_dark.png'
      # Provides gravity for splash image for Android in dark mode
      android_dark_gravity_key: 'center'
      # Use to specifies the color for the splash screen for Android in dark mode
      color_dark_android: '#000000'
      # Section to specifies the configuration for the splash in Android 12+
      android_12_and_above:
        # Provides the background color of splash screen
        color: '#FFFFFF'
        # Provides custom icon to replace the default app icon
        image: 'assets/splash_12.png'
        # Provides branding image which is shown under main icon image. 
        branding_image: 'assets/branding_image.png'
```

## 2. Generate Native Splash Screen

Run the following command to set up the native splash screen:

```bash
dart run splash_master create
```

Alternatively, activate Splash Master globally:

```bash
dart pub global activate splash_master
splash_master create
```

## 3. Integrate Splash Master in Flutter

Splash Master supports video, Lottie, Rive, and image splash screens. Video, Lottie, and Rive are handled on the Flutter side; images are managed natively.

**Video Splash Example:**
```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SplashMaster.initialize();
  runApp(
    MaterialApp(
      home: SplashMaster.video(/* config */),
    ),
  );
}
```

**Lottie Splash Example:**
```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SplashMaster.initialize();
  runApp(
    MaterialApp(
      home: SplashMaster.lottie(/* config */),
    ),
  );
}
```

**Rive Splash Example:**
```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SplashMaster.initialize();
  runApp(
    MaterialApp(
      home: SplashMaster.rive(/* config */),
    ),
  );
}
```


# Advanced Usage

Take advantage of advanced features and customizations for more control over your splash experience.

## 1. Image Splash: Manual Resume

When using an image splash, you **must** call `SplashMaster.resume()` to transition from the native splash to your Flutter app:

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SplashMaster.initialize();
  // Perform any setup/config before resuming
  SplashMaster.resume();
  runApp(
    MaterialApp(
      home: YourWidget(), // Your first screen
    ),
  );
}
```

## 2. Custom Splash Widget

You can use your own custom widget for the splash screen:

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SplashMaster.initialize();
  runApp(
    MaterialApp(
      home: YourCustomWidget(),
    ),
  );
}
```

## 3. Initialization & Resume Methods

- `SplashMaster.initialize()` prevents Flutter frames from rendering until initialization is complete.
- To resume Flutter frames, call `SplashMaster.resume()`. Until then, the app remains on the native splash screen.

**Usage Notes:**
- For `SplashMaster.video()`, `SplashMaster.lottie()`, and `SplashMaster.rive()`, you **do not** need to call `resume()` manually; it resumes automatically when the media is loaded.
- If you provide a custom `onSourceLoaded` callback in your config, you are responsible for calling `resume()`.

Once the setup command completes, your splash screen is ready on the native side.

## Properties:

The common properties used in `SplashMaster.video()`, `SplashMaster.lottie()`
and `SplashMaster.rive()` are largely the same. The key difference between them is the use
of `videoConfig`, `lottieConfig` and `riveConfig`, which allow for configuration customization specific to video, Lottie animations
and Rive animations, respectively.

Rive animations have an additional property called `splashDuration` that allows you to set a specific duration for the splash screen.

| Name                           | Description                                                                                                   |
|--------------------------------|---------------------------------------------------------------------------------------------------------------|
| source                         | Media source for assets.                                                                                      |
| videoConfig                    | To handle the video's configuration.                                                                          |
| lottieConfig                   | To handle the lottie's configuration.                                                                         |
| riveConfig                     | Configuration for the Rive animation (appearance, behavior, animations to play).                              |
| backGroundColor                | To handle the background color of the splash screen.                                                          |
| nextScreen                     | Screen to navigate once splash finished.                                                                      |
| customNavigation               | Callback to handle the logic when the splash is completed.                                                    |
| onSourceLoaded                 | Called when provided media is loaded.                                                                         |
| splashDuration (rive only) | Optional explicit duration for the splash screen (overrides automatic calculation based on animation length). |


# Contributors

The following individuals have played a key role in developing and maintaining the Splash Master package.

## Main Contributors

| ![img](https://avatars.githubusercontent.com/u/56400956?v=4&s=200) | ![img](https://avatars.githubusercontent.com/u/65003381?v=4&s=200) | ![img](https://avatars.githubusercontent.com/u/44993081?v=4&s=200) | 
|:------------------------------------------------------------------:|:------------------------------------------------------------------:|:------------------------------------------------------------------:|
| [Ujas Majithiya](https://github.com/Ujas-Majithiya)                | [Apurva Kanthraviya](https://github.com/apurva780)                 | [Dhaval Kansara](https://github.com/DhavalRKansara)                |

## Contribute
We welcome contributions to Splash Master! To get started:

1. Fork the repository to your GitHub account.
2. Create a new branch for your changes (`git checkout -b feature/your-feature-name`).
3. Make your improvements or bug fixes.
4. Commit your changes with a clear message (`git commit -m 'Describe your change'`).
5. Push your branch to your fork (`git push origin feature/your-feature-name`).
6. Submit a Pull Request for review.

## Contribution Tips

- Stick to the project's coding standards and guidelines.
- Write meaningful commit messages.
- Include tests for any new features or fixes.
- Update documentation if your changes affect usage.
- Ensure all tests pass before submitting your pull request.
- Double-check that your changes do not break existing functionality.

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
