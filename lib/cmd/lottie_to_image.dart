part of 'command_line.dart';

Future<void> lottieAsSplash(
  String inputPath, {
  bool isPluginTestMode = false,
}) async {
  final outputDir = isPluginTestMode ? 'example' : '';
  final outputPath = '$outputDir/assets/lottie_splash_image.png';

  final lottieJsScript = await Isolate.resolvePackageUri(
    Uri.parse(CmdStrings.generateImageScriptPath),
  );
  final process = await Process.start(
    'node',
    [
      lottieJsScript?.path ?? '',
      inputPath,
      outputPath,
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

Future<void> deleteTempImage({bool isPluginTestMode = false}) async {
  final outputDir = isPluginTestMode ? 'example' : '';
  final image = '$outputDir/assets/lottie_splash_image.png';

  final file = File(image);

  if (await file.exists()) {
    await file.delete();
    log('Deleted temporary lottie_splash_image.png.');
  }
}
