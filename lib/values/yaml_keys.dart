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

  static const backgroundImage = 'background_image';

  static const iosBackgroundContentMode = 'ios_background_content_mode';

  static const androidBackgroundGravity = 'android_background_image_gravity';

  /// Specifies image for android dark mode
  static const imageDarkAndroid = 'image_dark_android';

  /// Specifies gravity for android dark mode
  static const androidDarkGravityKey = 'android_dark_gravity';

  /// Specifies color for android dark mode
  static const colorDarkAndroid = 'color_dark_android';

  /// List of supported keys
  static List<String> supportedYamlKeys = [
    imageKey,
    colorKey,
    androidGravityKey,
    iosContentModeKey,
    android12AndAboveKey,
    brandingImageKey,
    backgroundImage,
    iosBackgroundContentMode,
    androidBackgroundGravity,
    imageDarkAndroid,
    androidDarkGravityKey,
    colorDarkAndroid,
  ];
}
