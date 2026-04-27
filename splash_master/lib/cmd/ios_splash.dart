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
  String? darkImageSource,
  String? darkColor,
  String? darkBackgroundImage,
}) async {
  if (darkImageSource != null && imageSource == null) {
    throw SplashMasterException(
      message:
          'For iOS, image is required when image_dark is provided. Add image to provide the base Any appearance asset.',
    );
  }

  if (darkBackgroundImage != null && backgroundImage == null) {
    throw SplashMasterException(
      message:
          'For iOS, background_image is required when background_image_dark is provided. Add background_image to provide the base Any appearance asset.',
    );
  }

  const iosAssetsFolder = CmdStrings.iosAssetsDirectory;

  final directory = Directory(iosAssetsFolder);
  if (!await directory.exists()) {
    log("$iosAssetsFolder path doesn't exists. Creating it...");
    await directory.create(recursive: true);
  }

  await _removeLegacyLaunchImageFiles(iosAssetsFolder);
  await _cleanupGeneratedLaunchImageFiles(
    iosAssetsFolder,
    keepLightAssets: imageSource != null,
    keepDarkAssets: darkImageSource != null,
  );

  final List<Image> images = [];

  if (imageSource != null) {
    final sourceImage = File(imageSource);
    if (!await sourceImage.exists()) {
      throw SplashMasterException(message: 'Asset not found. $imageSource');
    }

    for (final scale in IosScale.values) {
      final fileName = '${IOSStrings.splashImage}${scale.fileEndWith}.png';
      final imagePath = '$iosAssetsFolder/$fileName';

      /// Creating a splash image from the provided asset source
      await _replaceFileFromSource(
        source: sourceImage,
        destinationPath: imagePath,
      );

      log('Generated $fileName.');
      images.add(Image(
        idiom: IOSStrings.iOSContentJsonIdiom,
        filename: fileName,
        scale: scale.scale,
      ));
    }
  }

  if (darkImageSource != null) {
    final darkSourceImage = File(darkImageSource);
    if (!await darkSourceImage.exists()) {
      throw SplashMasterException(message: 'Asset not found. $darkImageSource');
    }

    for (final scale in IosScale.values) {
      final fileName = '${IOSStrings.splashImageDark}${scale.fileEndWith}.png';
      final imagePath = '$iosAssetsFolder/$fileName';

      await _replaceFileFromSource(
        source: darkSourceImage,
        destinationPath: imagePath,
      );

      log('Generated $fileName.');
      images.add(Image(
        idiom: IOSStrings.iOSContentJsonIdiom,
        filename: fileName,
        scale: scale.scale,
        appearances: [
          {
            IOSStrings.appearanceKey: IOSStrings.appearanceLuminosity,
            IOSStrings.appearanceValueKey: IOSStrings.appearanceDark,
          }
        ],
      ));
    }
  }

  await updateContentOfStoryboard(
    imagePath: imageSource,
    color: color,
    iosContentMode: iosContentMode,
    backgroundImage: backgroundImage,
    iosBackgroundContentMode: iosBackgroundContentMode,
    darkColor: darkColor,
    darkBackgroundImage: darkBackgroundImage,
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
  String? darkColor,
  String? darkBackgroundImage,
}) async {
  final file = File(CmdStrings.storyboardPath);
  final xmlDocument = XmlDocument.parse(file.readAsStringSync());
  final documentData = xmlDocument.getElement(
    IOSStrings.documentElement,
  );

  /// Find the default view in the storyboard
  final view = documentData?.descendants
      .whereType<XmlElement>()
      .firstWhereOrNull((element) {
    return element.name.qualified == IOSStrings.viewElement &&
        element.getAttribute(IOSStrings.viewIdAttr) == IOSStrings.defaultViewId;
  });
  if (view == null) {
    throw SplashMasterException(
      message:
          'Default Flutter view with ${IOSStrings.defaultViewId} ID not found.',
    );
  }

  final resolvedColor = color ?? IOSStrings.defaultColor;

  // Dark mode requires an Asset Catalog color set (.colorset);
  // an inline storyboard color cannot express appearance variants.
  // resolvedColor serves as the light variant.
  if (darkColor != null) {
    await createLaunchBackgroundColorSet(
      lightColor: resolvedColor,
      darkColor: darkColor,
    );
    _setNamedBackgroundColor(view);
  } else if (color != null) {
    await _removeLaunchBackgroundColorSet();

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
    await _removeLaunchBackgroundColorSet();
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
      // Per Apple's Asset Catalog spec, a Dark appearance variant requires a base
      // "Any" appearance asset. Both are resolved here together before writing the image set.
      File? darkBackgroundImageFile;
      if (darkBackgroundImage != null) {
        final file = File(darkBackgroundImage);
        if (await file.exists()) {
          darkBackgroundImageFile = file;
        } else {
          throw SplashMasterException(
            message: 'Asset not found. $darkBackgroundImage',
          );
        }
      }
      await createBackgroundImage(
        const Image(
          scale: '3x',
          filename: '${IOSStrings.backgroundImageSnakeCase}.png',
          idiom: 'universal',
        ),
        backgroundImageFile,
        darkImageFile: darkBackgroundImageFile,
      );
      shouldAddBackgroundImage = true;
    } else {
      throw SplashMasterException(message: 'Asset not found. $backgroundImage');
    }
  } else {
    await _removeBackgroundImageSet();
  }

  final shouldRenderImageViews = imagePath != null || shouldAddBackgroundImage;

  if (shouldRenderImageViews) {
    /// Find (or create) subViews element in the storyboard only when needed.
    final subViews = _getOrCreateSubViews(view);

    /// Keep the storyboard idempotent by recreating the managed image nodes.
    _removeManagedImageViews(subViews);

    if (shouldAddBackgroundImage) {
      subViews.children.add(getImageXMLElement(
        elementId: IOSStrings.backgroundImageViewIdValue,
        imageName: IOSStrings.backgroundImage,
        contentMode: iosBackgroundContentMode ?? IOSStrings.contentModeValue,
      ));
    }

    if (imagePath != null) {
      subViews.children.add(getImageXMLElement(
        elementId: IOSStrings.defaultImageViewIdValue,
        imageName: IOSStrings.imageValue,
        contentMode: iosContentMode ?? IOSStrings.contentModeValue,
      ));
    }

    /// Remove all existing constraints elements to avoid duplicates
    view.children.removeWhere(
      (node) =>
          node is XmlElement &&
          node.name.qualified == IOSStrings.constraintsElement,
    );

    /// Add constraints in view element based on requested content modes.
    final constraintsElement = _buildConstraintsElement(
      includeSplashImage: imagePath != null,
      splashContentMode: iosContentMode ?? IOSStrings.contentModeValue,
      includeBackgroundImage: shouldAddBackgroundImage,
      backgroundContentMode:
          iosBackgroundContentMode ?? IOSStrings.contentModeValue,
    );
    if (constraintsElement != null) {
      view.children.add(constraintsElement);
    }
  } else {
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

  _syncStoryboardImageResources(
    documentData,
    includeLaunchImage: imagePath != null,
    includeBackgroundImage: shouldAddBackgroundImage,
  );

  /// Write the updated storyboard content to the file.
  file.writeAsStringSync(
    '${xmlDocument.toXmlString(pretty: true, indent: '    ')}\n',
  );
}

