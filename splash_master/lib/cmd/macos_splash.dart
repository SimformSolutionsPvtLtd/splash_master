part of 'command_line.dart';

/// Generates macOS splash assets in Assets.xcassets.
///
/// [image] and [imageDark] are used for SplashImage.imageset.
/// [brandingImage] and [brandingImageDark] are used for BrandingImage.imageset.
/// [backgroundColor] and [backgroundColorDark] are used for color sets.
Future<void> generateMacosSplashAssets({
  String? image,
  String? imageDark,
  String? brandingImage,
  String? brandingImageDark,
  String? backgroundColor,
  String? backgroundColorDark,
}) async {
  // Warn if only dark image is provided for splash or branding
  if (image == null && imageDark != null) {
    log('[macOS] Warning: Light splash image is missing. Dark splash image will be used for both.');
  }
  if (brandingImage == null && brandingImageDark != null) {
    log('[macOS] Warning: Light branding image is missing. Dark branding image will be used for both.');
  }
  if (backgroundColor == null && backgroundColorDark != null) {
    log('[macOS] Warning: Light background color is missing. Dark color will be used for both.');
  }

  // Generate SplashImage.imageset if provided, otherwise delete any existing
  if (image != null || imageDark != null)
    await createImageset(
      imagesetName: DesktopStrings.splashImageAssetName,
      lightImage: image,
      darkImage: imageDark,
    );
  else {
    _deleteStaleAssetDir(
      assetPath:
          '${DesktopStrings.xcassetsDirPath}/${DesktopStrings.splashImageAssetName}${DesktopStrings.imagesetExtension}',
      label: DesktopStrings.splashImageAssetName,
    );
  }
  // Generate BrandingImage.imageset if provided, otherwise delete any existing
  if (brandingImage != null || brandingImageDark != null)
    await createImageset(
      imagesetName: DesktopStrings.brandingImageAssetName,
      lightImage: brandingImage,
      darkImage: brandingImageDark,
    );
  else
    _deleteStaleAssetDir(
      assetPath:
          '${DesktopStrings.xcassetsDirPath}/${DesktopStrings.brandingImageAssetName}${DesktopStrings.imagesetExtension}',
      label: DesktopStrings.brandingImageAssetName,
    );
  // Generate color set if any color is provided, otherwise delete any existing
  if (backgroundColor != null || backgroundColorDark != null) {
    await createColorset(
      colorsetName: DesktopStrings.splashBackgroundColorAssetName,
      lightColor: backgroundColor,
      darkColor: backgroundColorDark,
    );
  } else
    _deleteStaleAssetDir(
      assetPath:
          '${DesktopStrings.xcassetsDirPath}/${DesktopStrings.splashBackgroundColorAssetName}${DesktopStrings.colorsetExtension}',
      label: DesktopStrings.splashBackgroundColorAssetName,
    );
}

/// Deletes an asset directory (imageset/colorset) if it exists but is no longer needed.
void _deleteStaleAssetDir({
  required String assetPath,
  required String label,
}) {
  final dir = Directory(assetPath);
  if (dir.existsSync()) {
    dir.deleteSync(recursive: true);
  }
}

