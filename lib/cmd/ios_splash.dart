part of 'command_line.dart';

Future<void> generateIosImages(
  String inputPath, {
  bool isPluginTestMode = false,
}) async {
  final exampleDir = isPluginTestMode ? 'example/' : '';
  final iosAssetsFolder = '$exampleDir${CmdStrings.iosAssetsFolder}';

  final directory = Directory(iosAssetsFolder);
  if (!await directory.exists()) {
    log("$iosAssetsFolder path doesn't exists. Creating it...");
    directory.create(recursive: true);
  }

  final List<Image> images = [];

  for (final scale in IosScale.values) {
    final fileName = 'splash_image${scale.fileEndWith}.png';
    final imagePath = '$iosAssetsFolder/$fileName';
    final file = File(imagePath);
    if (await file.exists()) {
      log('Image already exists at $imagePath. Skipping it.');
      continue;
    }
    await runFFmpegCommand(
      inputPath: inputPath,
      outputPath: imagePath,
      iosScale: scale,
    );
    log('Generated $fileName.');
    images.add(Image(
      idiom: 'universal',
      filename: fileName,
      scale: scale.scale,
    ));
  }

  await updateContentJson(images, isPluginTestMode: isPluginTestMode);
}

Future<void> updateContentJson(
  List<Image> images, {
  bool isPluginTestMode = false,
}) async {
  if (images.isEmpty) {
    log('No images were generated. Skipping Updating Contents.json.');
    return;
  }
  final exampleDir = isPluginTestMode ? 'example/' : '';
  final iosAssetsFolder = '$exampleDir${CmdStrings.iosAssetsFolder}';

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
