part of 'command_line.dart';

/// Generate splash images for the Android
Future<void> generateAndroidImages({
  String? inputPath,
  String? color,
  YamlMap? android12,
}) async {
  if (inputPath == null || android12 == null) {
    log('No images were provided. Skip generating Android images');
    return;
  }
  const androidResDir = CmdStrings.androidResDirectory;

  // Create splash images with the provided image in mipmap directories
  for (final mipmap in AndroidMipMaps.values) {
    final mipmapFolder = '$androidResDir/${mipmap.folder}';
    final directory = Directory(mipmapFolder);
    if (!(await directory.exists())) {
      log("${mipmap.folder} folder doesn't exists. Creating it...");
      await Directory(mipmapFolder).create(recursive: true);
    }

    /// Create image in mipmap directories for the Android 12+
    if (android12['image'] != null) {
      final imagePath = '$mipmapFolder/splash_image_12.png';
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }
      final sourceImage = File(android12['image']);
      sourceImage.copySync(imagePath);
    }
    final imagePath = '$mipmapFolder/splash_image.png';
    final file = File(imagePath);
    if (await file.exists()) {
      await file.delete();
    }
    final sourceImage = File(inputPath);
    sourceImage.copySync(imagePath);
    log("Splash image added to ${mipmap.folder}");
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
  const colorsFilePath = '$androidValuesFolder/colors.xml';

  final xmlFile = File(colorsFilePath);
  if (await xmlFile.exists()) {
    final xmlDocument = XmlDocument.parse(xmlFile.readAsStringSync());
    final resourcesElement = xmlDocument.findAllElements('resources').first;

    /// Check if `splashBackGroundColor` attribute value is already available
    for (final element in resourcesElement.childElements) {
      if (element.getAttribute('name') == 'splashBgColor') {
        /// Remove the attribute
        element.remove();
        break;
      }
    }

    resourcesElement.children.addAll([
      XmlElement(
        XmlName('color'),
        [
          XmlAttribute(XmlName('name'), 'splashBgColor'),
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
    builder.processing('xml', 'version="1.0" encoding="utf-8"');
    builder.element('resources', nest: () {
      builder.element(
        'color',
        attributes: {'name': 'splashBgColor'},
        nest: color,
      );
    });
    final document = builder.buildDocument();
    await xml.writeAsString(document.toXmlString(pretty: true));
  }
}

/// Updates the `styles.xml` file for the splash screen setup.
Future<void> updateStylesXml({
  YamlMap? android12,
  String? inputPath,
  String? color,
}) async {
  const androidValuesFolder = CmdStrings.androidValuesDirectory;

  if (android12 != null &&
      (android12['color'] != null || android12['image'] != null)) {
    const v31 = 'android/app/src/main/res/values-v31';
    if (!await Directory(v31).exists()) {
      Directory(v31).create();
    }
    const style = '$v31/styles.xml';
    if (await File(style).exists()) {
      File(style).delete();
    }
    final styleFile = File(style);

    createAndroid12Styles(
      styleFile: styleFile,
      color: android12['color'],
      inputPath: android12['image'],
    );
  }
  final xml = File('$androidValuesFolder/styles.xml');
  final xmlExists = await xml.exists();
  if (!xmlExists) {
    log("styles.xml doesn't exists");
    return;
  }
  final xmlDoc = XmlDocument.parse(xml.readAsStringSync());
  xmlDoc.findAllElements('item').where((itemElement) {
    return itemElement.getAttribute('name') == 'android:windowBackground';
  }).forEach((itemElement) {
    itemElement.setAttribute('name', 'android:windowBackground');
    itemElement.innerText = '@drawable/splash_screen';
  });

  await xml.writeAsString(xmlDoc.toXmlString(pretty: true));
  log('styles.xml updated.');
}

/// Updates the `styles.xml` file for the splash screen setup for Android 12+.
Future<void> createAndroid12Styles({
  required File styleFile,
  String? color,
  String? inputPath,
}) async {
  final xml = await styleFile.create();

  final builder = XmlBuilder();
  builder.processing('xml', 'version="1.0" encoding="utf-8"');
  builder.element(
    'resources',
    nest: () {
      builder.element(
        'style',
        attributes: {
          'name': 'LaunchTheme',
          'parent': '@android:style/Theme.Light.NoTitleBar',
        },
        nest: () {
          if (color != null) {
            builder.element(
              'item',
              attributes: {'name': 'android:windowSplashScreenBackground'},
              nest: color,
            );
          }
          if (inputPath != null) {
            builder.element(
              'item',
              attributes: {
                'name': 'android:windowSplashScreenAnimatedIcon',
              },
              nest: '@mipmap/splash_image12',
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
  String? inputPath,
  String? color,
  String? gravity,
}) async {
  const androidDrawableFolder = CmdStrings.androidDrawableDirectory;
  const splashImagePath = '$androidDrawableFolder/splash_screen.xml';
  final file = File(splashImagePath);

  final xml = await file.create();
  final builder = XmlBuilder();
  builder.processing('xml', 'version="1.0" encoding="utf-8"');
  builder.element('layer-list', nest: () {
    builder.attribute(
      'xmlns:android',
      'http://schemas.android.com/apk/res/android',
    );
    if (color != null) {
      builder.element(
        'item',
        nest: () {
          builder.attribute('android:drawable', '@color/splashBgColor');
        },
      );
    }

    if (inputPath != null) {
      builder.element('item', nest: () {
        builder.element('bitmap', nest: () {
          builder.attribute('android:gravity', gravity ?? 'fill');
          builder.attribute('android:src', '@mipmap/splash_image');
          builder.attribute('android:tileMode', 'disabled');
        });
      });
    }
  });

  final document = builder.buildDocument();
  await xml.writeAsString(document.toXmlString(pretty: true));
  log("Created splash_screen.xml.");
}
