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

import 'package:xml/xml.dart';
import 'package:yaml/yaml.dart';

import '../splash_master.dart';
import 'logging.dart';

part 'android_splash.dart';
part 'ios_splash.dart';
part 'macos_splash.dart';

Future<void> commandEntry(List<String> arguments) async {
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
          await setupSplashScreen(splashData);
        } catch (e) {
          log(e.toString());
        }
      }
    case Command.none:
      log('Invalid command or arguments.');
  }
}

/// Setting up the splash screen using the details provided in `pubspec.yaml` file under `splash_master`.
Future<void> setupSplashScreen(YamlMap splashData) async {
  final splashKeys = splashData.keys.map((e) => e.toString()).toSet();
  final unsupportedTopLevelKeys = splashKeys
      .where((key) => !YamlKeys.supportedYamlKeys.contains(key))
      .toList();
  final hasAndroid12Section =
      splashKeys.contains(YamlKeys.android12AndAboveKey);

  // --- Platform Directory Checks ---
  final hasAndroidFolder = Directory(AndroidStrings.android).existsSync();
  final hasIosFolder = Directory(IOSStrings.ios).existsSync();
  final hasMacosFolder = Directory(DesktopStrings.macos).existsSync();

  if (!hasAndroidFolder && !hasIosFolder && !hasMacosFolder) {
    log('No supported platform folders (android/, ios/, macos/) found. Skipping splash generation.');
    return;
  }

  /// Checking keys in the `splash_master` section in `pubspec.yaml` file is proper or not.
  if (unsupportedTopLevelKeys.isNotEmpty) {
    log(
      'Unsupported key(s) in splash_master: '
      '${unsupportedTopLevelKeys.join(', ')}. '
      'Supported keys are: ${YamlKeys.supportedYamlKeys.join(', ')}',
    );
    return;
  }

  final android12AndAboveRaw = splashData[YamlKeys.android12AndAboveKey];
  final android12AndAbove =
      hasAndroid12Section && (android12AndAboveRaw == null)
          ? (loadYaml('{}') as YamlMap)
          : (android12AndAboveRaw is YamlMap ? android12AndAboveRaw : null);
  if (hasAndroid12Section &&
      android12AndAboveRaw != null &&
      android12AndAboveRaw is! YamlMap) {
    log('Please check the android_12_and_above configuration. All parameters must be nested under the android_12_and_above key.');
    return;
  }

  if (android12AndAbove != null) {
    final android12Keys =
        android12AndAbove.keys.map((e) => e.toString()).toSet();
    final unsupportedAndroid12Keys = android12Keys
        .where(
          (key) => !YamlKeys.supportedAndroid12AndAboveYamlKeys.contains(key),
        )
        .toList();
    if (unsupportedAndroid12Keys.isNotEmpty) {
      log(
        'Unsupported key(s) in android_12_and_above: '
        '${unsupportedAndroid12Keys.join(', ')}. '
        'Supported keys are: '
        '${YamlKeys.supportedAndroid12AndAboveYamlKeys.join(', ')}',
      );
      return;
    }
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

  final iosContentMode =
      _tryParseIosContentMode(splashData[YamlKeys.iosContentModeKey]);
  final iosBackgroundContentMode = _tryParseIosContentMode(
    splashData[YamlKeys.iosBackgroundContentMode],
  );

  /// Checking if provided content mode is valid or not
  if (splashData[YamlKeys.iosContentModeKey] != null &&
      !IosContentMode.values.any(
        (element) => element == iosContentMode,
      )) {
    log('Please check the ios_content_mode');
    return;
  }

  /// Checking if provided background content mode is valid or not
  if (splashData[YamlKeys.iosBackgroundContentMode] != null &&
      !IosContentMode.values.any(
        (element) => element == iosBackgroundContentMode,
      )) {
    log('Please check the ios_background_content_mode');
    return;
  }

  if (!_validateImageExtensionIfProvided(
    splashData[YamlKeys.imageKey],
    keyName: YamlKeys.imageKey,
  )) {
    return;
  }
  if (!_validateImageExtensionIfProvided(
    splashData[YamlKeys.imageDarkKey],
    keyName: YamlKeys.imageDarkKey,
  )) {
    return;
  }
  if (!_validateImageExtensionIfProvided(
    splashData[YamlKeys.backgroundImage],
    keyName: YamlKeys.backgroundImage,
  )) {
    return;
  }
  if (!_validateImageExtensionIfProvided(
    splashData[YamlKeys.backgroundImageDarkKey],
    keyName: YamlKeys.backgroundImageDarkKey,
  )) {
    return;
  }

  if (android12AndAbove != null) {
    if (!_validateImageExtensionIfProvided(
      android12AndAbove[YamlKeys.imageKey],
      keyName: '${YamlKeys.android12AndAboveKey}.${YamlKeys.imageKey}',
    )) {
      return;
    }
    if (!_validateImageExtensionIfProvided(
      android12AndAbove[YamlKeys.imageDarkKey],
      keyName: '${YamlKeys.android12AndAboveKey}.${YamlKeys.imageDarkKey}',
    )) {
      return;
    }
    if (!_validateImageExtensionIfProvided(
      android12AndAbove[YamlKeys.brandingImageKey],
      keyName: '${YamlKeys.android12AndAboveKey}.${YamlKeys.brandingImageKey}',
    )) {
      return;
    }
    if (!_validateImageExtensionIfProvided(
      android12AndAbove[YamlKeys.brandingImageDarkKey],
      keyName:
          '${YamlKeys.android12AndAboveKey}.${YamlKeys.brandingImageDarkKey}',
    )) {
      return;
    }
  }

  if (splashData[YamlKeys.androidBackgroundGravity] != null &&
      !(AndroidGravity.values.any(
        (element) =>
            element ==
            AndroidGravity.fromString(
                splashData[YamlKeys.androidBackgroundGravity]),
      ))) {
    log('Please check the android_background_image_gravity');
    return;
  }

  // --- Platform-specific Splash Generation ---
  try {
    // Android Splash Handling
    if (hasAndroidFolder) {
      await applyAndroidSplashImage(
        imageSource: splashData[YamlKeys.imageKey],
        color: splashData[YamlKeys.colorKey],
        gravity: splashData[YamlKeys.androidGravityKey],
        android12AndAbove: android12AndAbove,
        backgroundImageSource: splashData[YamlKeys.backgroundImage],
        backgroundImageGravity: splashData[YamlKeys.androidBackgroundGravity],
        darkColor: splashData[YamlKeys.colorDarkKey],
        darkGravity: splashData[YamlKeys.androidDarkGravityKey],
        darkImage: splashData[YamlKeys.imageDarkKey],
        darkBackgroundImageSource: splashData[YamlKeys.backgroundImageDarkKey],
      );
    } else {
      log('android/ folder not found. Skipping Android splash generation.');
    }

    // iOS Splash Handling
    if (hasIosFolder) {
      final iosSkipReasons = <String>[];
      if (splashData[YamlKeys.imageDarkKey] != null &&
          splashData[YamlKeys.imageKey] == null) {
        iosSkipReasons.add(
          'For iOS, image is required when image_dark is provided. '
          'Add image to provide the base Any appearance asset.',
        );
      }
      if (splashData[YamlKeys.backgroundImageDarkKey] != null &&
          splashData[YamlKeys.backgroundImage] == null) {
        iosSkipReasons.add(
          'For iOS, background_image is required when background_image_dark is provided. '
          'Add background_image to provide the base Any appearance asset.',
        );
      }
      if (iosSkipReasons.isNotEmpty) {
        log('Skipping iOS splash generation: \n${iosSkipReasons.join(' ')}');
      } else {
        await generateIosImages(
          imageSource: splashData[YamlKeys.imageKey],
          color: splashData[YamlKeys.colorKey],
          backgroundImage: splashData[YamlKeys.backgroundImage],
          iosContentMode: iosContentMode?.mode,
          iosBackgroundContentMode: iosBackgroundContentMode?.mode,
          darkImageSource: splashData[YamlKeys.imageDarkKey],
          darkColor: splashData[YamlKeys.colorDarkKey],
          darkBackgroundImage: splashData[YamlKeys.backgroundImageDarkKey],
        );
      }
    } else {
      log('ios/ folder not found. Skipping iOS splash generation.');
    }

    // macOS Splash Handling
    final hasDesktopSection = splashKeys.contains(YamlKeys.desktopKey);
    final desktopConfig = splashData[YamlKeys.desktopKey];
    final isDesktopConfigValid = desktopConfig is YamlMap;

    if (hasMacosFolder && hasDesktopSection) {
      final hasMacosSection = desktopConfig.containsKey(YamlKeys.macosKey);
      final macosConfig = desktopConfig?[YamlKeys.macosKey];
      if ((!hasMacosSection && isDesktopConfigValid) ||
          (hasMacosSection && macosConfig is YamlMap && isDesktopConfigValid)) {
        await applyMacosSplash(
          macosConfig: macosConfig,
          commonConfig: desktopConfig,
        );
      } else {
        log('macos/desktop splash config must be a map.');
        return;
      }
    } else if (hasDesktopSection && !hasMacosFolder) {
      log('macos/ folder not found. Skipping macOS splash generation.');
    }
  } on SplashMasterException catch (e) {
    log(e.message);
  }
}

/// Generates Android splash assets and updates Android resource files.
///
/// It creates splash images (including optional dark/background variants),
/// generates Android 12+ assets from `android12AndAbove`, writes color resources,
/// builds splash drawable XMLs for light and dark themes, updates `styles.xml`,
/// and updates dark styles when any dark-mode input is provided.
Future<void> applyAndroidSplashImage({
  String? imageSource,
  String? color,
  String? gravity,
  YamlMap? android12AndAbove,
  String? backgroundImageSource,
  String? backgroundImageGravity,
  String? darkImage,
  String? darkColor,
  String? darkGravity,
  String? darkBackgroundImageSource,
}) async {
  await generateAndroidImages(
    imageSource: imageSource,
    darkImageSource: darkImage,
  );
  if (backgroundImageSource != null) {
    await generateAndroidImages(
      imageSource: backgroundImageSource,
      backgroundImageName: AndroidStrings.splashBackgroundImagePng,
    );
  }
  if (darkBackgroundImageSource != null) {
    await generateAndroidImages(
      imageSource: darkBackgroundImageSource,
      backgroundImageName: AndroidStrings.splashBackgroundImageDarkPng,
    );
  }
  await generateImageForAndroid12AndAbove(
    android12AndAbove: android12AndAbove,
  );
  await createColors(color: color ?? AndroidStrings.defaultLightColor);
  if (darkColor != null) {
    await createColors(color: darkColor, isDark: true);
  }
  await createSplashImageDrawable(
    imageSource: imageSource,
    color: color ?? AndroidStrings.defaultLightColor,
    gravity: gravity,
    backgroundImageSource: backgroundImageSource,
    backgroundImageGravity: backgroundImageGravity,
  );
  await createDarkSplashImageDrawable(
    darkImage: darkImage,
    color: darkColor,
    gravity: darkGravity ?? gravity,
    darkBackgroundImageSource: darkBackgroundImageSource,
    backgroundImageGravity: backgroundImageGravity,
  );
  await updateStylesXml(
    android12AndAbove: android12AndAbove,
    hasDarkDrawable: darkImage != null ||
        darkColor != null ||
        darkBackgroundImageSource != null,
  );
  final darkBrandingImage = android12AndAbove?[YamlKeys.brandingImageDarkKey];
  // Always call updateDarkStylesXml — it will remove existing dark-style files
  // when no dark configuration is provided, avoiding stale references.
  await updateDarkStylesXml(
    android12AndAbove: android12AndAbove,
    darkColor: darkColor,
    darkImage: darkImage,
    darkBrandingImage: darkBrandingImage,
    darkBackgroundImageSource: darkBackgroundImageSource,
  );
}

IosContentMode? _tryParseIosContentMode(dynamic mode) {
  if (mode == null) {
    return null;
  }

  final modeString = mode.toString();
  for (final supportedMode in IosContentMode.values) {
    if (supportedMode.mode == modeString) {
      return supportedMode;
    }
  }

  return null;
}

bool _validateImageExtensionIfProvided(
  dynamic imagePath, {
  required String keyName,
}) {
  if (imagePath == null) {
    return true;
  }

  final path = imagePath.toString().trim();
  final parts = path.split('.');
  if (parts.length < 2 || parts.last.isEmpty) {
    log('$keyName should point to a png, jpg, or jpeg asset.');
    return false;
  }

  final extension = parts.last.toLowerCase();
  final isSupported = SupportedImageExtensions.values.any(
    (supported) => supported.name == extension,
  );

  if (!isSupported) {
    log('$keyName should point to a png, jpg, or jpeg asset.');
    return false;
  }

  return true;
}

/// Applies the splash screen for macOS using details from the YAML file.
Future<void> applyMacosSplash({
  required YamlMap commonConfig,
  YamlMap? macosConfig,
}) async {
  // Extract config values with fallback logic
  final image =
      macosConfig?[YamlKeys.imageKey] ?? commonConfig[YamlKeys.imageKey];
  final color =
      macosConfig?[YamlKeys.colorKey] ?? commonConfig[YamlKeys.colorKey];
  final imageDark = macosConfig?[YamlKeys.imageDarkKey] ??
      commonConfig[YamlKeys.imageDarkKey];
  final colorDark = macosConfig?[YamlKeys.colorDarkKey] ??
      commonConfig[YamlKeys.colorDarkKey];
  final brandingImage = macosConfig?[YamlKeys.brandingImageKey] ??
      commonConfig[YamlKeys.brandingImageKey];
  final brandingImageDark = macosConfig?[YamlKeys.brandingImageDarkKey] ??
      commonConfig[YamlKeys.brandingImageDarkKey];
  final imagePosition = macosConfig?[YamlKeys.imagePositionKey] ??
      commonConfig[YamlKeys.imagePositionKey];
  final imageFit =
      macosConfig?[YamlKeys.imageFitKey] ?? commonConfig[YamlKeys.imageFitKey];
  final brandingPosition = macosConfig?[YamlKeys.brandingImagePositionKey] ??
      commonConfig[YamlKeys.brandingImagePositionKey];
  final brandingSpacing = macosConfig?[YamlKeys.brandingImageSpacingKey] ??
      commonConfig[YamlKeys.brandingImageSpacingKey];
  final splashWindowWidth = macosConfig?[YamlKeys.splashWindowWidthKey] ??
      commonConfig[YamlKeys.splashWindowWidthKey];
  final splashWindowHeight = macosConfig?[YamlKeys.splashWindowHeightKey] ??
      commonConfig[YamlKeys.splashWindowHeightKey];
  final mainWindowWidth = macosConfig?[YamlKeys.mainWindowWidthKey] ??
      commonConfig[YamlKeys.mainWindowWidthKey];
  final mainWindowHeight = macosConfig?[YamlKeys.mainWindowHeightKey] ??
      commonConfig[YamlKeys.mainWindowHeightKey];
  final borderless = macosConfig?[YamlKeys.borderlessKey] ??
      commonConfig[YamlKeys.borderlessKey];

  // If no relevant macOS splash configuration is provided,
  // skip the entire process
  if (image == null &&
      brandingImage == null &&
      imageDark == null &&
      brandingImageDark == null &&
      color == null &&
      colorDark == null) {
    log('No macOS splash images provided. Skipping asset generation and MainFlutterWindow.swift modification for macOS.');
    return;
  }

  // Asset generation step
  await generateMacosSplashAssets(
    image: image,
    imageDark: imageDark,
    brandingImage: brandingImage,
    brandingImageDark: brandingImageDark,
    backgroundColor: color,
    backgroundColorDark: colorDark,
  );

  // Modify MainFlutterWindow.swift with the provided configuration
  final config = DesktopConfigDm(
      hasSplashImage: image != null,
      hasBrandingImage: brandingImage != null,
      imageFit: DesktopImageFit.fromString(
          imageFit ?? DesktopStrings.imageFitDefaultValue),
      imagePosition: DesktopImagePosition.fromString(
          imagePosition ?? DesktopStrings.imagePositionDefaultValue),
      brandingPosition: DesktopBrandingPosition.fromString(
          brandingPosition ?? DesktopStrings.brandingPositionDefaultValue),
      brandingSpacing: brandingSpacing is num
          ? brandingSpacing.toInt()
          : DesktopStrings.defaultBrandingSpacing,
      splashWindowWidth: splashWindowWidth is num
          ? splashWindowWidth.toInt()
          : DesktopStrings.defaultSplashWindowWidth,
      splashWindowHeight: splashWindowHeight is num
          ? splashWindowHeight.toInt()
          : DesktopStrings.defaultSplashWindowHeight,
      mainWindowWidth: mainWindowWidth is num
          ? mainWindowWidth.toInt()
          : DesktopStrings.defaultMainWindowWidth,
      mainWindowHeight: mainWindowHeight is num
          ? mainWindowHeight.toInt()
          : DesktopStrings.defaultMainWindowHeight,
      macosConfig: MacosConfigDm(
        borderless: borderless is bool
            ? borderless
            : DesktopStrings.defaultMacosBorderless,
      ));

  // Call the function to generate the modified MainFlutterWindow.swift file
  await generateMainFlutterWindowFile(config);

  // AppDelegate modification step
  if (image != null ||
      brandingImage != null ||
      imageDark != null ||
      brandingImageDark != null) {
    await addSplashChannelToAppDelegate();
  } else {
    // remove existing splash channel from AppDelegate
    // if it exists to avoid stale code when user removes splash config
    //await removeSplashChannelFromAppDelegate();
  }
}
