![Banner](https://raw.githubusercontent.com/SimformSolutionsPvtLtd/flutter_chatview/main/preview/banner.png)

# Splash Master

A Flutter package that simplifies adding splash screens to your app, supporting various options 
like video, image, and Lottie animations. It also addresses the challenge of creating a seamless 
transition between the native launch screen and the Flutter splash screen.

### Installation

Just add `splash_master` as a dependency in your pubspec.yaml file
from [pub.dev](https://pub.dev/packages/splash_master/install).

```yaml
dependencies:
  splash_master: <Latest Version>
```

## Prerequisites

Splash Master supports the following splash screen types:

1. Video
2. Lottie
3. Image

Each splash screen type requires specific tools. Follow the instructions below to install the necessary tools based on your system and the type of splash screen you wish to use.

**Note**-: If you're using Windows system then you will have install these tools manually. For Macos
& Linux, this command will suffice. Since these tools are
installed into you system, your apps bundle size will not increase.

### Video as a Splash Screen

1. Install FFmpeg
   - To set up a video splash screen, first run this command to install FFmpeg. FFmpeg will be used to extract the first frame from the video:
      ```bash
      dart run splash_master install video
      ```
2. Add video to assets
   - Place your video file (e.g., your_video.mp4) in the assets folder of your project.
3. Generate the First frame of splash screen
   - Run the following command to generate the first frame from your video:
   ```bash
   dart run splash_master video assets/your_video.mp4
   ```
   - This command will generate the first frame of the video in different resolutions for both Android and iOS. It will also place the generated images in the appropriate native folders.
   - For Android, it will create a new splash_image.xml to style the splash screen and will update style.xml to
     use it.
   - For Ios, it will update Contents.json file.
4. Setup iOS splash
   - Run the following command; It will replace the default launch screen with the generated one.
   ```bash
   dart run splash_master setup native_splash
   ```
5. Use `SplashMaster.Video` widget
   ```dart
   SplashMaster.video(
    nextScreen: const Home(),// The screen which will be shown after splash.
    source: AssetSource(Assets.sampleSplashScreen), // Source of the video.
    imageConfig: const ImageConfig(),
    videoConfig: const VideoConfig(
      videoVisibilityEnum: VideoVisibilityEnum.useFullScreen, // Change it with useAspectRatio
    ),
    customNavigation: () {}, 
   );
   ```
   - Use this widget as first widget of your app in the `runApp`.
   - Customization Options:
     - videoConfig: Customize your video splash. 
     - customNavigation: If provided, this will be called when the video ends, allowing you to define your custom navigation logic. This overrides the default navigation, which happens when the video completes.
   - By default, the widget automatically navigates to the nextScreen after the video ends like this.
   ```dart
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) {
            return widget.nextScreen!;
          },
        ),
      );
   ```

### Lottie as Splash Screen

1. Install dependencies for Lottie
   - Run the following command to install the necessary tools for setting up Lottie as a splash screen:
   ```bash
   dart run splash_master install lottie
   ```
   - This command installs npm, Puppeteer and PuppeteerLottie.
3. Add lottie animation to assets
   - Place your Lottie JSON file (e.g., your_lottie.json) in the assets folder.
4. Generate First Frame for Splash screen
   - Run the following command to generate the first frame for your Lottie splash screen:
    ```bash
   dart run splash_master lottie assets/your_lottie.json
   ```
   - Similar to video, this command will generate images in different resolutions and place them
     in appropriate folders.

5. Setup iOS Splash
   - Run the following command to configure the iOS splash screen:
   ```bash
   dart run splash_master setup native_splash
   ```
6. Use `SplashMaster.lottie` widget
   ```dart
   SplashMaster.lottie(
    nextScreen: const Home(),// The screen which will be shown after splash.
    source: AssetSource(Assets.sampleLottie), // Source of the lottie.
    lottieConfig: const LottieConfig(),
    customNavigation: () {}, // Optional custom navigation logic.
   );
   ```
   Customization Options:
   - lottieConfig: Customise your Lottie widget.
   - customNavigation: This function will be triggered when the Lottie animation ends, allowing you to implement your custom navigation logic.


### Image as a Splash Screen

1. Add image to assets
   - Place your image file (e.g., your_image.png) in the assets folder.

2. Generate Image Splash Screen
   - Run the following command to generate the image splash screen in different resolutions and place them
     in appropriate folders.
    ```bash
   dart run splash_master image assets/your_image.png
   ```
 

**Optional**

*You may need to change the content mode in iOS as per your video resolutions. To do this follow the below mentioned steps*

1. Open the iOS project in Xcode.
2. Navigate to Runner -> LaunchScreen and select the LaunchImage in the View Controller Scene.
3. In the properties section on the right, change the Content Mode to Aspect Fit (or another preferred mode).


## Set up app initialization

- Native splash screen will be removed immediately when flutter starts rendering the frame. If you would like to pause or preserve the the native splash until initialization is not complete in flutter. You can do this by calling a `SplashMaster.initialize()` and `SplashMaster.resume()` methods.
- `initialize()` will preserve the native splash until initialization is not finished.
- If you are not writing custom logic in `onSourceLoaded` callback in `SplashMaster.video()` and `SplashMaster.lottie()` then you don't need to call `resume()` method to resume frames. It will implicitly managed by plugin itself once provided source(Video/Lottie) is initialized. Otherwise you have to call `resume()` method explicitly to resume the rendering process.


## How to use

- In `main` method you have to add below code snippet at start

```dart
void main() {
   WidgetsFlutterBinding.ensureInitialized();
   SplashMaster.initialize();
   runApp(MyApp());
}
```
- For Video as Splash Screen

```dart
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SplashMaster.video(
      source: AssetSource('assets/sample_video.mp4'),
      videoConfig: const VideoConfig(
        videoVisibilityEnum: VideoVisibilityEnum.useFullScreen,
      ),
      nextScreen: const Home(),
    );
  }
}
```


## Properties of `SplashMaster.video()` and `SplashMaster.lottie`:

The common properties used in `SplashMaster.lottie()` and `SplashMaster.video()` are largely the same. The key difference between the two is the use of `videoConfig` and `lottieConfig`, which allow for configuration customization specific to video and Lottie animations, respectively.


| Name             | Description                                                    |
|------------------|----------------------------------------------------------------|
| source           | Media source                                                   |
| videoConfig      | To change the video's configuration                            |
| lottieConfig     | To change the lottie's configuration                           |
| backGroundColor  | To change the background color of the splash screen            |
| nextScreen       | Where to navigate once splash finished                         |
| customNavigation | Callback to handle your logic what to do when splash completed |
| onSourceLoaded   | Called when provided media loaded                              |