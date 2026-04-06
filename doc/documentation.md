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

Add a `splash_master` section to your `pubspec.yaml` file. The following example includes all currently supported configuration keys:

```yaml
splash_master:
  # ===== Light Mode — Common Configuration =====
  # Background color for the splash screen (light mode)
  color: '#FFFFFF'

  # Main splash image (used on both iOS and Android in light mode)
  image: 'assets/splash.png'

  # ===== iOS Light Mode Image Behavior =====
  # How the splash image should be displayed on iOS
  # iOS content mode options: scaleToFill, aspectFit, aspectFill, redraw, center,
  # top, bottom, left, right, topLeft, topRight, bottomLeft, bottomRight
  ios_content_mode: 'center'

  # ===== Android Light Mode Image Behavior =====
  # How the splash image should be positioned on Android
  # Android gravity options: center, clip_horizontal, clip_vertical, fill_horizontal,
  # fill, center_vertical, bottom, fill_vertical, center_horizontal, top, end, left,
  # right, start
  android_gravity: 'center'

  # ===== Background Image Configuration =====
  # Optional background image displayed behind the main splash image
  background_image: 'assets/background_image.png'

  # Optional background image displayed in Android dark mode (pre-Android 12)
  background_image_dark_android: 'assets/background_image_dark.png'

  # How the background image should be displayed on iOS
  ios_background_content_mode: 'scaleToFill'

  # How the background image should be positioned on Android
  # Options: same as android_gravity
  android_background_image_gravity: 'fill'

  # ===== Android Dark Mode Configuration (pre-Android 12) =====
  # Splash image to use when Android device is in dark mode
  image_dark_android: 'assets/splash_dark.png'

  # How the dark mode splash image should be positioned on Android
  android_dark_gravity: 'center'

  # Background color for Android dark mode
  color_dark_android: '#000000'

  # ===== Android 12+ Specific Configuration =====
  # Android 12 introduced a new splash screen system with specific requirements
  android_12_and_above:
    # Background color for Android 12+ splash screen
    color: '#FFFFFF'

    # Custom splash icon (replaces default app icon)
    # This should be a centered icon, ideally 288x288dp
    image: 'assets/splash_12.png'

    # Optional branding image shown at the bottom
    # Maximum height: 80dp, centered horizontally
    branding_image: 'assets/branding_image.png'

    # Optional branding image for Android 12+ dark mode
    branding_image_dark: 'assets/branding_image_dark.png'
```

**Note:** The above configuration demonstrates all available parameters. You only need to include the parameters relevant to your use case.

**Android dark mode details:**
- `background_image_dark_android`, `image_dark_android`, `android_dark_gravity`, and `color_dark_android` apply to pre-Android 12 drawable-based splash resources.
- `android_background_image_gravity` is used for both light and dark background images.
- Inside `android_12_and_above`, `branding_image_dark` lets you provide a separate branding asset for Android 12+ dark mode.
- For Android 12+ dark mode, if `color_dark_android` or `image_dark_android` is provided, it is used; otherwise Splash Master falls back to `android_12_and_above.color` and `android_12_and_above.image`.

**Validation details:**
- `branding_image`, `branding_image_dark`, and Android 12 `image`/`color` must be nested under `android_12_and_above`.
- Putting these keys at the top level under `splash_master` is invalid and will be rejected.
- Unknown keys at either level are rejected with a validation error.
- `android_12_and_above` must be a map/object. Non-map values are invalid.

**iOS Dark Mode:** Currently, splash_master does not support iOS-specific dark mode parameters (like `image_dark_ios`, `ios_dark_content_mode`, or `color_dark_ios`). iOS uses the same splash configuration for both light and dark appearance modes. Dark mode support is available only for Android.

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
