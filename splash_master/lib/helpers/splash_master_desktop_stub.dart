/// Helper class for managing the splash screen on desktop platforms.
class SplashMasterDesktop {
  /// Removes the native splash screen on desktop platforms.
  ///
  /// Provide a [delay] to specify how long to wait before removing the splash screen.
  /// [macOS] if set to `true`, will remove the macOS splash screen.
  /// By default, [macOS] is set to `true`, meaning the method will
  /// attempt to remove the splash screen on macOS if applicable.
  static Future<void> removeSplash({
    Duration? delay,
    bool macOS = true,
  }) async {}
}
