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

Future<void> _ensureDirectoryExists(String path, {String? logMessage}) async {
  final directory = Directory(path);
  if (!await directory.exists()) {
    if (logMessage != null) {
      log(logMessage);
    }
    await directory.create(recursive: true);
  }
}

Future<void> _replaceFileFromSource({
  required File source,
  required String destinationPath,
}) async {
  final destination = File(destinationPath);
  if (await destination.exists()) {
    await destination.delete();
  }
  await source.copy(destinationPath);
}

/// Generate splash images for the Android
Future<void> generateAndroidImages({
  String? imageSource,
  String? backgroundImageName,
  String? darkImageSource,
}) async {
  if (imageSource == null && darkImageSource == null) {
    log('No images were provided. Skipping generating Android images');
    return;
  }
  const androidResDir = CmdStrings.androidResDirectory;

  final drawable = getAndroidDrawable();

  /// Create splash images with the provided image in drawable directories
  final drawableFolder = '$androidResDir/$drawable';
  await _ensureDirectoryExists(
    drawableFolder,
    logMessage: "$drawable folder doesn't exists. Creating it...",
  );

  if (imageSource != null) {
    final imagePath =
        '$drawableFolder/${backgroundImageName ?? AndroidStrings.splashImagePng}';
    final sourceImage = File(imageSource);
    if (await sourceImage.exists()) {
      /// Creating a splash image from the provided asset source
      await _replaceFileFromSource(
        source: sourceImage,
        destinationPath: imagePath,
      );
    } else {
      throw SplashMasterException(message: 'Asset not found. $imagePath');
    }
  }

  if (darkImageSource != null) {
    await generateAndroidDarkImage(darkImageSource, drawableFolder);
  }

  log("Splash image added to $drawable");
}

