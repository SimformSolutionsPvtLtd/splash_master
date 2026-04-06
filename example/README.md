# splash_master_example

This example app demonstrates how to use the splash_master plugin with runnable defaults.

## Features Demonstrated

This example highlights common splash_master configuration areas, including:

- ✅ **Light & Dark Mode Support** - Separate splash screens for Android dark mode
- ✅ **Platform-Specific Configuration** - Different image behaviors for iOS and Android  
- ✅ **Background Images** - Light and dark Android background images plus iOS background behavior
- ✅ **Android 12+ Support** - Custom splash icons and light/dark branding images for Android 12+
- ✅ **Gravity vs Content Mode** - Understanding the difference between Android gravity and iOS content mode

> **Note on iOS Dark Mode**: The current version of splash_master does not support iOS-specific dark mode parameters (like `image_dark_ios`, `ios_dark_content_mode`, or `color_dark_ios`). iOS uses the same splash configuration for both light and dark appearance modes. Dark mode support is currently available only for Android.

## Configuration Overview

The `pubspec.yaml` file in this example contains a minimal runnable configuration. Expanded snippets below show additional optional parameters you can add.

### Light Mode Configuration
```yaml
splash_master:
  color: '#FFFFFF'                                    # Background color (light mode)
  image: 'assets/simform_splash_img.png'             # Main splash image
  ios_content_mode: 'aspectFit'                       # iOS image positioning
  android_gravity: 'center'                           # Android image positioning
```

### Background Image
```yaml
  background_image: 'assets/background_image.png'     # Background image
  background_image_dark_android: 'assets/background_image_dark.png' # Android dark background image
  ios_background_content_mode: 'scaleToFill'          # iOS background positioning
  android_background_image_gravity: 'fill'            # Android background positioning
```

### Android Dark Mode
```yaml
  image_dark_android: 'assets/simform_splash_img_dark.png'  # Dark mode image
  android_dark_gravity: 'center'                             # Dark mode positioning
  color_dark_android: '#000000'                              # Dark mode background color
```

### Android 12+ Configuration
```yaml
  android_12_and_above:
    color: '#FFFFFF'                                  # Android 12+ background color
    image: 'assets/splash_12.png'                     # Custom splash icon (288x288dp)
    branding_image: 'assets/branding_image.png'       # Bottom branding image (max 80dp)
    branding_image_dark: 'assets/branding_image_dark.png' # Dark mode branding image
```

## Understanding Platform Differences

### iOS Content Mode
iOS uses `content_mode` to control how images are displayed within their bounds. Common values:
- `center` - Centers the image without scaling
- `aspectFit` - Scales to fit while maintaining aspect ratio
- `aspectFill` - Fills the entire area while maintaining aspect ratio
- `scaleToFill` - Stretches to fill the entire area

### Android Gravity
Android uses `gravity` to position images within their container. Common values:
- `center` - Centers the image
- `fill` - Stretches the image to fill the container
- `top`, `bottom`, `left`, `right` - Aligns to specific edges
- `fill_horizontal`, `fill_vertical` - Fills in one direction

### Android Dark Mode
Currently, splash_master supports dark mode configuration only for Android. The dark mode splash screen is automatically used when the device is in dark mode.

- `image_dark_android` swaps the main splash image in dark mode.
- `background_image_dark_android` swaps the background image for the pre-Android 12 drawable splash.
- `android_background_image_gravity` controls both light and dark background image placement on Android.
- `branding_image_dark` inside `android_12_and_above` swaps the Android 12+ branding image in dark mode.

Validation behavior:
- `branding_image`, `branding_image_dark`, and Android 12 `image`/`color` are valid only inside `android_12_and_above`.
- Unknown keys at the top level or inside `android_12_and_above` are rejected.

**Note:** iOS dark mode splash support is not currently available in the plugin. iOS will use the same splash screen for both light and dark modes.

### Android 12+ Splash Screen
Android 12 introduced a new system-controlled splash screen with specific requirements:
- **Splash Icon**: Should be a simple, centered icon (ideally 288x288dp)
- **Branding Image**: Optional bottom image (max 80dp height)
- **Background Color**: Single color background

## Running the Example

1. Ensure you have Flutter installed and configured
2. Clone the repository
3. Navigate to the example directory:
   ```bash
   cd example
   ```
4. Get dependencies:
   ```bash
   flutter pub get
   ```
5. Generate the native splash screens:
   ```bash
   dart run splash_master create
   ```
6. Run the app:
   ```bash
   flutter run
   ```

## Testing Dark Mode

### Android
To test dark mode on Android:
1. Run the app on an Android device or emulator
2. Enable dark mode in system settings: Settings → Display → Dark theme
3. Restart the app to see the dark mode splash screen

### iOS
iOS does not currently support separate dark mode splash screens in splash_master. The light mode splash will be used regardless of system theme.

## Additional Resources

For more information about splash_master configuration and advanced features, see:
- [Main Documentation](https://simform-flutter-packages.web.app/splashMaster)
- [GitHub Repository](https://github.com/SimformSolutionsPvtLtd/splash_master)

## Getting Started with Flutter

If this is your first Flutter project, here are some resources:
- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- [Online documentation](https://docs.flutter.dev/)
