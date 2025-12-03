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

/// Generate splash images for the iOS
Future<void> generateIosImages({
  String? imageSource,
  String? color,
  String? iosContentMode,
  String? backgroundImage,
  String? iosBackgroundContentMode,
}) async {
  const iosAssetsFolder = CmdStrings.iosAssetsDirectory;

  final directory = Directory(iosAssetsFolder);
  if (!await directory.exists()) {
    log("$iosAssetsFolder path doesn't exists. Creating it...");
    directory.create(recursive: true);
  }

  final List<Image> images = [];

  if (imageSource != null) {
    for (final scale in IosScale.values) {
      final fileName = '${IOSStrings.splashImage}${scale.fileEndWith}.png';
      final imagePath = '$iosAssetsFolder/$fileName';
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }

      final sourceImage = File(imageSource);

      /// Creating a splash image from the provided asset source
      sourceImage.copySync(imagePath);

      log('Generated $fileName.');
      images.add(Image(
        idiom: IOSStrings.iOSContentJsonIdiom,
        filename: fileName,
        scale: scale.scale,
      ));
    }
  }
  updateContentOfStoryboard(
    imagePath: imageSource,
    color: color,
    iosContentMode: iosContentMode,
    backgroundImage: backgroundImage,
    iosBackgroundContentMode: iosBackgroundContentMode,
  );

  await updateContentJson(images);
}

/// Update the default storyboard content with the provided details
/// Image, Color and contentMode
Future<void> updateContentOfStoryboard({
  String? imagePath,
  String? color,
  String? iosContentMode,
  String? backgroundImage,
  String? iosBackgroundContentMode,
}) async {
  final file = File(CmdStrings.storyboardPath);
  final xmlDocument = XmlDocument.parse(file.readAsStringSync());
  final documentData = xmlDocument.getElement(
    IOSStrings.documentElement,
  );

  /// Find the default view in the storyboard
  final view =
      documentData?.descendants.whereType<XmlElement>().firstWhere((element) {
    return element.name.qualified == IOSStrings.viewElement &&
        element.getAttribute(IOSStrings.viewIdAttr) == IOSStrings.defaultViewId;
  });
  if (view == null) {
    log(
      'Default Flutter view with ${IOSStrings.defaultViewId} ID not found.',
    );
    exit(1);
  }

  /// Find (or create) subViews element in the storyboard
  final subViews = _getOrCreateSubViews(view);

  if (color != null) {
    /// Update or add a `color` element for the background color
    final colorElement = view.getElement(IOSStrings.colorElement);
    if (colorElement != null) {
      /// Update existing color with provided color code
      _updateColorAttributes(colorElement, color);
    } else {
      /// Add a new color element with provided color code
      view.children.add(XmlElement(
        XmlName(IOSStrings.colorElement),
        _buildColorAttributes(color),
      ));
    }
  } else {
    final colorElement = view.getElement(IOSStrings.colorElement);
    if (colorElement != null) {
      /// Update existing color to white background
      _updateColorAttributes(colorElement, IOSStrings.defaultColor);
    } else {
      /// Add a new color element with white background color as child in view element
      view.children.add(XmlElement(
        XmlName(IOSStrings.colorElement),
        _buildColorAttributes(IOSStrings.defaultColor),
      ));
    }
  }
  var shouldAddBackgroundImage = false;
  if (backgroundImage != null) {
    final backgroundImageFile = File(backgroundImage);
    final backgroundImageFileExists = await backgroundImageFile.exists();

    if (backgroundImageFileExists) {
      await createBackgroundImage(
        const Image(
          scale: '3x',
          filename: '${IOSStrings.backgroundImageSnakeCase}.png',
          idiom: 'universal',
        ),
        backgroundImageFile,
      );
      shouldAddBackgroundImage = true;
    } else {
      log("$backgroundImage doesn't exists. No background image was set.");
    }
  }

  if (imagePath != null) {
    /// Keep the storyboard idempotent by recreating the managed image nodes.
    _removeManagedImageViews(subViews);

    if (shouldAddBackgroundImage) {
      subViews.children.add(getImageXMLElement(
        elementId: IOSStrings.backgroundImageViewIdValue,
        imageName: IOSStrings.backgroundImage,
        contentMode: iosBackgroundContentMode ?? IOSStrings.contentModeValue,
      ));
    }

    subViews.children.add(getImageXMLElement(
      elementId: IOSStrings.defaultImageViewIdValue,
      imageName: IOSStrings.imageValue,
      contentMode: iosContentMode ?? IOSStrings.contentModeValue,
    ));

    /// Remove all existing constraints elements to avoid duplicates
    view.children.removeWhere(
      (node) =>
          node is XmlElement &&
          node.name.qualified == IOSStrings.constraintsElement,
    );

    /// Add constraints in view element
    view.children.add(
      XmlDocument.parse(shouldAddBackgroundImage
              ? SplashScreenContentString.splashAndBackConstraints
              : SplashScreenContentString.splashImageConstraints)
          .rootElement
          .copy(),
    );
  } else {
    /// Image is not available then
    ///
    /// Remove all existing constraints elements
    view.children.removeWhere(
      (node) =>
          node is XmlElement &&
          node.name.qualified == IOSStrings.constraintsElement,
    );

    final subviewsTag = view.getElement(IOSStrings.subViewsElement);

    /// subview element
    subviewsTag?.remove();
  }

  /// Write the updated storyboard content to the file.
  file.writeAsStringSync(
    '${xmlDocument.toXmlString(pretty: true, indent: '    ')}\n',
  );
}