/// Creates an .imageset directory for splash or branding images.
///
/// The correct set of filenames is chosen based on [imagesetName].
/// All 1x, 2x, and 3x images are generated using the same source file for each variant.
///
/// Before copying, any existing splash/branding image files in the imageset directory are deleted
/// to prevent leftover or incorrect files from previous runs.
Future<void> createImageset({
  required String imagesetName,
  String? lightImage,
  String? darkImage,
}) async {
  final imagesetDir = Directory(
      '${DesktopStrings.xcassetsDirPath}/$imagesetName${DesktopStrings.imagesetExtension}');
  if (!imagesetDir.existsSync()) {
    imagesetDir.createSync(recursive: true);
  }

  // Explicitly select correct filenames for splash or branding imageset
  late final String light1x, light2x, light3x, dark1x, dark2x, dark3x;
  if (imagesetName == DesktopStrings.splashImageAssetName) {
    // Use splash image filenames
    light1x = DesktopStrings.splashImage1x;
    light2x = DesktopStrings.splashImage2x;
    light3x = DesktopStrings.splashImage3x;
    dark1x = DesktopStrings.splashImageDark1x;
    dark2x = DesktopStrings.splashImageDark2x;
    dark3x = DesktopStrings.splashImageDark3x;
  } else if (imagesetName == DesktopStrings.brandingImageAssetName) {
    // Use branding image filenames
    light1x = DesktopStrings.brandingImage1x;
    light2x = DesktopStrings.brandingImage2x;
    light3x = DesktopStrings.brandingImage3x;
    dark1x = DesktopStrings.brandingImageDark1x;
    dark2x = DesktopStrings.brandingImageDark2x;
    dark3x = DesktopStrings.brandingImageDark3x;
  } else {
    throw Exception('Unknown imagesetName: $imagesetName');
  }

  final images = <MacosImage>[];

  // If only dark is provided, use it as the light fallback too
  final effectiveLightImage = lightImage ?? darkImage;
  // Copy and register light images (all scales use the same file)
  if (effectiveLightImage != null) {
    final dest1x = File('${imagesetDir.path}/$light1x');
    final dest2x = File('${imagesetDir.path}/$light2x');
    final dest3x = File('${imagesetDir.path}/$light3x');
    File(effectiveLightImage).copySync(dest1x.path);
    File(effectiveLightImage).copySync(dest2x.path);
    File(effectiveLightImage).copySync(dest3x.path);
    images.addAll([
      MacosImage(
          idiom: DesktopStrings.idiomUniversal,
          filename: light1x,
          scale: DesktopStrings.scale1x),
      MacosImage(
          idiom: DesktopStrings.idiomUniversal,
          filename: light2x,
          scale: DesktopStrings.scale2x),
      MacosImage(
          idiom: DesktopStrings.idiomUniversal,
          filename: light3x,
          scale: DesktopStrings.scale3x),
    ]);
  }
  // Copy and register dark images (all scales use the same file)
  if (darkImage != null) {
    final dest1x = File('${imagesetDir.path}/$dark1x');
    final dest2x = File('${imagesetDir.path}/$dark2x');
    final dest3x = File('${imagesetDir.path}/$dark3x');
    File(darkImage).copySync(dest1x.path);
    File(darkImage).copySync(dest2x.path);
    File(darkImage).copySync(dest3x.path);
    final darkAppearance = [
      {
        DesktopStrings.appearanceKey: DesktopStrings.appearanceLuminosity,
        DesktopStrings.valueKey: DesktopStrings.appearanceDark,
      }
    ];
    images.addAll([
      MacosImage(
          idiom: DesktopStrings.idiomUniversal,
          filename: dark1x,
          scale: DesktopStrings.scale1x,
          appearances: darkAppearance),
      MacosImage(
          idiom: DesktopStrings.idiomUniversal,
          filename: dark2x,
          scale: DesktopStrings.scale2x,
          appearances: darkAppearance),
      MacosImage(
          idiom: DesktopStrings.idiomUniversal,
          filename: dark3x,
          scale: DesktopStrings.scale3x,
          appearances: darkAppearance),
    ]);
  }
  // Write Contents.json for the imageset
  final contents = MacosContentJson(
    images: images,
    info: MacosInfo(
        version: DesktopStrings.assetCatalogVersion,
        author: DesktopStrings.assetCatalogAuthor),
  );
  final contentsFile =
      File('${imagesetDir.path}/${DesktopStrings.contentsJsonFileName}');
  contentsFile.writeAsStringSync(
      JsonEncoder.withIndent('  ').convert(contents.toJson()));
  log('[macOS] Created $imagesetName.imageset with ${images.length} image(s)');
}

/// Creates a .colorset directory for splash background color.
///
/// Supports both light and dark mode colors.
Future<void> createColorset({
  required String colorsetName,
  String? lightColor,
  String? darkColor,
}) async {
  final colorsetDir = Directory(
      '${DesktopStrings.xcassetsDirPath}/$colorsetName${DesktopStrings.colorsetExtension}');
  if (!colorsetDir.existsSync()) {
    colorsetDir.createSync(recursive: true);
  }

  final colors = <MacosColor>[];

  if (lightColor != null) {
    colors.add(MacosColor(
      idiom: DesktopStrings.idiomUniversal,
      color: _colorToComponentsModel(lightColor),
    ));
  }
  if (darkColor != null) {
    colors.add(MacosColor(
      idiom: DesktopStrings.idiomUniversal,
      appearances: [
        {
          DesktopStrings.appearanceKey: DesktopStrings.appearanceLuminosity,
          DesktopStrings.valueKey: DesktopStrings.appearanceDark
        }
      ],
      color: _colorToComponentsModel(darkColor),
    ));
  }
  // Write Contents.json for the colorset
  final contents = MacosContentJson(
    images: [],
    info: MacosInfo(
        version: DesktopStrings.assetCatalogVersion,
        author: DesktopStrings.assetCatalogAuthor),
    colors: colors,
  );
  final contentsFile =
      File('${colorsetDir.path}/${DesktopStrings.contentsJsonFileName}');
  contentsFile.writeAsStringSync(
      JsonEncoder.withIndent('  ').convert(contents.toJson()));
  log('[macOS] Created $colorsetName.colorset with ${colors.length} color(s)');
}

