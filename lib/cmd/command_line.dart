import 'dart:io';
import 'dart:convert';

import 'logging.dart';

void commandEntry(List<String> arguments) {
  if (arguments.isEmpty) {
    log('Usage: ffmpeg_frame_extractor <command> [options]');
    log('Commands:');
    log('  install  Install FFmpeg');
    log('  extract  <inputPath> <outputPath>  Extract the first frame from a video');
    return;
  }

  final command = arguments[0];

  if (command == 'install') {
    installFFmpeg();
  } else if (command == 'extract' && arguments.length == 3) {
    final inputPath = arguments[1];
    final outputPath = arguments[2];
    runFFmpegCommand(inputPath, outputPath).then((exitCode) {
      if (exitCode == 0) {
        log('Frame extracted successfully: $outputPath');
      } else {
        log('Failed to extract frame. Exit code: $exitCode');
      }
    });
  } else {
    log('Invalid command or arguments. Use "install" to install FFmpeg or "extract <input> <output>" to extract a frame.');
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

  log('Splash master setup successful');
}

Future<int> runFFmpegCommand(String inputPath, String outputPath) async {
  final List<String> args = [
    '-i',
    inputPath,
    '-vf',
    'select=eq(n\\,0)', // Escape backslash for the command
    '-q:v',
    '3',
    outputPath
  ];

  try {
    Process process = await Process.start('ffmpeg', args);

    process.stdout.transform(utf8.decoder).listen((data) {
      log('FFmpeg Output: $data');
    });

    process.stderr.transform(utf8.decoder).listen((data) {
      log('FFmpeg Error: $data');
    });

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