/// Update color attributes for a color element
void _updateColorAttributes(XmlElement colorElement, String hexColor) {
  /// Set attributes of color element
  colorElement.setAttribute(
    IOSStrings.colorKeyAttr,
    IOSStrings.colorKeyAttrVal,
  );
  colorElement.setAttribute(
    IOSStrings.customColorAttr,
    IOSStrings.customColorAttrVal,
  );
  colorElement.setAttribute(
    IOSStrings.redColorAttr,
    _hexToDecimal(hexColor.substring(1, 3)),
  );
  colorElement.setAttribute(
    IOSStrings.greenColorAttr,
    _hexToDecimal(hexColor.substring(3, 5)),
  );
  colorElement.setAttribute(
    IOSStrings.blueColorAttr,
    _hexToDecimal(hexColor.substring(5, 7)),
  );
  colorElement.setAttribute(
    IOSStrings.colorAlphaAttr,
    IOSStrings.defaultAlphaAttrVal,
  );
}

/// Build attributes for a new color element
List<XmlAttribute> _buildColorAttributes(String hexColor) {
  /// Create attributes of the color element
  return [
    XmlAttribute(
      XmlName(IOSStrings.colorKeyAttr),
      IOSStrings.colorKeyAttrVal,
    ),
    XmlAttribute(
      XmlName(IOSStrings.customColorAttr),
      IOSStrings.customColorAttrVal,
    ),
    XmlAttribute(
      XmlName(IOSStrings.redColorAttr),
      _hexToDecimal(hexColor.substring(1, 3)),
    ),
    XmlAttribute(
      XmlName(IOSStrings.greenColorAttr),
      _hexToDecimal(hexColor.substring(3, 5)),
    ),
    XmlAttribute(
      XmlName(IOSStrings.blueColorAttr),
      _hexToDecimal(hexColor.substring(5, 7)),
    ),
    XmlAttribute(
      XmlName(IOSStrings.colorAlphaAttr),
      IOSStrings.defaultAlphaAttrVal,
    ),
  ];
}

XmlElement _getOrCreateSubViews(XmlElement view) {
  final subViews = view.getElement(IOSStrings.subViewsElement);
  if (subViews != null) {
    return subViews;
  }

  final subview = XmlElement(XmlName(IOSStrings.subViewsElement));
  view.children.add(subview);
  return subview;
}

void _removeManagedImageViews(XmlElement subViews) {
  subViews.children.removeWhere((child) {
    if (child is! XmlElement ||
        child.name.qualified != IOSStrings.imageViewElement) {
      return false;
    }

    final id = child.getAttribute(IOSStrings.defaultImageViewId);
    return id == IOSStrings.defaultImageViewIdValue ||
        id == IOSStrings.backgroundImageViewIdValue;
  });
}

/// Convert hex string (e.g., 'FF') to decimal fraction (0.0 - 1.0)
String _hexToDecimal(String hex) {
  final decimalValue = int.parse(hex, radix: 16) / 255;
  return decimalValue.toStringAsFixed(3);
}

