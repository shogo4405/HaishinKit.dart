import 'haishin_kit_platform_interface.dart';

class HaishinKit {
  Future<String?> getVersion() {
    return HaishinKitPlatform.instance.getVersion();
  }
}
