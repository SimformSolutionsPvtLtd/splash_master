part of 'command_line.dart';

/// Generates Windows splash assets and splash metadata JSON used by the native
/// runner module.
Future<WindowsSplashAssetPathsDm> generateWindowsSplashAssets({
  String? image,
  String? imageDark,
  String? brandingImage,
  String? brandingImageDark,
  String? backgroundColor,
  String? backgroundColorDark,
  required DesktopConfigDm config,
}) async {
  final splashAssetsDir =
      Directory(WindowsStrings.windowsSplashResourcesDirectory);
  if (splashAssetsDir.existsSync()) {
    splashAssetsDir.deleteSync(recursive: true);
  }
  splashAssetsDir.createSync(recursive: true);

  final copiedImage = _copyWindowsSplashAsset(
    sourceAssetPath: image,
    baseFileName: WindowsStrings.splashLightAssetFileName,
  );
  final copiedImageDark = _copyWindowsSplashAsset(
    sourceAssetPath: imageDark,
    baseFileName: WindowsStrings.splashDarkAssetFileName,
  );
  final copiedBranding = _copyWindowsSplashAsset(
    sourceAssetPath: brandingImage,
    baseFileName: WindowsStrings.brandingLightAssetFileName,
  );
  final copiedBrandingDark = _copyWindowsSplashAsset(
    sourceAssetPath: brandingImageDark,
    baseFileName: WindowsStrings.brandingDarkAssetFileName,
  );

  final manifest = WindowsSplashAssetPathsDm(
    imageRelativePath: copiedImage,
    imageDarkRelativePath: copiedImageDark,
    brandingImageRelativePath: copiedBranding,
    brandingImageDarkRelativePath: copiedBrandingDark,
  );

  final jsonFile = File(WindowsStrings.windowsSplashConfigPath);
  final jsonContent = <String, dynamic>{
    WindowsStrings.version: 1,
    YamlKeys.imageKey: manifest.imageRelativePath,
    YamlKeys.imageDarkKey: manifest.imageDarkRelativePath,
    YamlKeys.brandingImageKey: manifest.brandingImageRelativePath,
    YamlKeys.brandingImageDarkKey: manifest.brandingImageDarkRelativePath,
    YamlKeys.colorKey: backgroundColor,
    YamlKeys.colorDarkKey: backgroundColorDark,
    YamlKeys.imageFitKey: config.imageFit.name,
    YamlKeys.imagePositionKey: config.imagePosition.name,
    YamlKeys.brandingImagePositionKey: config.brandingPosition.name,
    YamlKeys.brandingImageSpacingKey: config.brandingSpacing,
    YamlKeys.splashWindowWidthKey: config.splashWindowWidth,
    YamlKeys.splashWindowHeightKey: config.splashWindowHeight,
    YamlKeys.mainWindowWidthKey: config.mainWindowWidth,
    YamlKeys.mainWindowHeightKey: config.mainWindowHeight,
    YamlKeys.borderlessKey: config.borderless,
    YamlKeys.animationDurationKey: config.windowsConfig.animationDurationMs,
    YamlKeys.dismissAnimationKey: config.windowsConfig.dismissAnimation,
  };
  await jsonFile
      .writeAsString(JsonEncoder.withIndent('  ').convert(jsonContent));
  log('Windows splash config JSON written to ${WindowsStrings.windowsSplashConfigPath}.');
  return manifest;
}

/// Generates native Windows splash module files and wires the Windows runner.
Future<void> generateWindowsSplashNativeIntegration() async {
  await File(WindowsStrings.windowsSplashHeaderPath)
      .writeAsString(WindowsStrings.buildWindowsSplashHeaderContent);
  log('${WindowsStrings.windowsSplashHeaderFileName} written.');
  await File(WindowsStrings.windowsSplashSourcePath)
      .writeAsString(WindowsStrings.buildWindowsSplashSourceContent);
  log('${WindowsStrings.windowsSplashSourceFileName} written.');

  await _updateWindowsRunnerCmake();
  await _updateWindowsMainCpp();
  await _updateWindowsFlutterWindowHeader();
  await _updateWindowsFlutterWindowCpp();
}

String? _copyWindowsSplashAsset({
  required String? sourceAssetPath,
  required String baseFileName,
}) {
  if (sourceAssetPath.isNullOrBlank) return null;

  final source = File(sourceAssetPath!);
  if (!source.existsSync()) {
    throw SplashMasterException(
      message: '[Error] Windows splash asset not found: $sourceAssetPath',
    );
  }

  final extension = sourceAssetPath.split('.').last.toLowerCase();
  final destination = File(
    '${WindowsStrings.windowsSplashResourcesDirectory}/$baseFileName.$extension',
  );
  source.copySync(destination.path);
  log('Copied $baseFileName asset to ${destination.path}.');
  return '${WindowsStrings.resources}/${WindowsStrings.splashMaster}/${destination.uri.pathSegments.last}';
}

