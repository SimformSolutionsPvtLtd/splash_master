import 'package:splash_master/cmd/yaml_config/support_parameter.dart';
import 'package:splash_master/values/macos_strings.dart';
import 'package:splash_master/values/windows_strings.dart';

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
    this.brandingSpacing = MacosStrings.defaultBrandingSpacing,
    this.splashWindowWidth = MacosStrings.defaultSplashWindowWidth,
    this.splashWindowHeight = MacosStrings.defaultSplashWindowHeight,
    this.mainWindowWidth = MacosStrings.defaultMainWindowWidth,
    this.mainWindowHeight = MacosStrings.defaultMainWindowHeight,
    this.macosConfig = const MacosConfigDm(),
    this.windowsConfig = const WindowsConfigDm(),
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
  final WindowsConfigDm windowsConfig;
}

/// Data model representing macOS-specific configuration for the splash screen.
class MacosConfigDm {
  const MacosConfigDm({
    this.borderless = MacosStrings.defaultMacosBorderless,
  });

  final bool borderless;
}

/// Data model representing Windows-specific configuration for the splash screen.
class WindowsConfigDm {
  const WindowsConfigDm({
    this.borderless = WindowsStrings.defaultWindowsBorderless,
  });

  final bool borderless;
}
