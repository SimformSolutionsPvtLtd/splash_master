import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'splash_master_platform_interface.dart';

/// An implementation of [SplashMasterPlatform] that uses method channels.
class MethodChannelSplashMaster extends SplashMasterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('splash_master');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
