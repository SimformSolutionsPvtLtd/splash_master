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

  /// Find the default subViews element in the storyboard
  final subViews = view.getElement(IOSStrings.subViewsElement);
  if (subViews == null) {
    final subview = _createImageSubView(backgroundImage: backgroundImage);

    /// Add subViews element as child in view element
    view.children.add(subview);
  }

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
  XmlNode? backgroundImageElement;
  if (backgroundImage != null) {
    final backgroundImageFile = File(backgroundImage);
    final backgroundImageFileExists = await backgroundImageFile.exists();

    if (backgroundImageFileExists) {
      await createBackgroundImage(
        Image(
          scale: '3x',
          filename: backgroundImageFile.name,
          idiom: 'universal',
        ),
        backgroundImageFile,
      );
      backgroundImageElement = getBackgroundImageElement(subViews);
    } else {
      log("$backgroundImage doesn't exists. No background image was set.");
    }
  }
  if (imagePath != null) {
    /// Find the imageView element in subViews element
    final imageView = subViews?.children.whereType<XmlElement?>().firstWhere(
      (element) =>
          element?.name.qualified == IOSStrings.imageViewElement &&
          element?.getAttribute(IOSStrings.image) == IOSStrings.imageValue,
      orElse: () {
        log(
          'Unable to find default imageView with the LaunchImage',
        );
        exit(1);
      },
    );

    /// Update the fill property
    imageView?.setAttribute(
      IOSStrings.contentMode,
      iosContentMode ?? IOSStrings.contentModeValue,
    );

    /// Remove existing or old constraints
    view.children.remove(view.getElement(IOSStrings.constraintsElement));

    /// Add constraints in view element
    view.children.add(
      XmlDocument.parse(backgroundImageElement == null
              ? SplashScreenContentString
                  .splashAndBackConstraints
              : SplashScreenContentString.splashImageConstraints)
          .rootElement
          .copy(),
    );

    final imageViewCopy = imageView?.copy();
    imageView?.remove();
    if (backgroundImageElement == null) {
      backgroundImageElement = getImageXMLElement(
        elementId: IOSStrings.backgroundImageViewIdValue,
        imageName: IOSStrings.backgroundImage,
        contentMode: iosBackgroundContentMode ?? IOSStrings.contentModeValue,
      );
      subViews?.children.add(backgroundImageElement);
    } else {
      log("BackgroundImage already exists. Background image wasn't set.");
    }
    if (imageViewCopy != null) subViews?.children.add(imageViewCopy);
  } else {
    /// Image is not available then
    ///
    /// remove constraints
    view.children.remove(view.getElement(IOSStrings.constraintsElement));

    final subviewsTag =
        documentData?.findAllElements(IOSStrings.subViewsElement).firstOrNull;

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

/// Create the subviews element.
/// Create two sub element inside the `subviews` element.
/// `imageView` and `rect`.
XmlElement _createImageSubView({String? backgroundImage}) {
  final element = XmlElement(XmlName(IOSStrings.subViewsElement), [], [
    if (backgroundImage != null) ...{
      getImageXMLElement(
        elementId: IOSStrings.backgroundImageViewIdValue,
        imageName: IOSStrings.backgroundImage,
      ),
    },
    getImageXMLElement(),
  ]);
  return element;
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
        contentMode ?? IOSStrings.contentModeValue,
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
XmlNode? getBackgroundImageElement(XmlElement? subViews) {
  final backgroundImageElement = subViews?.children.firstWhereOrNull(
    (child) {
      final attribute = child.attributes.firstWhereOrNull(
        (attribute) {
          return attribute.value == IOSStrings.backgroundImageViewIdValue;
        },
      );
      return attribute != null;
    },
  );
  return backgroundImageElement;
}
