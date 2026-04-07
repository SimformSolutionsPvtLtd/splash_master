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

part of 'command_line.dart';

/// Generate splash images for the Android
Future<void> generateAndroidImages({
  String? imageSource,
  String? backgroundImageName,
  String? darkImageSource,
}) async {
  if (imageSource == null) {
    log('No images were provided. Skipping generating Android images');
    return;
  }
  const androidResDir = CmdStrings.androidResDirectory;

  final drawable = getAndroidDrawable();

  /// Create splash images with the provided image in drawable directories
  final drawableFolder = '$androidResDir/$drawable';
  if (!await Directory(drawableFolder).exists()) {
    log("$drawable folder doesn't exists. Creating it...");
    await Directory(drawableFolder).create(recursive: true);
  }

  final imagePath =
      '$drawableFolder/${backgroundImageName ?? AndroidStrings.splashImagePng}';
  final file = File(imagePath);
  if (await file.exists()) {
    await file.delete();
  }
  final sourceImage = File(imageSource);
  if (await sourceImage.exists()) {
    /// Creating a splash image from the provided asset source
    sourceImage.copySync(imagePath);
  } else {
    throw SplashMasterException(message: 'Asset not found. $imagePath');
  }

  if (darkImageSource != null) {
    generateAndroidDarkImage(darkImageSource, drawableFolder);
  }

  log("Splash image added to $drawable");
}

Future<void> generateAndroidDarkImage(String image, String drawable) async {
  final imagePath = '$drawable/${AndroidStrings.splashImageDarkPng}';
  final sourceImage = File(image);
  if (await sourceImage.exists()) {
    /// Creating a splash image from the provided asset source
    await sourceImage.copy(imagePath);
  } else {
    throw SplashMasterException(message: '$image does not exists.');
  }
  log("Dark splash image added.");
}

Future<void> generateImageForAndroid12AndAbove({
  YamlMap? android12AndAbove,
}) async {
  if (android12AndAbove == null) {
    log('Skipping Android 12 configuration as it is not provided.');
    return;
  }

  const androidResDir = CmdStrings.androidResDirectory;
  final drawable = getAndroidDrawable(android12: true);

  final image = android12AndAbove[YamlKeys.imageKey];
  final brandingImage = android12AndAbove[YamlKeys.brandingImageKey];
  final brandingImageDark = android12AndAbove[YamlKeys.brandingImageDarkKey];

  if (image != null) {
    final sourceImage = File(android12AndAbove[YamlKeys.imageKey]);

    /// Checking if provided asset image source exist or not
    if (!await sourceImage.exists()) {
      throw SplashMasterException(message: 'Image path not found');
    }

    final drawableFolder = '$androidResDir/$drawable';
    final directory = Directory(drawableFolder);
    if (!(await directory.exists())) {
      log("$drawable folder doesn't exists. Creating it...");
      await Directory(drawableFolder).create(recursive: true);
    }

    /// Create image in drawable directories for the Android 12+
    final imagePath = '$drawableFolder/${AndroidStrings.splashImage12Png}';

    final file = File(imagePath);
    if (await file.exists()) {
      await file.delete();
    }

    /// Creating a splash image from the provided asset source
    await sourceImage.copy(imagePath);
    log("Splash image added to $drawable");
  }

  /// Copy dark splash icon for Android 12+ dark mode
  final imageDark = android12AndAbove[YamlKeys.imageDarkKey];
  if (imageDark != null) {
    final sourceDarkImage = File(imageDark);

    /// Checking if provided dark asset image source exists or not
    if (!await sourceDarkImage.exists()) {
      throw SplashMasterException(
          message: 'Android 12+ dark image path not found: $imageDark.');
    }

    final drawableFolder = '$androidResDir/$drawable';
    final directory = Directory(drawableFolder);
    if (!(await directory.exists())) {
      log("$drawable folder doesn't exist. Creating it...");
      await Directory(drawableFolder).create(recursive: true);
    }

    final darkImagePath =
        '$drawableFolder/${AndroidStrings.splashImage12DarkPng}';
    final darkFile = File(darkImagePath);
    if (await darkFile.exists()) await darkFile.delete();

    await sourceDarkImage.copy(darkImagePath);
    log("Android 12+ dark splash image added to $drawable");
  }

  if (brandingImage != null) {
    final sourceImage = File(brandingImage);

    /// Checking if provided asset image source exist or not
    if (!await sourceImage.exists()) {
      throw SplashMasterException(message: 'Branding Image path not found');
    }

    final drawableFolder = '$androidResDir/$drawable';
    final directory = Directory(drawableFolder);
    if (!(await directory.exists())) {
      log("$drawable folder doesn't exists. Creating it...");
      await Directory(drawableFolder).create(recursive: true);
    }

    createBrandingImageForAndroid12(
      drawableFolder,
      sourceImage,
    );
  }

  /// Copy dark branding image for Android 12+ dark mode
  if (brandingImageDark != null) {
    final sourceImage = File(brandingImageDark);

    /// Checking if provided asset image source exist or not
    if (!await sourceImage.exists()) {
      throw SplashMasterException(
          message: 'Dark branding image path not found: $brandingImageDark.');
    }

    final drawableFolder = '$androidResDir/$drawable';
    final directory = Directory(drawableFolder);
    if (!(await directory.exists())) {
      log("$drawable folder doesn't exists. Creating it...");
      await Directory(drawableFolder).create(recursive: true);
    }

    final imagePath =
        '$drawableFolder/${AndroidStrings.android12BrandingImageDark}';
    final file = File(imagePath);
    if (await file.exists()) await file.delete();
    await sourceImage.copy(imagePath);
    log("Dark branding image added to $drawable");
  }
}

