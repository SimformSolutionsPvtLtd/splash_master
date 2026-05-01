/*
 * Copyright (c) 2024 Simform Solutions
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

class YamlKeys {
  /// [splashMasterKey] is used to specify the `splash_master` section in `pubspec.yaml`.
  static const splashMasterKey = 'splash_master';

  /// Specifies the splash image.
  static const imageKey = 'image';

  /// Specifies the color in splash screen.
  static const colorKey = 'color';

  /// Specifies the gravity for splash image in the Android.
  static const androidGravityKey = 'android_gravity';

  /// Specifies the content mode for splash image in the iOS.
  static const iosContentModeKey = 'ios_content_mode';

  /// Specifies splash screen setup details for Android 12.
  static const android12AndAboveKey = 'android_12_and_above';

  /// Specifies branding image for the Android 12+
  static const brandingImageKey = 'branding_image';

  /// Specifies the background image for the splash screen.
  static const backgroundImage = 'background_image';

  /// Specifies the content mode for the background image in iOS.
  static const iosBackgroundContentMode = 'ios_background_content_mode';

  /// Specifies the gravity for the background image in Android.
  static const androidBackgroundGravity = 'android_background_image_gravity';

  /// Specifies the dark mode splash image.
  static const imageDarkKey = 'image_dark';

  /// Specifies the dark mode splash screen color.
  static const colorDarkKey = 'color_dark';

  /// Specifies the dark mode background image.
  static const backgroundImageDarkKey = 'background_image_dark';

  /// Specifies the gravity for the Android dark mode splash image.
  static const androidDarkGravityKey = 'android_dark_gravity';

  /// Specifies the dark branding image for Android 12+ dark mode.
  static const brandingImageDarkKey = 'branding_image_dark';

  /// Specifies the desktop (macOS/Windows/Linux) configuration section.
  static const desktopKey = 'desktop';

  /// Specifies the macOS-specific configuration section.
  static const macosKey = 'macos';

  /// Specifies the Windows-specific configuration section.
  static const windowsKey = 'windows';

  //TODO(Lavi)- Add Linux specific keys when needed.

  /// Desktop-specific keys
  static const imageFitKey = 'image_fit';
  static const imagePositionKey = 'image_position';
  static const brandingImagePositionKey = 'branding_position';
  static const brandingImageSpacingKey = 'branding_spacing';
  static const splashWindowWidthKey = 'splash_window_width';
  static const splashWindowHeightKey = 'splash_window_height';
  static const mainWindowWidthKey = 'main_window_width';
  static const mainWindowHeightKey = 'main_window_height';
  static const borderlessKey = 'borderless';

  /// Specifies the animation duration (ms) when the Windows splash is dismissed.
  static const animationDurationKey = 'animation_duration';

  /// Specifies the dismiss animation type for Windows splash.
  static const dismissAnimationKey = 'dismiss_animation';

  // ---------------------------------------------------------------------------

  /// List of supported top-level keys under `splash_master`.
  static List<String> supportedYamlKeys = [
    // Common keys
    imageKey,
    colorKey,
    backgroundImage,
    imageDarkKey,
    colorDarkKey,
    backgroundImageDarkKey,

    // Android-only keys
    androidGravityKey,
    androidBackgroundGravity,
    androidDarkGravityKey,
    android12AndAboveKey,

    // iOS-only keys
    iosContentModeKey,
    iosBackgroundContentMode,

    // Desktop/Platform keys
    desktopKey,
  ];

  /// List of supported nested keys under `android_12_and_above`.
  static List<String> supportedAndroid12AndAboveYamlKeys = [
    imageKey,
    colorKey,
    imageDarkKey,
    colorDarkKey,
    brandingImageKey,
    brandingImageDarkKey,
  ];

  /// List of supported nested keys under `desktop` and `macos`.
  static List<String> supportedDesktopYamlKeys = [
    imageKey,
    colorKey,
    imageDarkKey,
    colorDarkKey,
    brandingImageKey,
    brandingImageDarkKey,
    imageFitKey,
    imagePositionKey,
    brandingImagePositionKey,
    brandingImageSpacingKey,
    splashWindowWidthKey,
    splashWindowHeightKey,
    mainWindowWidthKey,
    mainWindowHeightKey,
    borderlessKey,
    macosKey,
    windowsKey,
    // TODO(Lavi)- Add Linux specific keys when needed.
  ];

  static List<String> supportedMacosYamlKeys = [
    imageKey,
    colorKey,
    imageDarkKey,
    colorDarkKey,
    brandingImageKey,
    brandingImageDarkKey,
    imageFitKey,
    imagePositionKey,
    brandingImagePositionKey,
    brandingImageSpacingKey,
    splashWindowWidthKey,
    splashWindowHeightKey,
    mainWindowWidthKey,
    mainWindowHeightKey,
    borderlessKey,
  ];

  static List<String> supportedWindowsYamlKeys = [
    imageKey,
    colorKey,
    imageDarkKey,
    colorDarkKey,
    brandingImageKey,
    brandingImageDarkKey,
    imageFitKey,
    imagePositionKey,
    brandingImagePositionKey,
    brandingImageSpacingKey,
    splashWindowWidthKey,
    splashWindowHeightKey,
    mainWindowWidthKey,
    mainWindowHeightKey,
    borderlessKey,
    animationDurationKey,
    dismissAnimationKey,
  ];

  // TODO(Lavi)- Add supported Linux  keys when needed.
}
