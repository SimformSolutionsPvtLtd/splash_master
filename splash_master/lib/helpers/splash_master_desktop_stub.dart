/// Helper class for managing the splash screen on desktop platforms.
class SplashMasterDesktop {
  /// Removes the native splash screen on desktop platforms.
  ///
  /// Provide a [delay] to specify how long to wait before removing the splash screen.
  /// [macOS] if set to `true`, will remove the macOS splash screen.
  /// [windows] if set to `true`, will remove the Windows splash screen.
  /// By default, both [macOS] and [windows] are set to `true`, meaning the
  /// method will attempt to remove the splash screen on both platforms if applicable.
  static Future<void> removeSplash({
    Duration? delay,
    bool macOS = true,
    bool windows = true,
  }) async {}
}
