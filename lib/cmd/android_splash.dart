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
  String? color,
}) async {
  if (imageSource == null) {
    log('No images were provided. Skipping generating Android images');
    return;
  }
  const androidResDir = CmdStrings.androidResDirectory;

  /// Create splash images with the provided image in mipmap directories
  for (final mipmap in AndroidMipMaps.values) {
    final mipmapFolder = '$androidResDir/${mipmap.folder}';
    final directory = Directory(mipmapFolder);
    if (!(await directory.exists())) {
      log("${mipmap.folder} folder doesn't exists. Creating it...");
      await Directory(mipmapFolder).create(recursive: true);
    }

    final imagePath = '$mipmapFolder/${AndroidStrings.splashImagePng}';
    final file = File(imagePath);
    if (await file.exists()) {
      await file.delete();
    }
    final sourceImage = File(imageSource);
    if (await sourceImage.exists()) {
      /// Creating a splash image from the provided asset source
      sourceImage.copySync(imagePath);
    } else {
      throw SplashMasterException(message: 'Image path not found');
    }

    log("Splash image added to ${mipmap.folder}");
  }
}

Future<void> generateImageForAndroid12AndAbove({
  YamlMap? android12AndAbove,
}) async {
  if (android12AndAbove == null) {
    log('Skipping Android 12 configuration as it is not provided.');
    return;
  }
  const androidResDir = CmdStrings.androidResDirectory;

  /// Create splash images with the provided image in mipmap directories
  for (final mipmap in AndroidMipMaps.values) {
    final mipmapFolder = '$androidResDir/${mipmap.folder}';
    final directory = Directory(mipmapFolder);
    if (!(await directory.exists())) {
      log("${mipmap.folder} folder doesn't exists. Creating it...");
      await Directory(mipmapFolder).create(recursive: true);
    }

    /// Create image in mipmap directories for the Android 12+
    if (android12AndAbove[YamlKeys.imageKey] != null) {
      final imagePath = '$mipmapFolder/${AndroidStrings.splashImage12Png}';
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }
      final sourceImage = File(android12AndAbove[YamlKeys.imageKey]);
      if (await sourceImage.exists()) {
        /// Creating a splash image from the provided asset source
        sourceImage.copySync(imagePath);
      } else {
        throw SplashMasterException(message: 'Image path not found');
      }

      log("Splash image added to ${mipmap.folder}");
    }
  }
}

/// Creates a `colors.xml` file to define background color for the splash.
Future<void> createColors({
  String? color,
}) async {
  if (color == null) {
    log('No color is provided. Skip setting up color in Android');
    return;
  }

  const androidValuesFolder = CmdStrings.androidValuesDirectory;
  const colorsFilePath = '$androidValuesFolder/${AndroidStrings.colorXml}';

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

/// Updates the `styles.xml` file for the splash screen setup.
Future<void> updateStylesXml({
  YamlMap? android12AndAbove,
  String? color,
}) async {
  const androidValuesFolder = CmdStrings.androidValuesDirectory;

  if (android12AndAbove != null &&
      (android12AndAbove[YamlKeys.colorKey] != null ||
          android12AndAbove[YamlKeys.imageKey] != null)) {
    const v31 = CmdStrings.androidValuesV31Directory;
    if (!await Directory(v31).exists()) {
      Directory(v31).create();
    }
    const style = '$v31/${AndroidStrings.stylesXml}';
    if (await File(style).exists()) {
      File(style).delete();
    }
    final styleFile = File(style);

    createAndroid12Styles(
      styleFile: styleFile,
      color: android12AndAbove[YamlKeys.colorKey],
      imageSource: android12AndAbove[YamlKeys.imageKey],
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

/// Updates the `styles.xml` file for the splash screen setup for Android 12+.
Future<void> createAndroid12Styles({
  required File styleFile,
  String? color,
  String? imageSource,
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
              nest: AndroidStrings.mipmapSplashImage12,
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
