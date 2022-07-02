
import 'haishin_kit_platform_interface.dart';

class HaishinKit {
  Future<String?> getPlatformVersion() {
    return HaishinKitPlatform.instance.getPlatformVersion();
  }
}
