
import 'splash_screen_platform_interface.dart';

class SplashScreen {
  Future<String?> getPlatformVersion() {
    return SplashScreenPlatform.instance.getPlatformVersion();
  }
}
