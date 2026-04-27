import 'package:flutter/services.dart' show MethodChannel;
import 'package:splash_master/values/desktop_strings.dart';

/// Helper class for managing the splash screen on desktop platforms.
class DesktopSplashHelper {
  static const _channel =
      MethodChannel(DesktopStrings.macosSplashMethodChannelName);

  /// Removes the native splash screen on macOS.
  ///
  /// Provide a [delay] to specify how long to wait before removing the splash screen.
  static Future<void> removeMacosSplash({Duration? delay}) async {
    delay != null
        ? await Future.delayed(delay, () async {
            await _channel
                .invokeMethod(DesktopStrings.macosRemoveSplashMethodName);
          })
        : await _channel
            .invokeMethod(DesktopStrings.macosRemoveSplashMethodName);
  }
}