/// Update the content json file with the generated `splash_image` in iOS.
Future<void> updateContentJson(
  List<Image> images,
) async {
  if (images.isEmpty) {
    log('No images were generated. Skipping Updating Contents.json.');
    return;
  }
  const iosAssetsFolder = CmdStrings.iosAssetsDirectory;

  final file = File('$iosAssetsFolder/${IOSStrings.iosContentJson}');
  final jsonString = await file.readAsString();
  final json = jsonDecode(jsonString);
  final iosContentJsonDm = IosContentJsonDm.fromJson(json);

  final updatedIosContentJson = iosContentJsonDm.copyWith(images: images);
  final encodedContentJson = encoder.convert(updatedIosContentJson);
  await file.writeAsString(encodedContentJson);
  log('Updated Contents.json.');
}

Future<void> createBackgroundImage(Image image, File imageFile) async {
  const iosAssetsFolder = CmdStrings.iosBackgroundImageDirectory;
  final file = await File('$iosAssetsFolder/${IOSStrings.iosContentJson}')
      .create(recursive: true);

  final iosContent = IosContentJsonDm(
    images: [image],
    info: const Info(author: 'xcode', version: 1),
  );
  final iosContentJson = iosContent.toJson();
  encoder.convert(iosContentJson);
  file.writeAsString(encoder.convert(iosContentJson));
  final backgroundImage =
      File('$iosAssetsFolder/${IOSStrings.backgroundImageSnakeCase}.png');

  await backgroundImage.writeAsBytes(await imageFile.readAsBytes());
}

XmlElement getImageXMLElement({
  String? elementId,
  String? imageName,
  String? contentMode,
}) {
  return XmlElement(
    /// Adds image element to storyboard.
    XmlName(IOSStrings.imageViewElement),
    [
      XmlAttribute(
        XmlName(IOSStrings.opaque),
        IOSStrings.opaqueValue,
      ),
      XmlAttribute(
        XmlName(IOSStrings.clipsSubviews),
        IOSStrings.clipsSubviewsValue,
      ),
      XmlAttribute(
        XmlName(IOSStrings.multipleTouchEnabled),
        IOSStrings.multipleTouchEnabledValue,
      ),
      XmlAttribute(
        XmlName(IOSStrings.contentMode),
        IosContentMode.fromString(contentMode ?? IOSStrings.contentModeValue)
            .mode,
      ),
      XmlAttribute(
        XmlName(IOSStrings.image),
        imageName ?? IOSStrings.imageValue,
      ),
      XmlAttribute(
        XmlName(IOSStrings.translatesAutoresizingMaskIntoConstraints),
        IOSStrings.translatesAutoresizingMaskIntoConstraintsVal,
      ),
      XmlAttribute(
        XmlName(IOSStrings.defaultImageViewId),
        elementId ?? IOSStrings.defaultImageViewIdValue,
      ),
    ],
    [
      /// Adds rect element for imageView in storyboard.
      XmlElement(
        XmlName(IOSStrings.rectElement),
        [
          XmlAttribute(
            XmlName(IOSStrings.rectElementKeyAttr),
            IOSStrings.rectElementKeyAttrValue,
          ),
          XmlAttribute(
            XmlName(IOSStrings.rectElementXAttr),
            IOSStrings.rectElementXAttrVal,
          ),
          XmlAttribute(
            XmlName(IOSStrings.rectElementYAttr),
            IOSStrings.rectElementYAttrVal,
          ),
          XmlAttribute(
            XmlName(IOSStrings.rectElementWidthAttr),
            IOSStrings.rectElementWidthAttrVal,
          ),
          XmlAttribute(
            XmlName(IOSStrings.rectElementHeightAttr),
            IOSStrings.rectElementHeightAttrVal,
          ),
        ],
      ),
    ],
  );
}

/// Create element for background element.
XmlElement? getBackgroundImageElement(XmlElement? subViews) {
  return subViews?.children.whereType<XmlElement>().firstWhereOrNull(
        (child) =>
            child.name.qualified == IOSStrings.imageViewElement &&
            child.getAttribute(IOSStrings.defaultImageViewId) ==
                IOSStrings.backgroundImageViewIdValue,
      );
}
