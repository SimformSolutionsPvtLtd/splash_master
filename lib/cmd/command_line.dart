import 'dart:io';
import 'dart:convert';

import 'package:splash_master/cmd/cmd_strings.dart';
import 'package:splash_master/cmd/cmd_utils.dart';
import 'package:xml/xml.dart';

import 'logging.dart';

part 'android_splash.dart';

void commandEntry(List<String> arguments) {
  if (arguments.isEmpty) {
    log('Usage: ffmpeg_frame_extractor <command> [options]');
    log('Commands:');
    log('  install  Install FFmpeg');
    log('  build  <inputPath>  Extract the first frame from a video, sets it to native mipmap folder and updates styles.xml file accordingly.');
    return;
  }

  final argument = arguments[0];

  final command = Command.fromString(argument);
  switch (command) {
    case Command.install:
      installFFmpeg();
      break;
    case Command.build:
      if (arguments.length == 2 || arguments.length == 3) {
        final inputPath = arguments[1];
        final isPluginTestMode = arguments.length == 3 && arguments[2] == '-t';
        applyAndroidSplashImage(inputPath, isPluginTestMode: isPluginTestMode);
      } else {
        log('Invalid arguments.');
      }
      break;
    case Command.none:
      log('Invalid command or arguments.');
  }
}

Future<void> installFFmpeg() async {
  log('Installing FFmpeg...');

  if (Platform.isMacOS) {
    await runCommand('brew', ['install', 'ffmpeg']);
  } else if (Platform.isLinux) {
    await runCommand('sudo', ['apt', 'update']);
    await runCommand('sudo', ['apt', 'install', '-y', 'ffmpeg']);
  } else if (Platform.isWindows) {
    log("Please manually install FFmpeg for Windows from https://ffmpeg.org/download.html");
    return;
  } else {
    log('Unsupported platform for installation.');
    return;
  }

  log('Splash master setup successful.');
}

Future<int> runFFmpegCommand({
  required String inputPath,
  required String outputPath,
  AndroidMipMaps? mipMaps,
}) async {
  final scale =
      mipMaps != null ? ',scale=${mipMaps.width}:${mipMaps.height}' : '';
  final List<String> args = [
    '-i',
    inputPath,
    '-vf',
    'select=eq(n\\,0)$scale',
    '-q:v',
    '3',
    outputPath
  ];

  try {
    Process process = await Process.start('ffmpeg', args);

    int exitCode = await process.exitCode;
    return exitCode;
  } catch (e) {
    log('Error running FFmpeg: $e');
    return -1;
  }
}

Future<void> runCommand(String command, List<String> arguments) async {
  try {
    Process process = await Process.start(command, arguments);

    process.stdout.transform(utf8.decoder).listen((data) {
      log(data);
    });

    process.stderr.transform(utf8.decoder).listen((data) {
      log("Error: $data");
    });

    int exitCode = await process.exitCode;
    if (exitCode != 0) {
      log("Command failed with exit code $exitCode");
    }
  } catch (e) {
    log("Failed to run command: $e");
  }
}

Future<void> generateAssetImage(
  String inputPath, {
  bool isPluginTestMode = false,
}) async {
  final exampleDir = isPluginTestMode ? 'example' : '';
  final assetsPath = '$exampleDir/assets';

  final directory = Directory(assetsPath);

  if (!(await directory.exists())) {
    log("assets folder doesn't exists. Creating it...");
    directory.create(recursive: true);
  }

  final outputPath = '$assetsPath/splash_image.png';
  if ((await File(outputPath).exists())) {
    log("Image already exists with same name at $outputPath");
    return;
  }
  await runFFmpegCommand(
    inputPath: inputPath,
    outputPath: outputPath,
  );
  log('Splash image added to assets.');
}

Future<void> applyAndroidSplashImage(
  String inputPath, {
  bool isPluginTestMode = false,
}) async {
  await generateAssetImage(inputPath, isPluginTestMode: isPluginTestMode);
  await generateAndroidImages(inputPath, isPluginTestMode: isPluginTestMode);
  await createSplashImageDrawable(isPluginTestMode: isPluginTestMode);
  await updateStylesXml(isPluginTestMode: isPluginTestMode);
}
