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
          // Load and parse the YAML file
          final yamlMap = loadYaml(File(filePath).readAsStringSync());
          if (yamlMap[YamlKeys.splashMasterKey] is! YamlMap) {
            throw SplashMasterException(
                message: '[Error] Unable to read yaml file.');
          }
          // Setup splash screen using the configuration
          await setupSplashScreen(yamlMap[YamlKeys.splashMasterKey] as YamlMap);
        } catch (e) {
          log(e.toString());
        }
      } else {
        log("The 'create' command does not accept additional arguments.");
        log('Usage: dart run splash_master create');
      }
    case Command.none:
      log('[Error] Invalid command or arguments.');
  }
}

/// Setting up the splash screen using the details provided in `pubspec.yaml` file under `splash_master`.
Future<void> setupSplashScreen(YamlMap splashData) async {
  final splashKeys = splashData.keys.map((e) => e.toString()).toSet();
  final unsupportedTopLevelKeys = splashKeys
      .where((key) => !YamlKeys.supportedYamlKeys.contains(key))
      .toList();

  final hasAndroid12Section = splashData[YamlKeys.android12AndAboveKey] != null;
  final android12AndAbove = splashData[YamlKeys.android12AndAboveKey];

  final hasDesktopSection = splashData[YamlKeys.desktopKey] != null;
  final desktopData = splashData[YamlKeys.desktopKey];
  var hasMacosSection = false;
  var hasWindowsSection = false;

  // Checking keys in the `splash_master` section in `pubspec.yaml` file is proper or not.
  if (unsupportedTopLevelKeys.isNotEmpty) {
    log(
      '[Error] Unsupported key(s) in splash_master: '
      '${unsupportedTopLevelKeys.join(', ')}. '
      'Supported keys are: ${YamlKeys.supportedYamlKeys.join(', ')}',
    );
    return;
  }
  // Checking if the `android_12_and_above` section is properly structured and valid when present.
  if (hasAndroid12Section) {
    if (android12AndAbove is! YamlMap) {
      log(
        '[Error] Please check the android_12_and_above configuration. '
        'All parameters must be nested under the android_12_and_above key.',
      );
      return;
    } else {
      final android12Keys =
          android12AndAbove.keys.map((e) => e.toString()).toSet();
      final unsupportedAndroid12Keys = android12Keys
          .where(
            (key) => !YamlKeys.supportedAndroid12AndAboveYamlKeys.contains(key),
          )
          .toList();
      if (unsupportedAndroid12Keys.isNotEmpty) {
        log(
          '[Error] Unsupported key(s) in android_12_and_above: '
          '${unsupportedAndroid12Keys.join(', ')}. '
          'Supported keys are: '
          '${YamlKeys.supportedAndroid12AndAboveYamlKeys.join(', ')}',
        );
        return;
      }
    }
  }
  // Checking if the `desktop` section is properly structured when present.
  if (hasDesktopSection) {
    if (desktopData is! YamlMap) {
      log(
        "[Error] 'desktop' section must be a map. "
        "Please check your pubspec.yaml.",
      );
      return;
    } else {
      final desktopKeys = desktopData.keys.map((e) => e.toString()).toSet();
      final unsupportedDesktopKeys = desktopKeys
          .where((key) => !YamlKeys.supportedDesktopYamlKeys.contains(key))
          .toList();
      if (unsupportedDesktopKeys.isNotEmpty) {
        log(
          '[Error] Unsupported key(s) in desktop configuration: '
          '${unsupportedDesktopKeys.join(', ')}. '
          'Supported keys are: ${YamlKeys.supportedDesktopYamlKeys.join(', ')}',
        );
        return;
      }

      // Checking if the `macos` section under `desktop` is properly structured when present.
      hasMacosSection = desktopData[YamlKeys.macosKey] != null;
      if (hasMacosSection) {
        final macosData = desktopData[YamlKeys.macosKey];
        if (macosData is! YamlMap) {
          log(
            "[Error] 'macos' section under 'desktop' must be a map. "
            "Please check your pubspec.yaml.",
          );
          return;
        } else {
          // Checking if keys in `macos` section are supported or not
          final macosKeys = macosData.keys.map((e) => e.toString()).toSet();
          final unsupportedMacosKeys = macosKeys
              .where((key) => !YamlKeys.supportedMacosYamlKeys.contains(key))
              .toList();
          if (unsupportedMacosKeys.isNotEmpty) {
            log(
              '[Error] Unsupported key(s) in macos configuration: '
              '${unsupportedMacosKeys.join(', ')}. '
              'Supported keys are: ${YamlKeys.supportedMacosYamlKeys.join(', ')}',
            );
            return;
          }
        }
      }
      // Checking if the `windows` section under `desktop` is properly structured when present.
      hasWindowsSection = desktopData[YamlKeys.windowsKey] != null;
      if (hasWindowsSection) {
        final windowsData = desktopData[YamlKeys.windowsKey];
        if (windowsData is! YamlMap) {
          log(
            "[Error] 'windows' section under 'desktop' must be a map. "
            "Please check your pubspec.yaml.",
          );
          return;
        } else {
          // Checking if keys in `macos` section are supported or not
          final windowsKeys = windowsData.keys.map((e) => e.toString()).toSet();
          final unsupportedWindowsKeys = windowsKeys
              .where((key) => !YamlKeys.supportedWindowsYamlKeys.contains(key))
              .toList();
          if (unsupportedWindowsKeys.isNotEmpty) {
            log(
              '[Error] Unsupported key(s) in windows configuration: '
              '${unsupportedWindowsKeys.join(', ')}. '
              'Supported keys are: ${YamlKeys.supportedWindowsYamlKeys.join(', ')}',
            );
            return;
          }
        }
      }
    }
  }

  // Image extension validation for common keys on Android and iOS
  for (final key in [
    YamlKeys.imageKey,
    YamlKeys.imageDarkKey,
    YamlKeys.backgroundImage,
    YamlKeys.backgroundImageDarkKey,
  ]) {
    if (!_validateImageExtensionIfProvided(splashData[key], keyName: key)) {
      return;
    }
  }

  // Image extension validation for Android 12+, desktop, macOS, and Windows keys
  for (final key in [
    YamlKeys.imageKey,
    YamlKeys.imageDarkKey,
    YamlKeys.brandingImageKey,
    YamlKeys.brandingImageDarkKey,
  ]) {
    if (hasAndroid12Section &&
        !_validateImageExtensionIfProvided(
          android12AndAbove?[key],
          keyName: '${YamlKeys.android12AndAboveKey}.$key',
        )) {
      return;
    }
    if (hasDesktopSection &&
        !_validateImageExtensionIfProvided(
          desktopData[key],
          keyName: '${YamlKeys.desktopKey}.$key',
        )) {
      return;
    }
    if (hasMacosSection &&
        !_validateImageExtensionIfProvided(
          desktopData?[YamlKeys.macosKey]?[key],
          keyName: '${YamlKeys.desktopKey}.${YamlKeys.macosKey}.$key',
        )) {
      return;
    }
    if (hasWindowsSection &&
        !_validateImageExtensionIfProvided(
          desktopData?[YamlKeys.windowsKey]?[key],
          keyName: '${YamlKeys.desktopKey}.${YamlKeys.windowsKey}.$key',
        )) {
      return;
    }
  }

  // --- Platform-specific Splash Generation ---
  final hasAndroidFolder = Directory(AndroidStrings.android).existsSync();
  final hasIosFolder = Directory(IOSStrings.ios).existsSync();
  final hasMacosFolder = Directory(MacosStrings.macos).existsSync();
  final hasWindowsFolder = Directory(WindowsStrings.windows).existsSync();
  try {
    // Android Splash Handling
    if (hasAndroidFolder) {
      // Checking if provided android gravity is valid or not
      if (splashData[YamlKeys.androidGravityKey] != null &&
          !AndroidGravity.isSupported(
              splashData[YamlKeys.androidGravityKey].toString())) {
        log('[Error] Invalid value of android_gravity');
        return;
      }

      // Checking if provided android dark gravity is valid or not
      if (splashData[YamlKeys.androidDarkGravityKey] != null &&
          !AndroidGravity.isSupported(
              splashData[YamlKeys.androidDarkGravityKey].toString())) {
        log('[Error] Invalid value of android_dark_gravity');
        return;
      }

      // Checking if provided android background gravity is valid or not
      if (splashData[YamlKeys.androidBackgroundGravity] != null &&
          !AndroidGravity.isSupported(
              splashData[YamlKeys.androidBackgroundGravity].toString())) {
        log('[Error] Invalid value of android_background_image_gravity');
        return;
      }

      await _applyAndroidSplashImage(
        imageSource: splashData[YamlKeys.imageKey],
        color: splashData[YamlKeys.colorKey],
        gravity: splashData[YamlKeys.androidGravityKey],
        android12AndAbove: android12AndAbove as YamlMap?,
        backgroundImageSource: splashData[YamlKeys.backgroundImage],
        backgroundImageGravity: splashData[YamlKeys.androidBackgroundGravity],
        darkColor: splashData[YamlKeys.colorDarkKey],
        darkGravity: splashData[YamlKeys.androidDarkGravityKey],
        darkImage: splashData[YamlKeys.imageDarkKey],
        darkBackgroundImageSource: splashData[YamlKeys.backgroundImageDarkKey],
      );
    } else {
      log('[Warning] android/ folder not found. Skipping Android splash generation.');
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

      // If there are reasons to skip iOS splash generation, log them.
      // Otherwise, proceed with generation.
      if (iosSkipReasons.isNotEmpty) {
        log('[Warning] Skipping iOS splash generation: \n${iosSkipReasons.join(' ')}');
      } else {
        // Checking if provided content mode is valid or not
        if (splashData[YamlKeys.iosContentModeKey] != null &&
            !IosContentMode.isSupported(
                splashData[YamlKeys.iosContentModeKey].toString())) {
          log('[Error] Invalid value of ios_content_mode');
          return;
        }
        // Checking if provided background content mode is valid or not
        if (splashData[YamlKeys.iosBackgroundContentMode] != null &&
            !IosContentMode.isSupported(
                splashData[YamlKeys.iosBackgroundContentMode].toString())) {
          log('[Error] Invalid value of ios_background_content_mode');
          return;
        }

        // If the config is valid, proceed with iOS splash generation
        await generateIosImages(
          imageSource: splashData[YamlKeys.imageKey],
          color: splashData[YamlKeys.colorKey],
          backgroundImage: splashData[YamlKeys.backgroundImage],
          iosContentMode: splashData[YamlKeys.iosContentModeKey],
          iosBackgroundContentMode:
              splashData[YamlKeys.iosBackgroundContentMode],
          darkImageSource: splashData[YamlKeys.imageDarkKey],
          darkColor: splashData[YamlKeys.colorDarkKey],
          darkBackgroundImage: splashData[YamlKeys.backgroundImageDarkKey],
        );
      }
    } else {
      log('[Warning] ios/ folder not found. Skipping iOS splash generation.');
    }

    if (hasDesktopSection) {
      // Validate if values under `desktop` are correct
      if (!_validateDesktopYamlValues(desktopData)) return;

      // macOS Splash Handling
      if (hasMacosFolder) {
        final macosData = desktopData[YamlKeys.macosKey];
        if (!_validateDesktopYamlValues(
          macosData,
          keyName: YamlKeys.macosKey,
          validateSpecificKeys: true,
        )) return;
        await _applyMacosSplash(
          macosConfig: macosData as YamlMap,
          commonConfig: desktopData as YamlMap,
        );
      } else {
        log('[Warning] macos/ folder not found. Skipping macOS splash generation.');
      }

      // windows Splash Handling
      if (hasWindowsFolder) {
        final windowsData = desktopData[YamlKeys.windowsKey];
        if (!_validateDesktopYamlValues(
          windowsData,
          keyName: YamlKeys.windowsKey,
          validateSpecificKeys: true,
        )) return;
        await _applyWindowsSplash(
          windowsConfig: windowsData as YamlMap,
          commonConfig: desktopData as YamlMap,
        );
      } else {
        log('[Warning] windows/ folder not found. Skipping Windows splash generation.');
      }
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
Future<void> _applyAndroidSplashImage({
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

/// Validates the image extension if provided.
bool _validateImageExtensionIfProvided(
  dynamic imagePath, {
  required String keyName,
}) {
  if (imagePath == null) return true;

  final path = imagePath.toString().trim();
  final parts = path.split('.');
  if (parts.length < 2 || parts.last.isEmpty) {
    log('[Error] $keyName should point to a png, jpg, or jpeg asset.');
    return false;
  }

  final extension = parts.last.toLowerCase();
  final isSupported = SupportedImageExtensions.values
      .any((supported) => supported.name == extension);

  if (!isSupported) {
    log('[Error] $keyName should point to a png, jpg, or jpeg asset.');
    return false;
  }

  return true;
}

/// Validates the desktop YAML values for both common desktop configuration
/// and platform-specific sections (macOS/Windows).
bool _validateDesktopYamlValues(
  YamlMap map, {
  String keyName = YamlKeys.desktopKey,
  bool validateSpecificKeys = false,
}) {
  if (map[YamlKeys.imageFitKey] != null &&
      !DesktopImageFit.isSupported(map[YamlKeys.imageFitKey])) {
    log('[Error] Invalid value of $keyName.image_fit');
    return false;
  }
  if (map[YamlKeys.imagePositionKey] != null &&
      !DesktopImagePosition.isSupported(map[YamlKeys.imagePositionKey])) {
    log('[Error] Invalid value of $keyName.image_position');
    return false;
  }

  if (map[YamlKeys.brandingImagePositionKey] != null &&
      !DesktopBrandingPosition.isSupported(
          map[YamlKeys.brandingImagePositionKey])) {
    log('[Error] Invalid value of $keyName.branding_image_position');
    return false;
  }

  if (map[YamlKeys.brandingImageSpacingKey] != null &&
      map[YamlKeys.brandingImageSpacingKey] is! int) {
    log('[Error] Invalid value of $keyName.branding_image_spacing');
    return false;
  }
  if (map[YamlKeys.splashWindowWidthKey] != null &&
      map[YamlKeys.splashWindowWidthKey] is! int) {
    log('[Error] Invalid value of $keyName.splash_window_width');
    return false;
  }

  if (map[YamlKeys.splashWindowHeightKey] != null &&
      map[YamlKeys.splashWindowHeightKey] is! int) {
    log('[Error] Invalid value of $keyName.splash_window_height');
    return false;
  }

  if (map[YamlKeys.mainWindowWidthKey] != null &&
      map[YamlKeys.mainWindowWidthKey] is! int) {
    log('[Error] Invalid value of $keyName.main_window_width');
    return false;
  }

  if (map[YamlKeys.mainWindowHeightKey] != null &&
      map[YamlKeys.mainWindowHeightKey] is! int) {
    log('[Error] Invalid value of $keyName.main_window_height');
    return false;
  }

  if (validateSpecificKeys) {
    if (map[YamlKeys.borderlessKey] != null &&
        map[YamlKeys.borderlessKey] is! bool) {
      log('[Error] Invalid value of $keyName.borderless. '
          'Allowed values are `true` and `false`');
      return false;
    }
  }
  return true;
}

/// Applies the splash screen for macOS using details from the YAML file.
Future<void> _applyMacosSplash({
  required YamlMap commonConfig,
  YamlMap? macosConfig,
}) async {
  // Helper function to pick values with macOS-specific config
  // taking precedence over common desktop config
  dynamic pick(String key) => macosConfig?[key] ?? commonConfig[key];
  int pickInt(String key, int fallback) =>
      pick(key) is num ? (pick(key) as num).toInt() : fallback;
  bool pickBool(String key, bool fallback) =>
      pick(key) is bool ? pick(key) as bool : fallback;
  String pickString(String key, String fallback) =>
      pick(key)?.toString() ?? fallback;

  // Extract config values with fallback logic
  final image = pick(YamlKeys.imageKey);
  final color = pick(YamlKeys.colorKey);
  final imageDark = pick(YamlKeys.imageDarkKey);
  final colorDark = pick(YamlKeys.colorDarkKey);
  final brandingImage = pick(YamlKeys.brandingImageKey);
  final brandingImageDark = pick(YamlKeys.brandingImageDarkKey);

  // If no relevant macOS splash configuration is provided,
  // skip the entire process
  if (image == null &&
      brandingImage == null &&
      imageDark == null &&
      brandingImageDark == null &&
      color == null &&
      colorDark == null) {
    log('[Warning] No macOS splash assets provided. Skipping macOS generation.');
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
    imageFit: DesktopImageFit.fromString(pickString(
      YamlKeys.imageFitKey,
      MacosStrings.imageFitDefaultValue,
    )),
    imagePosition: DesktopImagePosition.fromString(pickString(
      YamlKeys.imagePositionKey,
      MacosStrings.imagePositionDefaultValue,
    )),
    brandingPosition: DesktopBrandingPosition.fromString(
      pickString(
        YamlKeys.brandingImagePositionKey,
        MacosStrings.brandingPositionDefaultValue,
      ),
    ),
    brandingSpacing: pickInt(
      YamlKeys.brandingImageSpacingKey,
      MacosStrings.defaultBrandingSpacing,
    ),
    splashWindowWidth: pickInt(
      YamlKeys.splashWindowWidthKey,
      MacosStrings.defaultSplashWindowWidth,
    ),
    splashWindowHeight: pickInt(
      YamlKeys.splashWindowHeightKey,
      MacosStrings.defaultSplashWindowHeight,
    ),
    mainWindowWidth: pickInt(
      YamlKeys.mainWindowWidthKey,
      MacosStrings.defaultMainWindowWidth,
    ),
    mainWindowHeight: pickInt(
      YamlKeys.mainWindowHeightKey,
      MacosStrings.defaultMainWindowHeight,
    ),
    macosConfig: MacosConfigDm(
      borderless: pickBool(
        YamlKeys.borderlessKey,
        MacosStrings.defaultMacosBorderless,
      ),
    ),
  );

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

Future<void> _applyWindowsSplash({
  required YamlMap commonConfig,
  YamlMap? windowsConfig,
}) async {
  // Helper function to pick values with Windows-specific config
  // taking precedence over common desktop config.
  dynamic pick(String key) => windowsConfig?[key] ?? commonConfig[key];
  int pickInt(String key, int fallback) =>
      pick(key) is num ? (pick(key) as num).toInt() : fallback;
  bool pickBool(String key, bool fallback) =>
      pick(key) is bool ? pick(key) as bool : fallback;
  String pickString(String key, String fallback) =>
      pick(key)?.toString() ?? fallback;

  final image = pick(YamlKeys.imageKey);
  final color = pick(YamlKeys.colorKey);
  final imageDark = pick(YamlKeys.imageDarkKey);
  final colorDark = pick(YamlKeys.colorDarkKey);
  final brandingImage = pick(YamlKeys.brandingImageKey);
  final brandingImageDark = pick(YamlKeys.brandingImageDarkKey);

  if (image == null &&
      brandingImage == null &&
      imageDark == null &&
      brandingImageDark == null &&
      color == null &&
      colorDark == null) {
    log('[Warning] No Windows splash assets provided. Skipping Windows generation.');
    return;
  }
  // Todo- Asset generation for Windows splash

  final config = DesktopConfigDm(
    hasSplashImage: image != null,
    hasBrandingImage: brandingImage != null,
    imageFit: DesktopImageFit.fromString(
      pickString(
        YamlKeys.imageFitKey,
        WindowsStrings.imageFitDefaultValue,
      ),
    ),
    imagePosition: DesktopImagePosition.fromString(
      pickString(
        YamlKeys.imagePositionKey,
        WindowsStrings.imagePositionDefaultValue,
      ),
    ),
    brandingPosition: DesktopBrandingPosition.fromString(
      pickString(
        YamlKeys.brandingImagePositionKey,
        WindowsStrings.brandingPositionDefaultValue,
      ),
    ),
    brandingSpacing: pickInt(
      YamlKeys.brandingImageSpacingKey,
      WindowsStrings.defaultBrandingSpacing,
    ),
    splashWindowWidth: pickInt(
      YamlKeys.splashWindowWidthKey,
      WindowsStrings.defaultSplashWindowWidth,
    ),
    splashWindowHeight: pickInt(
      YamlKeys.splashWindowHeightKey,
      WindowsStrings.defaultSplashWindowHeight,
    ),
    mainWindowWidth: pickInt(
      YamlKeys.mainWindowWidthKey,
      WindowsStrings.defaultMainWindowWidth,
    ),
    mainWindowHeight: pickInt(
      YamlKeys.mainWindowHeightKey,
      WindowsStrings.defaultMainWindowHeight,
    ),
    windowsConfig: WindowsConfigDm(
      borderless: pickBool(
        YamlKeys.borderlessKey,
        WindowsStrings.defaultWindowsBorderless,
      ),
    ),
  );

  // Todo- main file modification

  // channel setup for Windows
}