/// Keep the storyboard image resource definitions in sync with the current
/// image usage in the storyboard.
void _syncStoryboardImageResources(
  XmlElement? documentData, {
  required bool includeLaunchImage,
  required bool includeBackgroundImage,
}) {
  if (documentData == null) {
    return;
  }

  final resources = _getOrCreateResourcesElement(documentData);

  resources.children.removeWhere((child) {
    if (child is! XmlElement ||
        child.name.qualified != IOSStrings.imageResourceElement) {
      return false;
    }

    final imageName = child.getAttribute(IOSStrings.nameAttr);
    return imageName == IOSStrings.imageValue ||
        imageName == IOSStrings.backgroundImage;
  });

  if (includeLaunchImage) {
    resources.children.add(
      _createStoryboardImageResource(
        IOSStrings.imageValue,
      ),
    );
  }

  if (includeBackgroundImage) {
    resources.children.add(
      _createStoryboardImageResource(
        IOSStrings.backgroundImage,
      ),
    );
  }

  final hasImageResources = resources.children.whereType<XmlElement>().any(
        (child) => child.name.qualified == IOSStrings.imageResourceElement,
      );

  if (!hasImageResources) {
    resources.remove();
  }
}

/// Get the `resources` element from the storyboard XML, or create
/// it if it doesn't exist.
XmlElement _getOrCreateResourcesElement(XmlElement documentData) {
  final resources = documentData.getElement(IOSStrings.resourcesElement);
  if (resources != null) {
    return resources;
  }

  final resourcesElement = XmlElement(XmlName(IOSStrings.resourcesElement));
  documentData.children.add(resourcesElement);
  return resourcesElement;
}