/// Create branding image for the Android 12+
Future<void> createBrandingImageForAndroid12(
  String drawableFolder,
  File brandingImageSource,
) async {
  final imagePath = '$drawableFolder/${AndroidStrings.android12BrandingImage}';

  final file = File(imagePath);
  if (await file.exists()) {
    await file.delete();
  }

  /// Creating a branding image from the provided asset source
  await brandingImageSource.copy(imagePath);

  log("Branding image added");
}

/// Creates a `colors.xml` file to define background color for the splash.
Future<void> createColors({
  String? color,
  bool isDark = false,
}) async {
  if (color == null) {
    log('No color is provided. Skip setting up color in Android');
    return;
  }

  final androidValuesFolder = isDark
      ? CmdStrings.androidDarkValuesDirectory
      : CmdStrings.androidValuesDirectory;
  final colorsFilePath = '$androidValuesFolder/${AndroidStrings.colorXml}';

  final xmlFile = File(colorsFilePath);
  if (await xmlFile.exists()) {
    final xmlDocument = XmlDocument.parse(xmlFile.readAsStringSync());
    final resourcesElement =
        xmlDocument.findAllElements(AndroidStrings.resourcesElement).first;

    /// Check if `splashBackGroundColor` attribute value is already available
    for (final element in resourcesElement.childElements) {
      if (element.getAttribute(AndroidStrings.nameAttr) ==
          AndroidStrings.nameAttrValue) {
        /// Remove the attribute
        element.remove();
        break;
      }
    }

    /// Add color element as child to resources element
    resourcesElement.children.addAll([
      XmlElement(
        XmlName(AndroidStrings.colorElement),
        [
          XmlAttribute(
            XmlName(AndroidStrings.nameAttr),
            AndroidStrings.nameAttrValue,
          ),
        ],
        [
          XmlText(color),
        ],
      ),
    ]);

    /// Write the updated XML back to the file
    final updatedXmlString = xmlDocument.toXmlString(pretty: true);
    await xmlFile.writeAsString(updatedXmlString);
  } else {
    /// If `colors.xml` file is not there, then create one
    final xml = await xmlFile.create();
    final builder = XmlBuilder();
    builder.processing(AndroidStrings.xml, AndroidStrings.xmlVersion);

    /// Create resources element and its children element color with its attribute
    builder.element(AndroidStrings.resourcesElement, nest: () {
      builder.element(
        AndroidStrings.colorElement,
        attributes: {
          AndroidStrings.nameAttr: AndroidStrings.nameAttrValue,
        },
        nest: color,
      );
    });
    final document = builder.buildDocument();
    await xml.writeAsString(document.toXmlString(pretty: true));
  }
}