/// Converts a hex color string (#RRGGBB or #AARRGGBB) to MacosColorComponents.
MacosColorComponents _colorToComponentsModel(String hex) {
  // Accepts #RRGGBB or #AARRGGBB
  final cleaned = hex.replaceAll('#', '');
  final r = int.parse(
          cleaned.length == 8
              ? cleaned.substring(2, 4)
              : cleaned.substring(0, 2),
          radix: 16) /
      255.0;
  final g = int.parse(
          cleaned.length == 8
              ? cleaned.substring(4, 6)
              : cleaned.substring(2, 4),
          radix: 16) /
      255.0;
  final b = int.parse(
          cleaned.length == 8
              ? cleaned.substring(6, 8)
              : cleaned.substring(4, 6),
          radix: 16) /
      255.0;
  final a = cleaned.length == 8
      ? int.parse(cleaned.substring(0, 2), radix: 16) / 255.0
      : 1.0;
  return MacosColorComponents(
    colorSpace: DesktopStrings.colorSpaceSRGB,
    red: r.toStringAsFixed(3),
    green: g.toStringAsFixed(3),
    blue: b.toStringAsFixed(3),
    alpha: a.toStringAsFixed(3),
  );
}

/// Reads the existing MainFlutterWindow.swift, splices in (or replaces) the
/// generated splash region, and writes the file back — leaving any user code
/// outside the markers untouched.
Future<void> generateMainFlutterWindowFile(DesktopConfigDm config) async {
  final file = File(DesktopStrings.mainFlutterWindowFilePath);
  if (!file.existsSync()) {
    log('Could not find MainFlutterWindow.swift at ${DesktopStrings.mainFlutterWindowFilePath}');
    return;
  }

  final original = await file.readAsString();
  final updated = _spliceGeneratedBlock(original, config);
  await file.writeAsString(updated);
  log('MainFlutterWindow.swift updated successfully.');
}

/// Core splice logic — separated for testability.
String _spliceGeneratedBlock(String original, DesktopConfigDm config) {
  final generatedBlock = _buildGeneratedBlock(config);

  final begin = original.indexOf(DesktopStrings.kBeginMarker);
  final end = original.indexOf(DesktopStrings.kEndMarker);

  // ── Re-run: markers already present — replace the region verbatim. ────────
  if (begin != -1 && end != -1 && end > begin) {
    return original.substring(0, begin) +
        generatedBlock +
        original.substring(end + DesktopStrings.kEndMarker.length);
  }

  // ── First run: no markers yet. ────────────────────────────────────────────
  // Strategy:
  //   1. Remove the default awakeFromNib Flutter generates (we replace it).
  //   2. Inject the generated block just before the final closing brace.
  final withoutDefaultAwake = _removeDefaultAwakeFromNib(original);
  final lastBrace =
      withoutDefaultAwake.lastIndexOf(DesktopStrings.closingBracket);

  if (lastBrace == -1) {
    // Malformed file — build from scratch.
    return _buildFullScaffold(generatedBlock);
  }

  return withoutDefaultAwake.substring(0, lastBrace) +
      '\n$generatedBlock\n' +
      withoutDefaultAwake.substring(lastBrace);
}

/// Removes the boilerplate awakeFromNib that Flutter generates so we can
/// replace it with our own. Matches the entire override func block.
String _removeDefaultAwakeFromNib(String source) {
  final pattern = RegExp(
    r'\s*override func awakeFromNib\(\)[\s\S]*?\n[ \t]*\}',
    multiLine: true,
  );
  return source.replaceFirst(pattern, DesktopStrings.kEmptyString);
}

