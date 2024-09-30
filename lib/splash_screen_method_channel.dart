import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'splash_screen_platform_interface.dart';

/// An implementation of [SplashScreenPlatform] that uses method channels.
class MethodChannelSplashScreen extends SplashScreenPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('splash_screen');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
