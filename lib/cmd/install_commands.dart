part of 'command_line.dart';

Future<void> initialSetup() async {
  await installFFmpeg();
  await lottieSetup();
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

Future<void> lottieSetup() async {
  final isNpmInstalled = await installNpm();
  if (isNpmInstalled) {
    final isPuppeteerInstalled = await installPuppeteer();
    if (isPuppeteerInstalled) {
      await installPuppeteerLottie();
    }
  }
}

Future<bool> installNpm() async {
  log('Installing npm...');

  if (Platform.isMacOS) {
    await runCommand('brew', ['install', 'node']);
  } else if (Platform.isLinux) {
    await runCommand('sudo', ['apt', 'update']);
    await runCommand('sudo', ['apt', 'install', '-y', 'nodejs']);
    await runCommand('sudo', ['apt', 'install', '-y', 'npm']);
  } else if (Platform.isWindows) {
    log("Please manually install Node.js (which includes npm) for Windows from https://nodejs.org/en/download/");
    return false;
  } else {
    log('Unsupported platform for installation.');
    return false;
  }

  log('npm installation complete.');
  return true;
}

Future<bool> installPuppeteer() async {
  log('Installing Puppeteer...');

  if (Platform.isMacOS || Platform.isLinux) {
    await runCommand('npm', ['install', '-g', 'puppeteer']);
  } else if (Platform.isWindows) {
    log("Please manually install Node.js (which includes npm) and Puppeteer for Windows from:");
    log("Node.js: https://nodejs.org/en/download/");
    log("Puppeteer: Run `npm install -g puppeteer` after installing Node.js.");
    return false;
  } else {
    log('Unsupported platform for installation.');
    return false;
  }

  log('Puppeteer installation complete.');
  return true;
}

Future<void> installPuppeteerLottie() async {
  log('Installing Puppeteer-Lottie...');

  if (Platform.isMacOS || Platform.isLinux) {
    await runCommand('npm', ['install', '-g', 'puppeteer-lottie']);
  } else if (Platform.isWindows) {
    log("Please manually install Node.js (which includes npm) and Puppeteer-Lottie for Windows from:");
    log("Node.js: https://nodejs.org/en/download/");
    log("Puppeteer-Lottie: Run `npm install -g puppeteer puppeteer-lottie` after installing Node.js.");
    return;
  } else {
    log('Unsupported platform for installation.');
    return;
  }

  log('Puppeteer-Lottie installation complete.');
}
