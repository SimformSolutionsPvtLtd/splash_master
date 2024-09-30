
import 'splash_master_platform_interface.dart';

class SplashMaster {
  Future<String?> getPlatformVersion() {
    return SplashMasterPlatform.instance.getPlatformVersion();
  }
}
