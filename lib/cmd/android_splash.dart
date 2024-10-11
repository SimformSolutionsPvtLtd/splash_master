part of 'command_line.dart';

Future<void> generateAndroidImages(
  String inputPath, {
  bool isPluginTestMode = false,
}) async {
  final exampleDir = isPluginTestMode ? 'example/' : '';
  final androidResDir = '$exampleDir${CmdStrings.androidResFolder}';

  for (final mipmap in AndroidMipMaps.values) {
    final mipmapFolder = '$androidResDir/${mipmap.folder}';
    final directory = Directory(mipmapFolder);
    if (!(await directory.exists())) {
      log("${mipmap.folder} folder doesn't exists. Creating it...");
      await Directory(mipmapFolder).create(recursive: true);
    }
    final imagePath = '$mipmapFolder/splash_image.png';
    final isImageExists = await File(imagePath).exists();
    if (isImageExists) {
      log(
        'Image already exists at $imagePath. Skipping image generation for ${mipmap.folder}.',
      );
      continue;
    }
    await runFFmpegCommand(
      inputPath: inputPath,
      mipMaps: mipmap,
      outputPath: '$mipmapFolder/splash_image.png',
    );
    log("Splash image added to ${mipmap.folder}");
  }
}

Future<void> updateStylesXml({bool isPluginTestMode = false}) async {
  final exampleDir = isPluginTestMode ? 'example/' : '';
  final androidValuesFolder = '$exampleDir${CmdStrings.androidValuesFolder}';

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

Future<void> createSplashImageDrawable({bool isPluginTestMode = false}) async {
  final exampleDir = isPluginTestMode ? 'example/' : '';
  final androidDrawableFolder =
      '$exampleDir${CmdStrings.androidDrawableFolder}';
  final splashImagePath = '$androidDrawableFolder/splash_image.xml';
  final file = File(splashImagePath);
  if (!await file.exists()) {
    log("splash_image.xml already exists at $splashImagePath. Skipping generating it.");
    return;
  }

  final xml = await file.create();
  final builder = XmlBuilder();
  builder.processing('xml', 'version="1.0" encoding="utf-8"');
  builder.element('layer-list', nest: () {
    builder.attribute(
      'xmlns:android',
      'http://schemas.android.com/apk/res/android',
    );
    builder.element('item', nest: () {
      builder.element('bitmap', nest: () {
        builder.attribute('android:gravity', 'center');
        builder.attribute('android:src', '@mipmap/splash_image');
        builder.attribute('android:tileMode', 'disabled');
      });
    });
  });

  final document = builder.buildDocument();
  await xml.writeAsString(document.toXmlString(pretty: true));
  log("Created splash_image.xml.");
}
