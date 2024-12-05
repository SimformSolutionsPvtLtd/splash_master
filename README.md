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

## Usage

Before we proceed further make sure to run this command so that neccessary tool are
installed into your system.

```bash
dart run splash_master install
```

This command installs FFmpeg, npm, Puppeteer and PuppeteerLottie. Since these tools are
installed into you system, your apps bundle size will not increase.

**Note**-: If you're using Windows system then you will have install these tools manually. For Macos
& Linux, this command will suffice.

Before you start setting up splash screen use below command to set native splash for iOS

```bash
dart run splash_master setup native_splash
```

Now, We have 3 ways to show a splash screen.
1. Video
2. Lottie
3. Image/Gif

### Video as a Splash Screen
TODO: Add video as splash demo.

1. Add video to assets
   - Add your video to assets folder so that we use it generate first frame for the splash screen.

2. Run this command for video
    ```bash
   dart run splash_master video path/to/your/video.mp4
   ```
   - This command will generate first frame of the video in different resolutions for android, ios 
   and for flutter as well. These generated images will be automatically placed inside appropriate 
   native folders.
   - For Android, it will create a new splash_image.xml to style the splash screen and will update style.xml to
   use it.
   - For Ios, it will update Contents.json file.
   - On flutter side, since a video takes a bit initialise a high resolution image will placed inside the
   assets folder. You can use this image as first frame of the video so that splash screen to video 
   transition looks smooth.

3. Use SplashMaster widget
   ```dart
   SplashMaster.video(
    nextScreen: const Home(),// The screen which will be shown after splash.
    source: AssetSource(Assets.sampleSplashScreen), // Source of the video.
    imageConfig: const ImageConfig(),
    videoConfig: const VideoConfig(
      firstFrame: 'path/to/generated/splash_screen.png'
      ),
    customNavigation: () {}, 
   );
   ```
   - Use this widget as first widget of your app in the `runApp`.
   - You can customise your video splash using **videoConfig** parameter and to customise the first 
   frame of the flutter splash screen you can use imageConfig.
   - By default, this widget will navigate like this.
   ```dart
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) {
            return widget.nextScreen!;
          },
        ),
      );
   ```
   But if you want to use your custom navigation then you can use customNavigation parameter.
   The customNavigation will called as soon video ends. So initial provided duration will be 
   overridden by video duration.


### Lottie as a Splash Screen

TODO: Add lottie as splash screen demo.

1. Add lottie to assets
   - Add your lottie file to assets folder so that we use it generate first frame for the splash screen.

2. Run this command for lottie

    ```bash
   dart run splash_master lottie path/to/your/video.json
   ```
   - Similar to video, this command will generate images in different resolutions and place them 
   in appropriate folders.

3. Use SplashMaster widget
   ```dart
   SplashMaster.lottie(
    nextScreen: const Home(),// The screen which will be shown after splash.
    source: AssetSource(Assets.sampleLottie), // Source of the lottie.
    lottieConfig: const LottieConfig(
      firstFrame: 'path/to/generated/splash_screen.png'
      ),
    customNavigation: () {}, 
   );
   ```
   You can use **lottieConfig** parameter to customise your Lottie widget. 
   The customNavigation will called as soon lottie ends.

### Image/Gif as a Splash Screen.
TODO: Add lottie as splash screen demo.

1. Add image to assets
   - Add your lottie file to assets folder so that we use it generate first frame for the splash screen.

2. Run this command for image

    ```bash
   dart run splash_master image path/to/your/video.png
   ```
   - Similar to video and lottie, this command will generate images in different resolutions and place them
     in appropriate folders.

3. Use SplashMaster widget
   ```dart
   SplashMaster.image(
    nextScreen: const Home(),// The screen which will be shown after splash.
    splashDuration: const Duration(seconds: 1), // Duration of the splash screen.
    source: AssetSource(Assets.sampleImage), // Source of the image.
    imageConfig: const ImageConfig(),
    customNavigation: () {}, 
   );
   ```
   You can use **imageConfig** parameter to customise your Lottie widget. The customNavigation will 
   be called **splashDuration**.