import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:splash_master/cmd/cmd_strings.dart';
import 'package:splash_master/cmd/cmd_utils.dart';
import 'package:splash_master/cmd/models/ios_content_json_dm.dart';
import 'package:xml/xml.dart';

import 'logging.dart';

part 'android_splash.dart';
part 'install_commands.dart';
part 'ios_splash.dart';
part 'lottie_to_image.dart';

void commandEntry(List<String> arguments) {
  if (arguments.isEmpty) {
    log('Usage: ffmpeg_frame_extractor <command> [options]');
    log('Commands:');
    log('  install  Install required tools to generate splash images.');
    log('  build  <inputPath>  Extract the first frame from the video and updates native files of android & ios to set generated splash images.');
    log('  genLottie <inputPath> Extract the first frame from the lottie file and updates native files of android & ios to set generated splash images.');
    return;
  }

  final argument = arguments[0];

  final command = Command.fromString(argument);
  switch (command) {
    case Command.install:
      if (arguments.length == 2) {
        final inputPath = arguments[1];
        if (inputPath == 'video') {
          installFFmpeg();
        } else if (inputPath == 'lottie') {
          lottieSetup();
        } else {
          log('Invalid arguments.');
        }
      } else {
        log('Invalid arguments.');
      }
      break;
    case Command.video:
    case Command.image:
      if (arguments.length == 2 || arguments.length == 3) {
        final inputPath = arguments[1];
        final isPluginTestMode = arguments.length == 3 && arguments[2] == '-t';
        applySplash(inputPath, isPluginTestMode: isPluginTestMode);
      } else {
        log('Invalid arguments.');
      }
      break;
    case Command.lottie:
      if (arguments.length == 2 || arguments.length == 3) {
        final inputPath = arguments[1];
        final isPluginTestMode = arguments.length == 3 && arguments[2] == '-t';
        lottieAsSplash(inputPath, isPluginTestMode: isPluginTestMode);
      } else {
        log('Invalid arguments.');
      }
      break;
    case Command.setup:
      if (arguments.length == 2 && arguments[1] == 'native_splash') {
        setupNativeSplash();
      } else {
        log('Invalid arguments.');
      }
      break;
    case Command.none:
      log('Invalid command or arguments.');
  }
}

Future<int> runFFmpegCommand({
  required String inputPath,
  required String outputPath,
  AndroidMipMaps? mipMaps,
  IosScale? iosScale,
}) async {
  final List<String> args = [
    '-i',
    inputPath,
    '-vf',
    'select=eq(n\\,0)',
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
  final assetsPath = exampleDir.isEmpty ? 'assets' : '$exampleDir/assets';

  final directory = Directory(assetsPath);

  if (!(await directory.exists())) {
    log("assets folder doesn't exists. Creating it...");
    directory.create(recursive: true);
  }

  final outputPath = '$assetsPath/splash_image.png';
  final file = File(outputPath);
  if ((await file.exists())) {
    await file.delete();
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
  await generateAndroidImages(inputPath, isPluginTestMode: isPluginTestMode);
  await createSplashImageDrawable(isPluginTestMode: isPluginTestMode);
  await updateStylesXml(isPluginTestMode: isPluginTestMode);
}

Future<void> applySplash(
  String inputPath, {
  bool isPluginTestMode = false,
}) async {
  await generateIosImages(inputPath, isPluginTestMode: isPluginTestMode);
  await applyAndroidSplashImage(inputPath, isPluginTestMode: isPluginTestMode);
  await generateAssetImage(inputPath, isPluginTestMode: isPluginTestMode);
}

Future<void> setupNativeSplash() async {
  try {
    final Uri? packageUri = await Isolate.resolvePackageUri(
      Uri.parse(CmdStrings.createStoryBoardScriptPath),
    );

    // Run the shell script
    ProcessResult result = await Process.run(
      'bash', // Use bash to execute the shell script
      [
        // Provide the path to the shell script
        packageUri?.path ?? '',
      ],
    );

    // Check if the script ran successfully
    if (result.exitCode == 0) {
      log(result.stdout);
    } else {
      log('Error: ${result.stderr}');
    }
  } catch (e) {
    log('Error running the script: $e');
  }
}
