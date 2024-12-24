![Banner](https://raw.githubusercontent.com/SimformSolutionsPvtLtd/splash_master/master/preview/banner.png)

# Splash Master

A Flutter plugin that streamlines the process of adding splash screens to your app.
This plugin takes care of all the necessary native-side setup which saves your time and efforts.
It supports videos, Lottie animations, images and custom Flutter widgets, giving users various creative options.
Simply define the required details by adding a `splash_master` section to your `pubspec.yaml`.
Additionally, the plugin ensures a smooth and seamless transition from native to flutter app, 
enhancing the user experience.

### Preview

| Android                                                                                                                                                                                                                                                | iOS                                                                                                                                                                                                                                                     |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| <a href="https://raw.githubusercontent.com/SimformSolutionsPvtLtd/splash_master/master/preview/android_preview.gif"><img src="https://raw.githubusercontent.com/SimformSolutionsPvtLtd/splash_master/master/preview/android_preview.gif"  height="600px;"/></a> | <a href="https://raw.githubusercontent.com/SimformSolutionsPvtLtd/splash_master/master/preview/ios_preview.gif"><img src="https://raw.githubusercontent.com/SimformSolutionsPvtLtd/splash_master/master/preview/ios_preview.gif" height="600px;"/></a> |



### Installation

Add `splash_master` as a dependency in your pubspec.yaml
from [pub.dev](https://pub.dev/packages/splash_master/install).

```yaml
dependencies:
  splash_master: <Latest Version>
```

### Usage

1. Setup the splash screen

- Add `splash_master` section in `pubspec.yaml`.

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
      # Provides gravity for background image in Android
      # Android gravity options: center, clip_horizontal, clip_vertical, fill_horizontal, fill, center_vertical, 
      # bottom, fill_vertical, center_horizontal, top, end, left, right, start
      android_background_image_gravity: 'fill'
      # Section to specifies the configuration for the splash in Android 12+
      android_12_and_above:
        # Provides the background color of splash screen
        color: '#FFFFFF'
        # Provides custom icon to replace the default app icon
        image: 'assets/splash_12.png'
    ```

2. Create & setup splash screen  

- Run the following command to create & setup the splash screen on native side.

  ```shell
  dart run splash_master create
  ```

3. Setup on the flutter side

- We offer support for splash components, including video, Lottie animations, and images. Videos
and Lottie animations are processed on the Flutter side, while image handling is managed natively. 


- Video
  ```dart
    void main() {
     WidgetsFlutterBinding.ensureInitialized();
     SplashMaster.initialize();
     runApp(
        MaterialApp(
           home: SplashMaster.video(...),  // use for video
        ),
      );
    }
  ```

- Lottie
  ```dart
    void main() {
     WidgetsFlutterBinding.ensureInitialized();
     SplashMaster.initialize();
     runApp(
        MaterialApp(
           home: SplashMaster.lottie(...),  // use for lottie
        ),
      );
    }
  ```

- Image: While using image as splash screen you have to call the `SplashMaster.resume()` method explicitly
  to resume the Flutter app.
  ```dart
    void main() {
     WidgetsFlutterBinding.ensureInitialized();
     SplashMaster.initialize();
     // Setup your config before the resume.
     SplashMaster.resume();
     runApp(
        MaterialApp(
           home: YourWidget(),  // Your first screen
        ),
     );
  }
  ```

 - If you prefer to use your own custom widget instead of the provided options, you can easily integrate it as a splash widget.

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

- The `SplashMaster.initialize()` method prevents flutter frames from rendering until initialization is complete. To resume Flutter frames, call the `SplashMaster.resume()` method. Until `resume()` is called, the app will remain in the native splash screen.
  - `initialize()`
    - Use this method to initialize resources or execute code during app startup. Once the initialization is complete, call resume() to allow Flutter to start rendering frames.
  - `resume()`
    - If you use the SplashMaster.video() or SplashMaster.lottie() methods, you don’t need to call resume() explicitly. The rendering will resume automatically once the provided video or Lottie source is fully initialized.
    - This function will be called automatically from `onSourceLoaded`, if you haven't provided this
      parameter from `VideoConfig` or `LottieConfig`. If you set this parameter or don't use SplashMaster
      widget, then you will be responsible for calling this function.

- Once command runs successfully splash screen has been setup on native side.



### Properties of `SplashMaster.video()` and `SplashMaster.lottie()`:

The common properties used in `SplashMaster.video()` and `SplashMaster.lottie()` are largely the same. The key difference between the two is the use of `videoConfig` and `lottieConfig`, which allow for configuration customization specific to video and Lottie animations, respectively.


| Name             | Description                                                |
|------------------|------------------------------------------------------------|
| source           | Media source for assets.                                   |
| videoConfig      | To handle the video's configuration.                       |
| lottieConfig     | To handle the lottie's configuration.                      |
| backGroundColor  | To handle the background color of the splash screen.       |
| nextScreen       | Screen to navigate once splash finished.                   |
| customNavigation | Callback to handle the logic when the splash is completed. |
| onSourceLoaded   | Called when provided media is loaded.                      |

### Main Contributors

<table>
  <tr>
    <td align="center"><a href="https://github.com/Ujas-Majithiya"><img src="https://avatars.githubusercontent.com/u/56400956?v=4" width="100px;" alt=""/><br /><sub><b>Ujas Majithiya</b></sub></a></td>
    <td align="center"><a href="https://github.com/apurva780"><img src="https://avatars.githubusercontent.com/u/65003381?v=4" width="100px;" alt=""/><br /><sub><b>Apurva Kanthraviya</b></sub></a></td>
<td align="center"><a href="https://github.com/DhavalRKansara"><img src="https://avatars.githubusercontent.com/u/44993081?v=4" width="100px;" alt=""/><br /><sub><b>Dhaval Kansara</b></sub></a></td>
  </tr>
</table>