/// Updates `values/styles.xml` (pre-Android 12) and writes
/// `values-v31/styles.xml` whenever Android 12+ splash values can be resolved
/// (from nested Android 12+ keys and/or top-level common fallbacks).
///
/// For the Android 12+ background color, the nested `android_12_and_above.color`
/// takes priority; if absent, the top-level [color] is used as a fallback.
Future<void> updateStylesXml({
  YamlMap? android12AndAbove,
  String? color,
  String? imageSource,
}) async {
  const androidValuesFolder = CmdStrings.androidValuesDirectory;

  // For Android 12+, nested color takes priority over the top-level common color.
  final effectiveAndroid12Color =
      android12AndAbove?[YamlKeys.colorKey] as String? ?? color;
  // For Android 12+, nested image takes priority over the top-level common image.
  final effectiveAndroid12Image =
      android12AndAbove?[YamlKeys.imageKey] as String? ?? imageSource;
  // Use the common splash drawable reference when Android 12+ light image is not
  // explicitly provided and we are falling back to the top-level image.
  final useCommonLightImage =
      android12AndAbove?[YamlKeys.imageKey] == null && imageSource != null;

  final hasAndroid12Specific = android12AndAbove != null &&
      (android12AndAbove[YamlKeys.imageKey] != null ||
          android12AndAbove[YamlKeys.brandingImageKey] != null);

  if (effectiveAndroid12Color != null ||
      effectiveAndroid12Image != null ||
      hasAndroid12Specific) {
    const v31 = CmdStrings.androidValuesV31Directory;
    if (!await Directory(v31).exists()) {
      await Directory(v31).create();
    }
    const style = '$v31/${AndroidStrings.stylesXml}';
    if (await File(style).exists()) {
      await File(style).delete();
    }
    final styleFile = File(style);

    await createAndroid12Styles(
      styleFile: styleFile,
      color: effectiveAndroid12Color,
      imageSource: effectiveAndroid12Image,
      brandingImageSource: android12AndAbove?[YamlKeys.brandingImageKey],
      useCommonImage: useCommonLightImage,
    );
  }
  final xml = File('$androidValuesFolder/${AndroidStrings.stylesXml}');
  final xmlExists = await xml.exists();
  if (!xmlExists) {
    log("styles.xml doesn't exists");
    return;
  }
  final xmlDoc = XmlDocument.parse(xml.readAsStringSync());
  xmlDoc.findAllElements(AndroidStrings.itemElement).where((itemElement) {
    return itemElement.getAttribute(AndroidStrings.nameAttr) ==
        AndroidStrings.itemNameAttrValue;
  }).forEach((itemElement) {
    itemElement.setAttribute(
      AndroidStrings.nameAttr,
      AndroidStrings.itemNameAttrValue,
    );
    itemElement.innerText = AndroidStrings.drawableSplashScreen;
  });

  await xml.writeAsString(xmlDoc.toXmlString(pretty: true));
  log('styles.xml updated.');
}

/// Writes the Android 12+ splash screen style to [styleFile] with the provided
/// background color, splash icon, and optional branding image.
Future<void> createAndroid12Styles({
  required File styleFile,
  String? color,
  String? imageSource,
  String? brandingImageSource,
  bool isDarkBranding = false,
  bool isDarkImage = false,
  bool isAndroid12DarkImage = false,
  bool useCommonImage = false,
}) async {
  final xml = await styleFile.create();

  final builder = XmlBuilder();
  builder.processing(AndroidStrings.xml, AndroidStrings.xmlVersion);

  builder.element(
    AndroidStrings.resourcesElement,
    nest: () {
      builder.element(
        AndroidStrings.styleElement,
        attributes: {
          AndroidStrings.nameAttr: AndroidStrings.styleNameAttrVal,
          AndroidStrings.styleParentAttr: AndroidStrings.styleParentAttrVal,
        },
        nest: () {
          if (color != null) {
            builder.element(
              AndroidStrings.itemElement,
              attributes: {
                AndroidStrings.nameAttr: AndroidStrings.windowSplashScreenBG,
              },
              nest: color,
            );
          }
          if (imageSource != null) {
            builder.element(
              AndroidStrings.itemElement,
              attributes: {
                AndroidStrings.nameAttr:
                    AndroidStrings.windowSplashScreenAnimatedIcon,
              },
              nest: isAndroid12DarkImage
                  ? AndroidStrings.drawableSplashImage12Dark
                  : isDarkImage
                      ? AndroidStrings.androidDarkSrcAttrVal
                      : useCommonImage
                          ? AndroidStrings.androidSrcAttrVal
                          : AndroidStrings.drawableSplashImage12,
            );
          }
          if (brandingImageSource != null) {
            builder.element(
              AndroidStrings.itemElement,
              attributes: {
                AndroidStrings.nameAttr:
                    AndroidStrings.windowSplashScreenBrandingImage,
              },
              nest: isDarkBranding
                  ? AndroidStrings.drawableAndroid12BrandingImageDark
                  : AndroidStrings.drawableAndroid12BrandingImage,
            );
          }
        },
      );
    },
  );

  final document = builder.buildDocument();
  await xml.writeAsString(document.toXmlString(pretty: true));
}