/// Builds the sentinel-wrapped generated region.
String _buildGeneratedBlock(DesktopConfigDm config) {
  final hasSplash = config.hasSplashImage;
  final hasBranding = config.hasBrandingImage;

  if (!hasSplash && !hasBranding) return _buildMinimalBlock(config);

  final splashImageSetup = hasSplash
      ? '${DesktopStrings.splashImageTemplate}\n'
          '    ${config.imageFit.toMacosScalingLine}\n'
          '    ${DesktopStrings.addSubviewTemplate}'
      : DesktopStrings.kEmptyString;

  final brandingSetup = hasBranding
      ? DesktopStrings.brandingImageTemplate
      : DesktopStrings.kEmptyString;

  final constraints = _buildConstraints(config, hasSplash, hasBranding);

  // TitleBar visibility lines are conditional on the borderless flag.
  final removeTitleBarFromSplashWindow = config.macosConfig.borderless
      ? DesktopStrings.borderlessOnTemplate
      : DesktopStrings.kEmptyString;

  final addTitleBarToMainWindow = config.macosConfig.borderless
      ? DesktopStrings.borderlessOffTemplate
      : DesktopStrings.kEmptyString;

  return '${DesktopStrings.kBeginMarker}\n'
      '  // MARK: - Splash (generated by SplashMaster — do not edit between markers)\n'
      '\n'
      '  private let _splashSize = NSSize(width: ${config.splashWindowWidth}, height: ${config.splashWindowHeight})\n'
      '  private let _mainSize   = NSSize(width: ${config.mainWindowWidth}, height: ${config.mainWindowHeight})\n'
      '\n'
      '  private var _splashContainer: NSView?\n'
      '\n'
      '${DesktopStrings.awakeFromNibSplashTemplate}'
      '\n'
      '${DesktopStrings.addSplashViewOpeningTemplate}'
      '$splashImageSetup\n'
      '$brandingSetup\n'
      '\n'
      '    NSLayoutConstraint.activate([\n'
      '$constraints'
      '\n    ])'
      '\n'
      '${DesktopStrings.addSplashViewClosingTemplate}'
      '$removeTitleBarFromSplashWindow'
      '  }\n'
      '\n'
      '${DesktopStrings.removeSplashTemplate}'
      '$addTitleBarToMainWindow'
      '  }\n'
      '${DesktopStrings.kEndMarker}';
}

/// Minimal block: no splash/branding images — only window sizing.
String _buildMinimalBlock(DesktopConfigDm config) =>
    '${DesktopStrings.kBeginMarker}\n'
    '  // MARK: - Window sizing (generated by SplashMaster — do not edit between markers)\n'
    '\n'
    '  private let _mainSize = NSSize(width: ${config.mainWindowWidth}, height: ${config.mainWindowHeight})\n'
    '\n'
    '${DesktopStrings.awakeFromNibWithoutSplashTemplate}'
    '\n'
    '${DesktopStrings.kEndMarker}';

/// Scaffold written only when the file does not exist at all.
String _buildFullScaffold(String generatedBlock) =>
    '${DesktopStrings.mainFileScaffoldTemplate}'
    '$generatedBlock\n'
    '${DesktopStrings.closingBracket}\n';

/// Assembles the NSLayoutConstraint lines in one place.
String _buildConstraints(
  DesktopConfigDm config,
  bool hasSplash,
  bool hasBranding,
) {
  final buffer = StringBuffer();

  if (hasSplash) {
    buffer.writeln('${config.imagePosition.toMacosXPosition}');
    buffer.writeln('${config.imagePosition.toMacosYPosition}');

    final dimConstraints = config.imageFit.toMacosDimensionConstraints;
    if (dimConstraints.isNotNullOrBlank) buffer.writeln(dimConstraints);
  }

  if (hasBranding) {
    buffer.write(
        config.brandingPosition.macosConstraints(config.brandingSpacing));
  }

  return buffer.toString();
}

/// Modifies AppDelegate.swift to add a MethodChannel for controlling
/// the splash screen from Dart code.
Future<void> addSplashChannelToAppDelegate() async {
  final file = File(DesktopStrings.appDelegateFilePath);
  if (!file.existsSync()) {
    log('AppDelegate.swift not found at ${DesktopStrings.appDelegateFilePath}');
    return;
  }

  String content = await file.readAsString();

  if (content.contains('"${DesktopStrings.macosSplashMethodChannelName}"')) {
    log('Splash channel already present, skipping.');
    return;
  }

  // Check if the override already exists
  if (content
      .contains(DesktopStrings.applicationDidFinishLaunchingMethodSignature)) {
    // Case 1: Insert innerCode inside the existing function
    const superCall = DesktopStrings.applicationDidFinishLaunchingSuperCall;

    if (!content.contains(superCall)) {
      log('Manual edit required: super call not found.');
      return;
    }

    content = content.replaceFirst(superCall,
        '${DesktopStrings.macosMethodChannelTemplate}\n    $superCall');
  } else {
    // Case 2: Insert full function before the last closing brace of the class
    content = content.replaceLastOccurrence(
        DesktopStrings.closingBracket,
        '${DesktopStrings.applicationDidFinishLaunchingFunctionTemplate}\n'
        '${DesktopStrings.closingBracket}');
  }

  await file.writeAsString(content);
}
