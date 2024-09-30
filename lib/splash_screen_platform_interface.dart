import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'splash_screen_method_channel.dart';

abstract class SplashScreenPlatform extends PlatformInterface {
  /// Constructs a SplashScreenPlatform.
  SplashScreenPlatform() : super(token: _token);

  static final Object _token = Object();

  static SplashScreenPlatform _instance = MethodChannelSplashScreen();

  /// The default instance of [SplashScreenPlatform] to use.
  ///
  /// Defaults to [MethodChannelSplashScreen].
  static SplashScreenPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SplashScreenPlatform] when
  /// they register themselves.
  static set instance(SplashScreenPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