/// Creates a new `splash_screen.xml` file to define the splash screen setup.
Future<void> createSplashImageDrawable({
  String? imageSource,
  String? color,
  String? gravity,
  String? backgroundImageSource,
  String? backgroundImageGravity,
}) async {
  const androidDrawableFolder = CmdStrings.androidDrawableDirectory;
  const splashImagePath =
      '$androidDrawableFolder/${AndroidStrings.splashScreenXml}';
  final file = File(splashImagePath);

  final xml = await file.create();
  final builder = XmlBuilder();
  builder.processing(AndroidStrings.xml, AndroidStrings.xmlVersion);

  /// Creating a layer-list element and its attributes
  builder.element(AndroidStrings.layerListElement, nest: () {
    builder.attribute(
      AndroidStrings.xmlnsAndroidAttr,
      AndroidStrings.xmlnsAndroidAttrValue,
    );

    /// Creates item element and attributes for color
    if (color != null) {
      builder.element(
        AndroidStrings.itemElement,
        nest: () {
          builder.attribute(
            AndroidStrings.androidDrawableAttr,
            AndroidStrings.androidDrawableAttrVal,
          );
        },
      );
    }

    /// Creates item element and attributes for background image
    if (backgroundImageSource != null) {
      builder.element(AndroidStrings.itemElement, nest: () {
        builder.element(
          AndroidStrings.bitmapAttrVal,
          nest: () {
            builder.attribute(
              AndroidStrings.androidGravityAttr,
              backgroundImageGravity ??
                  AndroidStrings.defaultAndroidGravityAttrVal,
            );
            builder.attribute(
              AndroidStrings.androidSrcAttr,
              AndroidStrings.androidBackgroundSrcAttrVal,
            );
            builder.attribute(
              AndroidStrings.androidTileModeAttr,
              AndroidStrings.androidTileModeAttrVal,
            );
          },
        );
      });
    }

    /// Creates item element and attributes for image
    if (imageSource != null) {
      builder.element(AndroidStrings.itemElement, nest: () {
        builder.element(AndroidStrings.bitmapAttrVal, nest: () {
          builder.attribute(
            AndroidStrings.androidGravityAttr,
            gravity ?? AndroidStrings.defaultAndroidGravityAttrVal,
          );
          builder.attribute(
            AndroidStrings.androidSrcAttr,
            AndroidStrings.androidSrcAttrVal,
          );
          builder.attribute(
            AndroidStrings.androidTileModeAttr,
            AndroidStrings.androidTileModeAttrVal,
          );
        });
      });
    }
  });

  final document = builder.buildDocument();
  await xml.writeAsString(document.toXmlString(pretty: true));
  log("Created splash_screen.xml.");
}

Future<void> createDarkSplashImageDrawable({
  String? darkImage,
  String? color,
  String? gravity,
  String? darkBackgroundImageSource,
  String? backgroundImageGravity,
}) async {
  log(darkImage ?? '');
  if (darkImage == null && darkBackgroundImageSource == null && color == null) {
    return;
  }

  // Verify dark image exists if provided
  if (darkImage != null && !await File(darkImage).exists()) {
    throw SplashMasterException(
        message: 'Dark splash image not found at $darkImage.');
  }

  const androidDrawableFolder = CmdStrings.androidDrawableDarkDirectory;
  const splashImagePath =
      '$androidDrawableFolder/${AndroidStrings.splashScreenDarkXml}';
  final file = File(splashImagePath);

  final xml = await file.create(recursive: true);

  final builder = XmlBuilder();

  builder.processing(AndroidStrings.xml, AndroidStrings.xmlVersion);

  /// Creating a layer-list element and its attributes
  builder.element(AndroidStrings.layerListElement, nest: () {
    builder.attribute(
      AndroidStrings.xmlnsAndroidAttr,
      AndroidStrings.xmlnsAndroidAttrValue,
    );

    /// Creates item element and attributes for color
    if (color != null) {
      builder.element(
        AndroidStrings.itemElement,
        nest: () {
          builder.attribute(
            AndroidStrings.androidDrawableAttr,
            AndroidStrings.androidDrawableAttrVal,
          );
        },
      );
    }

    /// Creates item element and attributes for dark background image
    if (darkBackgroundImageSource != null) {
      builder.element(AndroidStrings.itemElement, nest: () {
        builder.element(AndroidStrings.bitmapAttrVal, nest: () {
          builder.attribute(
            AndroidStrings.androidGravityAttr,
            backgroundImageGravity ??
                AndroidStrings.defaultAndroidGravityAttrVal,
          );
          builder.attribute(
            AndroidStrings.androidSrcAttr,
            AndroidStrings.androidDarkBackgroundSrcAttrVal,
          );
          builder.attribute(
            AndroidStrings.androidTileModeAttr,
            AndroidStrings.androidTileModeAttrVal,
          );
        });
      });
    }

    /// Creates item element and attributes for image (only if dark image exists)
    if (darkImage != null) {
      builder.element(AndroidStrings.itemElement, nest: () {
        builder.element(AndroidStrings.bitmapAttrVal, nest: () {
          builder.attribute(
            AndroidStrings.androidGravityAttr,
            gravity ?? AndroidStrings.defaultAndroidGravityAttrVal,
          );
          builder.attribute(
            AndroidStrings.androidSrcAttr,
            AndroidStrings.androidDarkSrcAttrVal,
          );
          builder.attribute(
            AndroidStrings.androidTileModeAttr,
            AndroidStrings.androidTileModeAttrVal,
          );
        });
      });
    }
  });

  final document = builder.buildDocument();
  await xml.writeAsString(document.toXmlString(pretty: true));
}

