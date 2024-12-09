part of 'command_line.dart';

Future<void> lottieAsSplash(
  String inputPath, {
  bool isPluginTestMode = false,
}) async {
  final outputDir = isPluginTestMode ? 'example/' : '';
  final outputPath = '${outputDir}assets/splash_image.png';

  final lottieJsScript = await Isolate.resolvePackageUri(
    Uri.parse(CmdStrings.generateImageScriptPath),
  );

  final (width, height) = await getLottieDimensions(inputPath);
  final process = await Process.start(
    'node',
    [
      lottieJsScript?.path ?? '',
      inputPath,
      outputPath,
      height.toString(),
      width.toString(),
    ],
  );

  process.stdout.transform(utf8.decoder).listen((data) {
    log(data);
  });

  process.stderr.transform(utf8.decoder).listen((data) {
    log("Error: $data");
  });

  // Wait for the process to complete.
  await process.exitCode;

  await applySplash(
    outputPath,
    isPluginTestMode: isPluginTestMode,
  );

  await deleteTempImage(isPluginTestMode: isPluginTestMode);
}

/// Get exact dimension of the lottie file (width, height)
Future<(int, int)> getLottieDimensions(String lottieFilePath) async {
  // Load the Lottie file as a string
  try {
    final lottieContent = File(lottieFilePath);

    final read = await lottieContent.readAsString();

    // Decode the JSON content
    final Map<String, dynamic> lottieJson = json.decode(read);
    // Extract dimensions
    final int width = lottieJson['w'];
    final int height = lottieJson['h'];

    return (width, height);
  } catch (e) {
    return (1080, 1920);
  }
}

Future<void> deleteTempImage({bool isPluginTestMode = false}) async {
  final outputDir = isPluginTestMode ? 'example' : '';
  final image = '$outputDir/assets/splash_image.png';

  final file = File(image);

  if (await file.exists()) {
    await file.delete();
    log('Deleted temporary splash_image.png.');
  }
}
