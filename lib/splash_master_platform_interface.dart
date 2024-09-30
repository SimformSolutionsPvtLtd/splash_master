import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'splash_master_method_channel.dart';

abstract class SplashMasterPlatform extends PlatformInterface {
  /// Constructs a SplashMasterPlatform.
  SplashMasterPlatform() : super(token: _token);

  static final Object _token = Object();

  static SplashMasterPlatform _instance = MethodChannelSplashMaster();

  /// The default instance of [SplashMasterPlatform] to use.
  ///
  /// Defaults to [MethodChannelSplashMaster].
  static SplashMasterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SplashMasterPlatform] when
  /// they register themselves.
  static set instance(SplashMasterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