Future<void> generateAndroidDarkImage(String image, String drawable) async {
  final imagePath = '$drawable/${AndroidStrings.splashImageDarkPng}';
  final sourceImage = File(image);
  if (await sourceImage.exists()) {
    /// Creating a splash image from the provided asset source
    await _replaceFileFromSource(
      source: sourceImage,
      destinationPath: imagePath,
    );
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

  final image = android12AndAbove[YamlKeys.imageKey] as String?;
  final brandingImage = android12AndAbove[YamlKeys.brandingImageKey];
  final brandingImageDark = android12AndAbove[YamlKeys.brandingImageDarkKey];

  if (image != null) {
    final sourceImage = File(image);

    /// Checking if provided asset image source exist or not
    if (!await sourceImage.exists()) {
      throw SplashMasterException(message: 'Image path not found');
    }

    final drawableFolder = '$androidResDir/$drawable';
    await _ensureDirectoryExists(
      drawableFolder,
      logMessage: "$drawable folder doesn't exists. Creating it...",
    );

    /// Create image in drawable directories for the Android 12+
    final imagePath = '$drawableFolder/${AndroidStrings.splashImage12Png}';

    /// Creating a splash image from the provided asset source
    await _replaceFileFromSource(
      source: sourceImage,
      destinationPath: imagePath,
    );
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
    await _ensureDirectoryExists(
      drawableFolder,
      logMessage: "$drawable folder doesn't exist. Creating it...",
    );

    final darkImagePath =
        '$drawableFolder/${AndroidStrings.splashImage12DarkPng}';
    await _replaceFileFromSource(
      source: sourceDarkImage,
      destinationPath: darkImagePath,
    );
    log("Android 12+ dark splash image added to $drawable");
  }

  if (brandingImage != null) {
    final sourceImage = File(brandingImage);

    /// Checking if provided asset image source exist or not
    if (!await sourceImage.exists()) {
      throw SplashMasterException(message: 'Branding Image path not found');
    }

    final drawableFolder = '$androidResDir/$drawable';
    await _ensureDirectoryExists(
      drawableFolder,
      logMessage: "$drawable folder doesn't exists. Creating it...",
    );

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
    await _ensureDirectoryExists(
      drawableFolder,
      logMessage: "$drawable folder doesn't exists. Creating it...",
    );

    final imagePath =
        '$drawableFolder/${AndroidStrings.android12BrandingImageDark}';
    await _replaceFileFromSource(
      source: sourceImage,
      destinationPath: imagePath,
    );
    log("Dark branding image added to $drawable");
  }
}

/// Create branding image for the Android 12+
Future<void> createBrandingImageForAndroid12(
  String drawableFolder,
  File brandingImageSource,
) async {
  final imagePath = '$drawableFolder/${AndroidStrings.android12BrandingImage}';

  /// Creating a branding image from the provided asset source
  await _replaceFileFromSource(
    source: brandingImageSource,
    destinationPath: imagePath,
  );

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

/// Updates `values/styles.xml` for pre-Android 12 splash style references.
///
/// If `android_12_and_above` is present, this recreates
/// `values-v31/styles.xml` using only values from that block.
Future<void> updateStylesXml({
  YamlMap? android12AndAbove,
}) async {
  const androidValuesFolder = CmdStrings.androidValuesDirectory;

  // Only use values explicitly set under android_12_and_above.
  // Top-level color and image are not inherited by Android 12+.
  if (android12AndAbove != null) {
    const v31 = CmdStrings.androidValuesV31Directory;
    await _ensureDirectoryExists(v31);
    const style = '$v31/${AndroidStrings.stylesXml}';
    if (await File(style).exists()) {
      await File(style).delete();
    }
    final styleFile = File(style);

    await createAndroid12Styles(
      styleFile: styleFile,
      color: android12AndAbove[YamlKeys.colorKey] as String?,
      imageSource: android12AndAbove[YamlKeys.imageKey] as String?,
      brandingImageSource: android12AndAbove[YamlKeys.brandingImageKey],
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
}) async {
  final xml = await styleFile.create();

  final builder = XmlBuilder();
  builder.processing(AndroidStrings.xml, AndroidStrings.xmlVersion);

  /// Creating a resources element
  builder.element(
    AndroidStrings.resourcesElement,
    nest: () {
      /// Creating a style element as child of resources element
      builder.element(
        AndroidStrings.styleElement,
        attributes: {
          AndroidStrings.nameAttr: AndroidStrings.styleNameAttrVal,
          AndroidStrings.styleParentAttr: AndroidStrings.styleParentAttrVal,
        },
        nest: () {
          /// Creating a item element for color
          if (color != null) {
            builder.element(
              AndroidStrings.itemElement,
              attributes: {
                AndroidStrings.nameAttr: AndroidStrings.windowSplashScreenBG,
              },
              nest: color,
            );
          }

          /// Creating a item element for image
          if (imageSource != null) {
            builder.element(
              AndroidStrings.itemElement,
              attributes: {
                AndroidStrings.nameAttr:
                    AndroidStrings.windowSplashScreenAnimatedIcon,
              },
              nest: isDarkImage
                  ? AndroidStrings.drawableSplashImage12Dark
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

/// Generates dark mode splash screen XML styles for both pre-Android 12 and Android 12+ devices.
///
/// This function manages two separate dark mode configurations to support platform-specific
/// styling requirements. It creates `values-night/styles.xml` for pre-Android 12 devices and
/// `values-night-v31/styles.xml` for Android 12+ devices with their respective styling.
Future<void> updateDarkStylesXml({
  YamlMap? android12AndAbove,
  String? darkColor,
  String? darkImage,
  String? darkBrandingImage,
  String? darkBackgroundImageSource,
}) async {
  // Pre-Android 12 dark styles live in values-night/styles.xml, separate from values-night-v31.
  final hasPreAndroid12DarkConfig = darkImage != null ||
      darkBackgroundImageSource != null ||
      darkColor != null;

  if (!hasPreAndroid12DarkConfig && android12AndAbove == null) {
    log('Skipping dark styles update: no dark configuration provided.');
    return;
  }

  // Handle Android 12+ dark styles
  if (android12AndAbove != null) {
    final android12NativeDarkImage =
        android12AndAbove[YamlKeys.imageDarkKey] as String?;

    const v31 = CmdStrings.androidDarkValuesV31Directory;
    await Directory(v31).create(recursive: true);

    const styleV31Path = '$v31/${AndroidStrings.stylesXml}';
    final styleFileV31 = File(styleV31Path);
    if (await styleFileV31.exists()) {
      await styleFileV31.delete();
    }

    await createAndroid12Styles(
      styleFile: styleFileV31,
      color: android12AndAbove[YamlKeys.colorDarkKey] as String?,
      imageSource: android12NativeDarkImage ??
          android12AndAbove[YamlKeys.imageKey] as String?,
      brandingImageSource: darkBrandingImage ??
          android12AndAbove[YamlKeys.brandingImageKey] as String?,
      isDarkBranding: darkBrandingImage != null,
      isDarkImage: android12NativeDarkImage != null,
    );
  }

  // Handle pre-Android 12 dark styles
  if (!hasPreAndroid12DarkConfig) {
    return;
  }

  const androidValuesFolder = CmdStrings.androidDarkValuesDirectory;
  const xmlPath = '$androidValuesFolder/${AndroidStrings.stylesXml}';
  final xmlFile = File(xmlPath);

  if (!await xmlFile.exists()) {
    log('Pre-Android 12 values-night/styles.xml not found. Skipping update.');
    return;
  }

  try {
    final xmlDoc = XmlDocument.parse(xmlFile.readAsStringSync());
    for (final itemElement
        in xmlDoc.findAllElements(AndroidStrings.itemElement)) {
      if (itemElement.getAttribute(AndroidStrings.nameAttr) ==
          AndroidStrings.itemNameAttrValue) {
        itemElement.innerText = AndroidStrings.androidDarkDrawable;
        break;
      }
    }
    await xmlFile.writeAsString(xmlDoc.toXmlString(pretty: true));
    log('Pre-Android 12 values-night/styles.xml updated.');
  } catch (e) {
    log('Error updating values-night/styles.xml: $e');
  }
}