/// Generates dark mode splash screen styles for pre-Android 12 (`values-night/styles.xml`)
/// and Android 12+ (`values-night-v31/styles.xml`).
Future<void> updateDarkStylesXml({
  YamlMap? android12AndAbove,
  String? color,
  String? darkImage,
  String? darkBrandingImage,
  String? darkBackgroundImageSource,
}) async {
  const androidValuesFolder = CmdStrings.androidDarkValuesDirectory;

  // Resolve the effective Android 12+ dark values using the following priority:
  // 1. android_12_and_above.image_dark / android_12_and_above.color_dark (Android 12+-specific)
  // 2. Top-level image_dark / color_dark (common dark keys)
  // 3. android_12_and_above.image / android_12_and_above.color (Android 12+ light fallback)
  final android12NativeDarkImage =
      android12AndAbove?[YamlKeys.imageDarkKey] as String?;
  final android12NativeDarkColor =
      android12AndAbove?[YamlKeys.colorDarkKey] as String?;
  final resolvedDarkColor = android12NativeDarkColor ??
      color ??
      android12AndAbove?[YamlKeys.colorKey] as String?;
  final resolvedDarkImage = android12NativeDarkImage ??
      darkImage ??
      android12AndAbove?[YamlKeys.imageKey] as String?;
  final resolvedBranding = darkBrandingImage ??
      android12AndAbove?[YamlKeys.brandingImageKey] as String?;

  if (resolvedDarkColor != null ||
      resolvedDarkImage != null ||
      resolvedBranding != null) {
    // Use values-night-v31 for dark mode Android 12+ styles (separate from light values-v31)
    const v31 = CmdStrings.androidDarkValuesV31Directory;
    if (!await Directory(v31).exists()) {
      await Directory(v31).create();
    }
    const style = '$v31/${AndroidStrings.stylesXml}';
    if (await File(style).exists()) {
      await File(style).delete();
    }
    final styleFile = File(style);

    await createAndroid12Styles(
      styleFile: styleFile,
      color: resolvedDarkColor,
      imageSource: resolvedDarkImage,
      brandingImageSource: resolvedBranding,
      isDarkBranding: darkBrandingImage != null,
      isDarkImage: darkImage != null || android12NativeDarkImage != null,
      isAndroid12DarkImage: android12NativeDarkImage != null,
    );
  }
  // Pre-Android 12 dark styles live in values-night/styles.xml, separate from values-night-v31.
  if (darkImage == null && darkBackgroundImageSource == null && color == null) {
    log(
      'Skipping values-night/styles.xml update as no pre-Android 12 dark image, dark background image, or dark color was provided.',
    );
    return;
  }

  final xml = File('$androidValuesFolder/${AndroidStrings.stylesXml}');
  final xmlExists = await xml.exists();
  if (!xmlExists) {
    log("values-night/styles.xml updated.");
    return;
  }
  final xmlDoc = XmlDocument.parse(xml.readAsStringSync());
  xmlDoc.findAllElements(AndroidStrings.itemElement).where((itemElement) {
    return itemElement.getAttribute(AndroidStrings.nameAttr) ==
        AndroidStrings.itemNameAttrValue;
  }).forEach((itemElement) {
    itemElement.setAttribute(
      AndroidStrings.nameAttr,
      AndroidStrings.itemNameAttrValue,
    );
    itemElement.innerText = AndroidStrings.androidDarkDrawable;
  });

  await xml.writeAsString(xmlDoc.toXmlString(pretty: true));
  log('values-night/styles.xml updated.');
}
