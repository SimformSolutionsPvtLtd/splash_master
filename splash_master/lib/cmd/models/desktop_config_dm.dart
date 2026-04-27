import 'package:splash_master/cmd/yaml_config/support_parameter.dart';
import 'package:splash_master/values/desktop_strings.dart';

/// Data model representing the desktop configuration for the splash screen.
class DesktopConfigDm {
  const DesktopConfigDm({
    required this.hasSplashImage,
    required this.hasBrandingImage,
    this.splashColor,
    this.splashColorDark,
    this.imageFit = DesktopImageFit.contain,
    this.imagePosition = DesktopImagePosition.center,
    this.brandingPosition = DesktopBrandingPosition.bottomCenter,
    this.brandingSpacing = DesktopStrings.defaultBrandingSpacing,
    this.splashWindowWidth = DesktopStrings.defaultSplashWindowWidth,
    this.splashWindowHeight = DesktopStrings.defaultSplashWindowHeight,
    this.mainWindowWidth = DesktopStrings.defaultMainWindowWidth,
    this.mainWindowHeight = DesktopStrings.defaultMainWindowHeight,
    this.macosConfig = const MacosConfigDm(),
  });

  final String? splashColor;
  final String? splashColorDark;
  final bool hasSplashImage;
  final bool hasBrandingImage;
  final DesktopImageFit imageFit;
  final DesktopImagePosition imagePosition;
  final DesktopBrandingPosition brandingPosition;
  final int brandingSpacing;
  final int splashWindowWidth;
  final int splashWindowHeight;
  final int mainWindowWidth;
  final int mainWindowHeight;
  final MacosConfigDm macosConfig;
}

/// Data model representing macOS-specific configuration for the splash screen.
class MacosConfigDm {
  const MacosConfigDm({
    this.borderless = DesktopStrings.defaultMacosBorderless,
  });

  final bool borderless;
}
