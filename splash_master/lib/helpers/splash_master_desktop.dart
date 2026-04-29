import 'dart:io';

import 'package:flutter/services.dart' show MethodChannel;
import 'package:splash_master/splash_master.dart';

/// Helper class for managing the splash screen on desktop platforms.
class SplashMasterDesktop {
  /// Private constructor to prevent instantiation of the class.
  SplashMasterDesktop._();

  /// Method channel for communicating with the native macOS code to manage the splash screen.
  static const _macosChannel =
      MethodChannel(MacosStrings.macosSplashMethodChannelName);

  /// Method channel for communicating with the native Windows code to manage the splash screen.
  static const MethodChannel _windowsChannel =
      MethodChannel(WindowsStrings.windowsSplashMethodChannelName);

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
  }) async {
    if (Platform.isMacOS && macOS) {
      delay != null
          ? await Future.delayed(delay, () async {
              await _macosChannel
                  .invokeMethod(MacosStrings.macosRemoveSplashMethodName);
            })
          : await _macosChannel
              .invokeMethod(MacosStrings.macosRemoveSplashMethodName);
    } else if (Platform.isWindows && windows) {
      delay != null
          ? await Future.delayed(delay, () async {
              await _windowsChannel
                  .invokeMethod(WindowsStrings.windowsRemoveSplashMethodName);
            })
          : await _windowsChannel
              .invokeMethod(WindowsStrings.windowsRemoveSplashMethodName);
    }
    // TODO(Lavi)- Add Linux support when needed.
  }
}
