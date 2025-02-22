import 'package:haishin_kit/rtmp_connection.dart';

import 'haishin_kit_platform_interface.dart';

class HaishinKit {
  Future<int?> newRtmpStream(RtmpConnection connection) {
    return HaishinKitPlatform.instance.newRtmpStream(connection);
  }

  Future<int?> newRtmpConnection() {
    return HaishinKitPlatform.instance.newRtmpConnection();
  }

  Future<String?> getPlatformVersion() {
    return HaishinKitPlatform.instance.getPlatformVersion();
  }
}