/// Create a storyboard image resource element with the given image name.
XmlElement _createStoryboardImageResource(String imageName) {
  return XmlElement(
    XmlName(IOSStrings.imageResourceElement),
    [
      XmlAttribute(XmlName(IOSStrings.nameAttr), imageName),
      XmlAttribute(
        XmlName(IOSStrings.rectElementWidthAttr),
        IOSStrings.storyboardImageResourceWidth,
      ),
      XmlAttribute(
        XmlName(IOSStrings.rectElementHeightAttr),
        IOSStrings.storyboardImageResourceHeight,
      ),
    ],
  );
}

/// Create a color set for the launch screen background color with light
/// and dark variants.
Future<void> createLaunchBackgroundColorSet({
  required String lightColor,
  required String darkColor,
}) async {
  const directoryPath =
      '${CmdStrings.iosAssetCatalogDirectory}/${IOSStrings.launchBackgroundColorSetDirectory}';
  final directory = Directory(directoryPath);
  if (!await directory.exists()) {
    await directory.create(recursive: true);
  }

  final file = File('$directoryPath/${IOSStrings.iosContentJson}');

  final json = {
    'info': {
      'author': 'xcode',
      'version': 1,
    },
    'colors': [
      {
        'idiom': 'universal',
        'color': {
          'color-space': 'srgb',
          'components': {
            'red': _hexToDecimal(lightColor.substring(1, 3)),
            'green': _hexToDecimal(lightColor.substring(3, 5)),
            'blue': _hexToDecimal(lightColor.substring(5, 7)),
            'alpha': '1.000',
          },
        },
      },
      {
        'idiom': 'universal',
        'appearances': [
          {
            IOSStrings.appearanceKey: IOSStrings.appearanceLuminosity,
            IOSStrings.appearanceValueKey: IOSStrings.appearanceDark,
          }
        ],
        'color': {
          'color-space': 'srgb',
          'components': {
            'red': _hexToDecimal(darkColor.substring(1, 3)),
            'green': _hexToDecimal(darkColor.substring(3, 5)),
            'blue': _hexToDecimal(darkColor.substring(5, 7)),
            'alpha': '1.000',
          },
        },
      },
    ],
  };

  await file.writeAsString(encoder.convert(json));
}

void _setNamedBackgroundColor(XmlElement view) {
  final colorElement = view.getElement(IOSStrings.colorElement);
  if (colorElement != null) {
    colorElement.attributes
      ..clear()
      ..addAll([
        XmlAttribute(
            XmlName(IOSStrings.colorKeyAttr), IOSStrings.colorKeyAttrVal),
        XmlAttribute(
          XmlName(IOSStrings.nameAttr),
          IOSStrings.launchBackgroundColorAssetName,
        ),
      ]);
    colorElement.children.clear();
    return;
  }

  view.children.add(
    XmlElement(
      XmlName(IOSStrings.colorElement),
      [
        XmlAttribute(
            XmlName(IOSStrings.colorKeyAttr), IOSStrings.colorKeyAttrVal),
        XmlAttribute(
          XmlName(IOSStrings.nameAttr),
          IOSStrings.launchBackgroundColorAssetName,
        ),
      ],
    ),
  );
}

/// Update color attributes for a color element
void _updateColorAttributes(XmlElement colorElement, String hexColor) {
  /// Reset attributes to avoid retaining stale named-color references.
  colorElement.attributes
    ..clear()
    ..addAll(_buildColorAttributes(hexColor));
  colorElement.children.clear();
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
      XmlName('colorSpace'),
      'custom',
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
  const iosAssetsFolder = CmdStrings.iosAssetsDirectory;

  final file = File('$iosAssetsFolder/${IOSStrings.iosContentJson}');
  IosContentJsonDm iosContentJsonDm;

  if (await file.exists()) {
    final jsonString = await file.readAsString();
    final json = jsonDecode(jsonString);
    iosContentJsonDm = IosContentJsonDm.fromJson(json);
  } else {
    iosContentJsonDm = const IosContentJsonDm(
      images: [],
      info: Info(author: 'xcode', version: 1),
    );
  }

  final updatedIosContentJson = iosContentJsonDm.copyWith(images: images);
  final encodedContentJson = encoder.convert(updatedIosContentJson);
  await file.writeAsString(encodedContentJson);
  log('Updated Contents.json.');
}

