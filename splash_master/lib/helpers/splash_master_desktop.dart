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

  /// Removes the native splash screen on desktop platforms.
  ///
  /// Provide a [delay] to specify how long to wait before removing the splash screen.
  /// [macOS] if set to `true`, will remove the macOS splash screen.
  /// By default, [macOS] is set to `true`, meaning the method will attempt to
  /// remove the splash screen on macOS if applicable.
  static Future<void> removeSplash({
    Duration? delay,
    bool macOS = true,
  }) async {
    if (Platform.isMacOS && macOS) {
      delay != null
          ? await Future.delayed(delay, () async {
              await _macosChannel
                  .invokeMethod(MacosStrings.macosRemoveSplashMethodName);
            })
          : await _macosChannel
              .invokeMethod(MacosStrings.macosRemoveSplashMethodName);
    }
  }
}
