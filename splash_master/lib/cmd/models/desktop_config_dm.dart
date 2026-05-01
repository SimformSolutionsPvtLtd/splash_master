import 'package:splash_master/cmd/yaml_config/support_parameter.dart';
import 'package:splash_master/values/desktop_strings.dart';
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
    this.brandingSpacing = DesktopStrings.defaultBrandingSpacing,
    this.splashWindowWidth = DesktopStrings.defaultSplashWindowWidth,
    this.splashWindowHeight = DesktopStrings.defaultSplashWindowHeight,
    this.mainWindowWidth = DesktopStrings.defaultMainWindowWidth,
    this.mainWindowHeight = DesktopStrings.defaultMainWindowHeight,
    this.borderless = DesktopStrings.defaultBorderless,
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
  final bool borderless;
  final WindowsConfigDm windowsConfig;
}

/// Data model representing Windows-specific keys for the splash screen.
class WindowsConfigDm {
  const WindowsConfigDm({
    this.animationDurationMs = WindowsStrings.defaultAnimationDurationMs,
    this.dismissAnimation = WindowsStrings.defaultDismissAnimation,
  });

  final int animationDurationMs;
  final String dismissAnimation;
}
