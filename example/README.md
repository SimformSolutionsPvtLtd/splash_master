# splash_master_example

This example app demonstrates how to use the splash_master plugin with runnable defaults.

## Features Demonstrated

This example highlights common splash_master configuration areas, including:

- ✅ **Light & Dark Mode Support** - Separate splash screens for Android dark mode
- ✅ **Platform-Specific Configuration** - Different image behaviors for iOS and Android  
- ✅ **Background Images** - Light and dark Android background images plus iOS background behavior
- ✅ **Android 12+ Support** - Custom splash icons and light/dark branding images for Android 12+
- ✅ **Gravity vs Content Mode** - Understanding the difference between Android gravity and iOS content mode

## Configuration Overview

The `pubspec.yaml` file in this example contains a minimal runnable configuration. Expanded snippets below show additional optional parameters you can add.

### Light Mode Configuration
```yaml
splash_master:
  color: '#FFFFFF'                                    # Background color (light mode)
  image: 'assets/simform_splash_img.png'             # Main splash image
  ios_content_mode: 'scaleAspectFit'                  # iOS image positioning
  android_gravity: 'center'                           # Pre-Android 12 image positioning
```

### Background Image
```yaml
  background_image: 'assets/background_image.png'          # Background image
  background_image_dark: 'assets/background_image_dark.png' # Dark mode background image
  ios_background_content_mode: 'scaleToFill'                # iOS background positioning
  android_background_image_gravity: 'fill'                  # Android background positioning
```

### Dark Mode — Common Configuration
```yaml
  image_dark: 'assets/simform_splash_img_dark.png'  # Dark mode image
  color_dark: '#000000'                              # Dark mode background color
```

### Android Dark Mode Behavior
```yaml
  android_dark_gravity: 'center'  # Pre-Android 12 dark image positioning (falls back to android_gravity)
```

### Android 12+ Configuration
Android 12+ uses the system splash screen API, so icon positioning is system-controlled and gravity does not apply.

```yaml
  android_12_and_above:
    color: '#FFFFFF'                                  # Android 12+ background color
    image: 'assets/splash_12.png'                     # Android 12+ splash icon (288x288dp)
    image_dark: 'assets/splash_12_dark.png'           # Android 12+ dark splash icon (optional)
    color_dark: '#000000'                             # Android 12+ dark background color (optional)
    branding_image: 'assets/branding_image.png'       # Android 12+-only bottom branding image (max 80dp)
    branding_image_dark: 'assets/branding_image.png'  # Android 12+-only dark branding image (same asset in this example)
```

## Understanding Platform Differences

### iOS Content Mode
iOS uses `content_mode` to control how images are displayed within their bounds. Supported values:
- `center` - Centers the image without scaling
- `scaleAspectFit` - Scales to fit while maintaining aspect ratio
- `scaleAspectFill` - Fills the entire area while maintaining aspect ratio
- `scaleToFill` - Stretches to fill the entire area
- `redraw` - Redraws the content when bounds change
- `top`, `bottom`, `left`, `right` - Pins the image to one edge
- `topLeft`, `topRight`, `bottomLeft`, `bottomRight` - Pins the image to one corner

The same value set is used by both `ios_content_mode` and `ios_background_content_mode`.

### Android Gravity
Android uses `gravity` to position images within their container. Supported values:
- `center` - Centers the image
- `fill` - Stretches the image to fill the container
- `top`, `bottom`, `left`, `right` - Aligns to specific edges
- `fill_horizontal`, `fill_vertical` - Fills in one direction
- `clip_horizontal`, `clip_vertical` - Clips overflow in one direction
- `center_horizontal`, `center_vertical` - Centers on one axis
- `start`, `end` - Aligns relative to layout direction

The same value set is used by `android_gravity`, `android_dark_gravity`, and `android_background_image_gravity`.
These gravity keys affect the pre-Android 12 drawable splash implementation.
Android 12+ does not support gravity-based splash icon positioning.

### Android Dark Mode
The common `image_dark`, `color_dark`, and `background_image_dark` keys control dark mode on Android.
The optional `android_dark_gravity` key fine-tunes pre-Android 12 dark image positioning; when omitted, it falls back to `android_gravity`.
It does not affect Android 12+, where the splash icon is positioned by the system.

- `image_dark` swaps the main splash image in dark mode.
- `background_image_dark` swaps the background image for the pre-Android 12 drawable splash.
- `android_background_image_gravity` controls both light and dark background image placement on Android.
- Inside `android_12_and_above`: light keys `image` and `color` are **isolated** from top-level parameters—they do not fall back and must be explicitly set if needed for Android 12+.
- Inside `android_12_and_above`, dark mode keys follow this fallback hierarchy:
    - `image_dark` → falls back to `android_12_and_above.image` only (no fallback to top-level)
    - `color_dark` → no fallback; must be explicitly set if needed
- `branding_image_dark` inside `android_12_and_above` swaps the Android 12+ branding image in dark mode.
- `branding_image` and `branding_image_dark` are Android 12+-only and are not supported on iOS.

Validation behavior:
- `branding_image` and `branding_image_dark` are only valid inside `android_12_and_above` and will be rejected at the top level.
- Unknown keys at the top level or inside `android_12_and_above` are rejected.

### Android 12+ Splash Screen
Android 12 introduced a new system-controlled splash screen with specific requirements:
- **Splash Icon**: Should be a simple, centered icon (ideally 288x288dp)
- **Branding Image**: Optional bottom image (max 80dp height)
- **Background Color**: Single color background
- **Gravity**: Not supported for Android 12+ splash icons

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
iOS uses the same splash configuration for both light and dark appearance modes.
Branding images are not supported on iOS.

## Additional Resources

For more information about splash_master configuration and advanced features, see:
- [Main Documentation](https://simform-flutter-packages.web.app/splashMaster)
- [GitHub Repository](https://github.com/SimformSolutionsPvtLtd/splash_master)

## Getting Started with Flutter

If this is your first Flutter project, here are some resources:
- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- [Online documentation](https://docs.flutter.dev/)
