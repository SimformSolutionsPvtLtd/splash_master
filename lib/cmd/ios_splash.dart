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
  String? inputPath,
  String? color,
  String? iosContentMode,
}) async {
  const iosAssetsFolder = CmdStrings.iosAssetsDirectory;

  final directory = Directory(iosAssetsFolder);
  if (!await directory.exists()) {
    log("$iosAssetsFolder path doesn't exists. Creating it...");
    directory.create(recursive: true);
  }

  final List<Image> images = [];

  if (inputPath != null) {
    for (final scale in IosScale.values) {
      final fileName = 'splash_image${scale.fileEndWith}.png';
      final imagePath = '$iosAssetsFolder/$fileName';
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }

      final sourceImage = File(inputPath);

      sourceImage.copySync(imagePath);

      log('Generated $fileName.');
      images.add(Image(
        idiom: 'universal',
        filename: fileName,
        scale: scale.scale,
      ));
    }
  }
  updateContentOfStoryboard(
    imagePath: inputPath,
    color: color,
    iosContentMode: iosContentMode,
  );

  await updateContentJson(images);
}

/// Update the default storyboard content with the provided details
/// Image, Color and contentMode
void updateContentOfStoryboard({
  String? imagePath,
  String? color,
  String? iosContentMode,
}) {
  final file = File(CmdStrings.storyboardPath);
  final xmlDocument = XmlDocument.parse(file.readAsStringSync());
  final documentData = xmlDocument.getElement('document');

  final view =
      documentData?.descendants.whereType<XmlElement>().firstWhere((element) {
    return element.name.qualified == 'view' &&
        element.getAttribute('id') == 'Ze5-6b-2t3';
  });
  if (view == null) {
    log(
      'Default Flutter view Ze5-6b-2t3 not found.',
    );
    exit(1);
  }

  final subViews = view.getElement('subviews');
  if (subViews == null) {
    final subview = _createImageSubView();
    view.children.add(subview);
  }

  if (color != null) {
    /// Update or add a `color` element for the background color
    final colorElement = view.getElement('color');
    if (colorElement != null) {
      /// Update existing color with provided color code
      _updateColorAttributes(colorElement, color);
    } else {
      /// Add a new color element with provided color code
      view.children.add(XmlElement(
        XmlName('color'),
        _buildColorAttributes(color),
      ));
    }
  } else {
    final colorElement = view.getElement('color');
    if (colorElement != null) {
      /// Update existing color to white background
      _updateColorAttributes(colorElement, '#FFFFFF');
    } else {
      /// Add a new color element with white background color
      view.children.add(XmlElement(
        XmlName('color'),
        _buildColorAttributes('#FFFFFF'),
      ));
    }
  }
  if (imagePath != null) {
    /// Find the imageView element in subViews element
    final imageView = subViews?.children.whereType<XmlElement?>().firstWhere(
      (element) =>
          element?.name.qualified == 'imageView' &&
          element?.getAttribute('image') == 'LaunchImage',
      orElse: () {
        log(
          'Unable to find default imageView with the LaunchImage',
        );
        exit(1);
      },
    );

    /// Update the fill property
    imageView?.setAttribute('contentMode', iosContentMode ?? 'scaleToFill');

    /// Remove and update the constraints
    view.children.remove(view.getElement('constraints'));
    view.children.add(
      XmlDocument.parse(SplashScreenContentString.imageConstraintString)
          .rootElement
          .copy(),
    );
  } else {
    /// Image is not available then remove constraints and subview element
    view.children.remove(view.getElement('constraints'));
    final subviewsTag = documentData?.findAllElements('subviews').firstOrNull;

    subviewsTag?.remove();
  }

  /// Write the updated storyboard content to the file.
  file.writeAsStringSync(
    '${xmlDocument.toXmlString(pretty: true, indent: '    ')}\n',
  );
}

/// Update color attributes for a color element
void _updateColorAttributes(XmlElement colorElement, String hexColor) {
  colorElement.setAttribute('key', 'backgroundColor');
  colorElement.setAttribute('customColorSpace', 'sRGB');
  colorElement.setAttribute('red', _hexToDecimal(hexColor.substring(1, 3)));
  colorElement.setAttribute('green', _hexToDecimal(hexColor.substring(3, 5)));
  colorElement.setAttribute('blue', _hexToDecimal(hexColor.substring(5, 7)));
  colorElement.setAttribute('alpha', '1');
}

/// Build attributes for a new color element
List<XmlAttribute> _buildColorAttributes(String hexColor) {
  return [
    XmlAttribute(XmlName('key'), 'backgroundColor'),
    XmlAttribute(XmlName('customColorSpace'), 'sRGB'),
    XmlAttribute(XmlName('red'), _hexToDecimal(hexColor.substring(1, 3))),
    XmlAttribute(XmlName('green'), _hexToDecimal(hexColor.substring(3, 5))),
    XmlAttribute(XmlName('blue'), _hexToDecimal(hexColor.substring(5, 7))),
    XmlAttribute(XmlName('alpha'), '1'),
  ];
}

/// Create the subviews element.
/// Create two sub element inside the `subviews` element.
/// `imageView` and `rect`.
XmlElement _createImageSubView() {
  final element = XmlElement(XmlName('subviews'), [], [
    XmlElement(
      XmlName('imageView'),
      [
        XmlAttribute(XmlName('opaque'), 'NO'),
        XmlAttribute(XmlName('clipsSubviews'), 'YES'),
        XmlAttribute(XmlName('multipleTouchEnabled'), 'YES'),
        XmlAttribute(XmlName('contentMode'), 'scaleAspectFill'),
        XmlAttribute(XmlName('image'), 'LaunchImage'),
        XmlAttribute(
            XmlName('translatesAutoresizingMaskIntoConstraints'), 'NO'),
        XmlAttribute(XmlName('id'), 'YRO-k0-Ey4'),
      ],
      [
        XmlElement(
          XmlName('rect'),
          [
            XmlAttribute(XmlName('key'), 'frame'),
            XmlAttribute(XmlName('x'), '0.0'),
            XmlAttribute(XmlName('y'), '0.0'),
            XmlAttribute(XmlName('width'), '393'),
            XmlAttribute(XmlName('height'), '1280'),
          ],
        ),
      ],
    )
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

  final file = File('$iosAssetsFolder/Contents.json');
  final jsonString = await file.readAsString();
  final json = jsonDecode(jsonString);
  final iosContentJsonDm = IosContentJsonDm.fromJson(json);

  final updatedIosContentJson = iosContentJsonDm.copyWith(images: images);
  const encoder = JsonEncoder.withIndent((' '));
  final encodedContentJson = encoder.convert(updatedIosContentJson);
  await file.writeAsString(encodedContentJson);
  log('Updated Contents.json.');
}
