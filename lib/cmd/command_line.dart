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

import 'dart:convert';
import 'dart:io';

import 'package:splash_master/cmd/cmd_strings.dart';
import 'package:splash_master/cmd/cmd_utils.dart';
import 'package:splash_master/cmd/models/ios_content_json_dm.dart';
import 'package:splash_master/cmd/splash_screen_content_string.dart';
import 'package:splash_master/cmd/yaml_config/support_parameter.dart';
import 'package:splash_master/core/utils.dart';
import 'package:splash_master/values/android_strings.dart';
import 'package:splash_master/values/ios_strings.dart';
import 'package:splash_master/values/yaml_keys.dart';
import 'package:xml/xml.dart';
import 'package:yaml/yaml.dart';

import 'logging.dart';

part 'android_splash.dart';

part 'ios_splash.dart';

void commandEntry(List<String> arguments) {
  if (arguments.isEmpty) {
    log('Usage: dart run splash_master <command>');
    log('Command:');
    log('  create  To create and setup the splash screen');
    return;
  }

  final argument = arguments[0];

  final command = Command.fromString(argument);
  switch (command) {
    case Command.create:
      if (arguments.length == 1) {
        const filePath = 'pubspec.yaml';
        try {
          final yamlMap =
              loadYaml(File(filePath).readAsStringSync()) as YamlMap;
          if (yamlMap[YamlKeys.splashMasterKey].runtimeType != YamlMap) {
            throw SplashMasterException(message: 'Unable to read yaml file.');
          }

          final splashData = yamlMap[YamlKeys.splashMasterKey];
          if (splashData.runtimeType != YamlMap) {
            log("splash_master section isn't formatted correctly.");
            return;
          }

          /// [splashData] is data that is being extracted from the YAML file.
          setupSplashScreen(splashData);
        } catch (e) {
          log(e.toString());
        }
      }
    case Command.none:
      log('Invalid command or arguments.');
  }
}

/// Setting up the splash screen using the details provided in `pubspec.yaml` file under `splash_master`.
void setupSplashScreen(YamlMap splashData) {
  /// Checking keys in the `splash_master` section in `pubspec.yaml` file is proper or not.
  if (YamlKeys.supportedYamlKeys.any(
    (element) => splashData.keys.any(
      (e) => e == element,
    ),
  )) {
    IosContentMode? iosContentMode;
    if (splashData[YamlKeys.iosContentModeKey] != null) {
      iosContentMode =
          IosContentMode.fromString(splashData[YamlKeys.iosContentModeKey]);
    }

    /// Checking if provided android gravity is valid or not
    if (splashData[YamlKeys.androidGravityKey] != null &&
        !(AndroidGravity.values.any(
          (element) =>
              element ==
              AndroidGravity.fromString(splashData[YamlKeys.androidGravityKey]),
        ))) {
      log('Please check the android_gravity');
      return;
    }

    /// Checking if provided content mode is valid or not
    else if (splashData[YamlKeys.iosContentModeKey] != null &&
        !IosContentMode.values.any(
          (element) => element == iosContentMode,
        )) {
      log('Please check the ios_content_mode');
      return;
    }

    /// Checking if provided image has supported extension or not
    else if (splashData[YamlKeys.imageKey] != null) {
      final imgExtension =
          splashData[YamlKeys.imageKey].toString().split('.').last;
      if (!SupportedImageExtensions.values.any(
        (element) =>
            element ==
            SupportedImageExtensions.fromString(imgExtension.toLowerCase()),
      )) {
        log('Image should be png or jpg');
        return;
      }
    } else if (splashData[YamlKeys.androidBackgroundGravity] != null &&
        !(AndroidGravity.values.any(
          (element) =>
              element ==
              AndroidGravity.fromString(
                  splashData[YamlKeys.androidBackgroundGravity]),
        ))) {
      log('Please check the android_background_image_gravity');
      return;
    }
    applySplash(
      imageSource: splashData[YamlKeys.imageKey],
      color: splashData[YamlKeys.colorKey],
      gravity: splashData[YamlKeys.androidGravityKey],
      iosContentMode: iosContentMode?.mode,
      backgroundImage: splashData[YamlKeys.backgroundImage],
      android12AndAbove: splashData[YamlKeys.android12AndAboveKey],
      iosBackgroundContentMode: splashData[YamlKeys.iosBackgroundContentMode],
      backgroundImageSource: splashData[YamlKeys.backgroundImage],
      backgroundImageGravity: splashData[YamlKeys.androidBackgroundGravity],
      darkColor: splashData[YamlKeys.colorDarkAndroid],
      darkGravity: splashData[YamlKeys.androidGravityKey],
      darkImage: splashData[YamlKeys.imageDarkAndroid],
    );
  }
}

/// Apply the splash images to Android
Future<void> applyAndroidSplashImage({
  String? imageSource,
  String? color,
  String? gravity,
  YamlMap? android12AndAbove,
  String? backgroundImage,
  String? backgroundImageSource,
  String? backgroundImageGravity,
  String? darkImage,
  String? darkColor,
  String? darkGravity,
}) async {
  await generateAndroidImages(
    imageSource: imageSource,
    darkImageSource: darkImage,
  );
  if (backgroundImageSource != null) {
    generateAndroidImages(
      imageSource: backgroundImageSource,
      backgroundImageName: AndroidStrings.splashBackgroundImagePng,
    );
  }
  await generateImageForAndroid12AndAbove(
    android12AndAbove: android12AndAbove,
  );
  await createColors(
    color: color,
  );
  if (darkColor != null) {
    await createColors(
      color: darkColor,
      isDark: true,
    );
  }
  await createSplashImageDrawable(
    imageSource: imageSource,
    color: color,
    gravity: gravity,
    backgroundImageSource: backgroundImageSource,
    backgroundImageGravity: backgroundImageGravity,
  );
  await createDarkSplashImageDrawable(
    darkImage: darkImage,
    color: darkColor,
    gravity: darkGravity,
  );
  await updateStylesXml(
    android12AndAbove: android12AndAbove,
    color: color,
  );
  if (darkImage != null) {
    await updateDarkStylesXml(
      android12AndAbove: android12AndAbove,
      color: darkColor,
    );
  }
}

/// Applies the splash screen on Android and iOS using details from the YAML file.
Future<void> applySplash({
  String? imageSource,
  String? color,
  String? gravity,
  String? iosContentMode,
  String? backgroundImage,
  String? iosBackgroundContentMode,
  YamlMap? android12AndAbove,
  String? backgroundImageSource,
  String? backgroundImageGravity,
  String? darkImage,
  String? darkColor,
  String? darkGravity,
}) async {
  await generateIosImages(
    imageSource: imageSource,
    color: color,
    backgroundImage: backgroundImage,
    iosContentMode: iosContentMode,
    iosBackgroundContentMode: iosBackgroundContentMode,
  );
  await applyAndroidSplashImage(
    imageSource: imageSource,
    color: color,
    gravity: gravity,
    android12AndAbove: android12AndAbove,
    backgroundImageSource: backgroundImageSource,
    backgroundImageGravity: backgroundImageGravity,
    darkImage: darkImage,
    darkColor: darkColor,
    darkGravity: darkGravity,
  );
}
