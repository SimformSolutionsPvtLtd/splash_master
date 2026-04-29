abstract final class WindowsStrings {
  static const String kEmptyString = '';
  static const String closingBracket = '}';

  /// Windows paths
  static const String windows = 'windows';

  /// Method channel names and method names for communicating with native Windows code.
  static const String windowsSplashMethodChannelName = 'windows_splash';
  static const String windowsRemoveSplashMethodName = 'removeSplash';

  /// Defaults for desktop splash window/layout behavior (Windows)
  static const String imagePositionDefaultValue = 'center';
  static const String imageFitDefaultValue = 'contain';
  static const String brandingPositionDefaultValue = 'bottomCenter';
  static const int defaultBrandingSpacing = 24;
  static const int defaultSplashWindowWidth = 600;
  static const int defaultSplashWindowHeight = 600;
  static const int defaultMainWindowWidth = 1280;
  static const int defaultMainWindowHeight = 720;
  static const bool defaultWindowsBorderless = false;
}