Future<void> createBackgroundImage(
  Image? image,
  File? imageFile, {
  File? darkImageFile,
}) async {
  const iosAssetsFolder = CmdStrings.iosBackgroundImageDirectory;
  final file = await File('$iosAssetsFolder/${IOSStrings.iosContentJson}')
      .create(recursive: true);

  final List<Image> images = [];
  if (image != null) {
    images.add(image);
  }
  if (darkImageFile != null) {
    images.add(const Image(
      scale: '3x',
      filename: '${IOSStrings.backgroundImageDarkSnakeCase}.png',
      idiom: 'universal',
      appearances: [
        {
          IOSStrings.appearanceKey: IOSStrings.appearanceLuminosity,
          IOSStrings.appearanceValueKey: IOSStrings.appearanceDark,
        }
      ],
    ));
  }

  final iosContent = IosContentJsonDm(
    images: images,
    info: const Info(author: 'xcode', version: 1),
  );
  final iosContentJson = iosContent.toJson();
  await file.writeAsString(encoder.convert(iosContentJson));

  if (imageFile != null) {
    final backgroundImage =
        File('$iosAssetsFolder/${IOSStrings.backgroundImageSnakeCase}.png');
    await backgroundImage.writeAsBytes(await imageFile.readAsBytes());
  }

  if (darkImageFile != null) {
    final backgroundImageDark =
        File('$iosAssetsFolder/${IOSStrings.backgroundImageDarkSnakeCase}.png');
    await backgroundImageDark.writeAsBytes(await darkImageFile.readAsBytes());
  }
}

Future<void> _removeLegacyLaunchImageFiles(String iosAssetsFolder) async {
  final legacyFiles = <String>[
    '${IOSStrings.imageValue}.png',
    '${IOSStrings.imageValue}@2x.png',
    '${IOSStrings.imageValue}@3x.png',
  ];

  for (final fileName in legacyFiles) {
    final file = File('$iosAssetsFolder/$fileName');
    if (await file.exists()) {
      await file.delete();
      log('Removed stale iOS launch asset: $fileName');
    }
  }
}

Future<void> _cleanupGeneratedLaunchImageFiles(
  String iosAssetsFolder, {
  required bool keepLightAssets,
  required bool keepDarkAssets,
}) async {
  final fileNames = <String>[
    '${IOSStrings.splashImage}.png',
    '${IOSStrings.splashImage}@2x.png',
    '${IOSStrings.splashImage}@3x.png',
  ];

  if (!keepDarkAssets) {
    fileNames.addAll([
      '${IOSStrings.splashImageDark}.png',
      '${IOSStrings.splashImageDark}@2x.png',
      '${IOSStrings.splashImageDark}@3x.png',
    ]);
  }

  if (!keepLightAssets) {
    for (final lightFile in [
      '${IOSStrings.splashImage}.png',
      '${IOSStrings.splashImage}@2x.png',
      '${IOSStrings.splashImage}@3x.png',
    ]) {
      if (!fileNames.contains(lightFile)) {
        fileNames.add(lightFile);
      }
    }
  }

  for (final fileName in fileNames) {
    final file = File('$iosAssetsFolder/$fileName');
    if (await file.exists()) {
      final isDarkAsset = fileName.startsWith(IOSStrings.splashImageDark);
      final shouldDelete = isDarkAsset ? !keepDarkAssets : !keepLightAssets;
      if (shouldDelete) {
        await file.delete();
        log('Removed stale generated iOS launch asset: $fileName');
      }
    }
  }
}

Future<void> _removeBackgroundImageSet() async {
  final directory = Directory(CmdStrings.iosBackgroundImageDirectory);
  if (await directory.exists()) {
    await directory.delete(recursive: true);
    log('Removed stale iOS background image set.');
  }
}