Future<void> _updateWindowsRunnerCmake() async {
  final file = File(WindowsStrings.runnerCmakePath);
  if (!file.existsSync()) {
    log('[Warning] ${WindowsStrings.runnerCmakePath} not found.');
    return;
  }

  var content = (await file.readAsString()).replaceAll('\r\n', '\n');
  var modified = false;

  // 1. Wire splash source file into add_executable (idempotent).
  if (!content.contains('"${WindowsStrings.windowsSplashSourceFileName}"')) {
    final anchor = '  "${WindowsStrings.flutterWindowCpp}"\n';
    if (content.contains(anchor)) {
      content = content.replaceFirst(
        anchor,
        '$anchor  "${WindowsStrings.windowsSplashSourceFileName}"\n',
      );
      modified = true;
    } else {
      log('[Warning] Unable to wire Windows splash source in CMakeLists.txt.');
    }
  }

  // 2. Add post-build command to copy splash resources to the EXE directory.
  if (!content.contains(WindowsStrings.generatedCodeBeginMarkerCmake)) {
    content = '${content.trimRight()}\n${WindowsStrings.resourceCopyBlock}';
    modified = true;
  }

  if (modified) {
    await file.writeAsString(content);
    log('CMakeLists.txt updated for Windows splash.');
  } else {
    log('CMakeLists.txt already up to date.');
  }
}

Future<void> _updateWindowsMainCpp() async {
  final file = File(WindowsStrings.mainCppPath);
  if (!file.existsSync()) {
    log('[Warning] ${WindowsStrings.mainCppPath} not found.');
    return;
  }

  var content = (await file.readAsString()).replaceAll('\r\n', '\n');
  if (!content.contains(WindowsStrings.slashMasterHInclude)) {
    content = content.replaceFirst(
      WindowsStrings.flutterWindowHInclude,
      WindowsStrings.flutterWindowHWithSplashInclude,
    );
  }

  final generatedBlock = '${WindowsStrings.generatedCodeBeginMarker}\n'
      '  unsigned int splash_width = ${DesktopStrings.defaultSplashWindowWidth};\n'
      '  unsigned int splash_height = ${DesktopStrings.defaultSplashWindowHeight};\n'
      '  GetSplashMasterInitialWindowSize(&splash_width, &splash_height);\n'
      '  Win32Window::Size size(splash_width, splash_height);\n'
      '${WindowsStrings.generatedCodeEndMarker}';

  final beginIndex = content.indexOf(WindowsStrings.generatedCodeBeginMarker);
  final endIndex = content.indexOf(WindowsStrings.generatedCodeEndMarker);
  if (beginIndex != -1 && endIndex != -1 && endIndex > beginIndex) {
    // Idempotent re-run: replace the existing generated block.
    content = content.substring(0, beginIndex) +
        generatedBlock +
        content
            .substring(endIndex + WindowsStrings.generatedCodeEndMarker.length);
  } else {
    // Fresh project: match Win32Window::Size size(...) regardless of values.
    final sizeLineRegex = RegExp(r'  Win32Window::Size size\(\d+, \d+\);');
    if (sizeLineRegex.hasMatch(content)) {
      content = content.replaceFirst(sizeLineRegex, generatedBlock);
    } else {
      log('[Warning] Unable to inject splash window size in '
          '${WindowsStrings.mainCppPath}. Add the following block manually '
          'before window.Create():\n$generatedBlock');
    }
  }

  await file.writeAsString(content);
  log('${WindowsStrings.mainCppPath} updated for Windows splash.');
}

Future<void> _updateWindowsFlutterWindowHeader() async {
  final file = File(WindowsStrings.flutterWindowHeaderPath);
  if (!file.existsSync()) {
    log('[Warning] ${WindowsStrings.flutterWindowHeaderPath} not found.');
    return;
  }

  var content = (await file.readAsString()).replaceAll('\r\n', '\n');
  if (!content.contains(WindowsStrings.splashControllerForwardDecl)) {
    content = content.replaceFirst(
      WindowsStrings.win32WindowHInclude,
      WindowsStrings.win32WindowHWithSplashForwardDecls,
    );
  }

  if (!content.contains(WindowsStrings.generatedCodeBeginMarker)) {
    const anchor = WindowsStrings.flutterViewControllerMemberDecl;
    if (content.contains(anchor)) {
      content = content.replaceFirst(
          anchor, '$anchor${WindowsStrings.headerGeneratedMembers}');
    } else {
      log('[Warning] Unable to wire splash members in flutter_window.h.');
    }
  }

  await file.writeAsString(content);
  log('${WindowsStrings.flutterWindowHeaderPath} updated for Windows splash.');
}

Future<void> _updateWindowsFlutterWindowCpp() async {
  final file = File(WindowsStrings.flutterWindowCppPath);
  if (!file.existsSync()) {
    log('[Warning] ${WindowsStrings.flutterWindowCppPath} not found.');
    return;
  }

  var content = (await file.readAsString()).replaceAll('\r\n', '\n');
  if (!content.contains(WindowsStrings.slashMasterHInclude)) {
    content = content.replaceFirst(
      WindowsStrings.flutterWindowHInclude,
      WindowsStrings.flutterWindowHWithSplashInclude,
    );
  }

  if (!content.contains(WindowsStrings.methodChannelInclude)) {
    content = content.replaceFirst(
      WindowsStrings.optionalInclude,
      WindowsStrings.optionalWithChannelIncludes,
    );
  }

  if (content.contains(WindowsStrings.onCreateBlock)) {
    content = content.replaceFirst(
      WindowsStrings.onCreateBlock,
      WindowsStrings.updatedOnCreateBlock,
    );
  } else if (!content.contains(WindowsStrings.generatedCodeBeginMarker)) {
    log('[Warning] Unable to wire splash logic in flutter_window.cpp OnCreate.');
  }

  if (content.contains(WindowsStrings.onDestroyBlock)) {
    content = content.replaceFirst(
      WindowsStrings.onDestroyBlock,
      WindowsStrings.updatedOnDestroyBlock,
    );
  }

  await file.writeAsString(content);
  log('${WindowsStrings.flutterWindowCppPath} updated for Windows splash.');
}