Future<void> _removeLaunchBackgroundColorSet() async {
  final directory = Directory(
    '${CmdStrings.iosAssetCatalogDirectory}/${IOSStrings.launchBackgroundColorSetDirectory}',
  );
  if (await directory.exists()) {
    await directory.delete(recursive: true);
    log('Removed stale iOS launch background color set.');
  }
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
XmlElement? getBackgroundImageElement(XmlElement? subViews) {
  return subViews?.children.whereType<XmlElement>().firstWhereOrNull(
        (child) =>
            child.name.qualified == IOSStrings.imageViewElement &&
            child.getAttribute(IOSStrings.defaultImageViewId) ==
                IOSStrings.backgroundImageViewIdValue,
      );
}

XmlElement? _buildConstraintsElement({
  required bool includeSplashImage,
  required String splashContentMode,
  required bool includeBackgroundImage,
  required String backgroundContentMode,
}) {
  final constraints = <XmlNode>[];

  if (includeSplashImage) {
    constraints.addAll(
      _constraintsForImage(
        imageViewId: IOSStrings.defaultImageViewIdValue,
        contentMode: splashContentMode,
        verticalIds: const ['xPn-NY-SIU', 'duK-uY-Gun', 'sYI-sP-v01'],
        horizontalIds: const ['3T2-ad-Qdv', 'TQA-XW-tRk', 'sYI-sP-h01'],
      ),
    );
  }

  if (includeBackgroundImage) {
    constraints.addAll(
      _constraintsForImage(
        imageViewId: IOSStrings.backgroundImageViewIdValue,
        contentMode: backgroundContentMode,
        verticalIds: const ['B02-Ap-adr', 'e2S-gZ-2jl', 'sYI-sP-v02'],
        horizontalIds: const ['zVa-1q-mai', 'T4v-vm-VRP', 'sYI-sP-h02'],
      ),
    );
  }

  if (constraints.isEmpty) {
    return null;
  }

  return XmlElement(
    XmlName(IOSStrings.constraintsElement),
    const [],
    constraints,
  );
}

List<XmlElement> _constraintsForImage({
  required String imageViewId,
  required String contentMode,
  required List<String> verticalIds,
  required List<String> horizontalIds,
}) {
  if (_fillsContainer(contentMode)) {
    return [
      _constraint(
        id: horizontalIds[0],
        firstItem: imageViewId,
        firstAttribute: 'leading',
      ),
      _constraint(
        id: horizontalIds[1],
        firstItem: imageViewId,
        firstAttribute: 'trailing',
      ),
      _constraint(
        id: verticalIds[0],
        firstItem: imageViewId,
        firstAttribute: 'top',
      ),
      _constraint(
        id: verticalIds[1],
        firstItem: imageViewId,
        firstAttribute: 'bottom',
      ),
    ];
  }

  final vertical = _verticalConstraintAttribute(contentMode);
  final horizontal = _horizontalConstraintAttribute(contentMode);

  return [
    _constraint(
      id: vertical == 'top'
          ? verticalIds[0]
          : vertical == 'bottom'
              ? verticalIds[1]
              : verticalIds[2],
      firstItem: imageViewId,
      firstAttribute: vertical,
    ),
    _constraint(
      id: horizontal == 'leading'
          ? horizontalIds[0]
          : horizontal == 'trailing'
              ? horizontalIds[1]
              : horizontalIds[2],
      firstItem: imageViewId,
      firstAttribute: horizontal,
    ),
  ];
}

XmlElement _constraint({
  required String id,
  required String firstItem,
  required String firstAttribute,
}) {
  return XmlElement(
    XmlName('constraint'),
    [
      XmlAttribute(XmlName('firstItem'), firstItem),
      XmlAttribute(XmlName('firstAttribute'), firstAttribute),
      XmlAttribute(XmlName('secondItem'), IOSStrings.defaultViewId),
      XmlAttribute(XmlName('secondAttribute'), firstAttribute),
      XmlAttribute(XmlName('id'), id),
    ],
  );
}

bool _fillsContainer(String contentMode) {
  return contentMode == IosContentMode.scaleToFill.name ||
      contentMode == IosContentMode.scaleAspectFit.name ||
      contentMode == IosContentMode.scaleAspectFill.name ||
      contentMode == IosContentMode.redraw.name;
}

String _verticalConstraintAttribute(String contentMode) {
  switch (contentMode) {
    case 'top':
    case 'topLeft':
    case 'topRight':
      return 'top';
    case 'bottom':
    case 'bottomLeft':
    case 'bottomRight':
      return 'bottom';
    default:
      return 'centerY';
  }
}

String _horizontalConstraintAttribute(String contentMode) {
  switch (contentMode) {
    case 'left':
    case 'topLeft':
    case 'bottomLeft':
      return 'leading';
    case 'right':
    case 'topRight':
    case 'bottomRight':
      return 'trailing';
    default:
      return 'centerX';
  }
}
