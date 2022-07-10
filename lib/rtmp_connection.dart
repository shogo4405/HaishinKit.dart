import 'package:haishin_kit/haishin_kit_platform_interface.dart';
import 'package:haishin_kit/rtmp_connection_platform_interface.dart';

class RtmpConnection {
  static Future<RtmpConnection> create() async {
    var object = RtmpConnection._();
    object._memory = await HaishinKitPlatform.instance.newRtmpConnection();
    return object;
  }

  int? _memory;

  RtmpConnection._();

  int? get memory => _memory;

  void connect(String command) async {
    assert(_memory != null);
    final Map<String, dynamic> params = {"memory": _memory, "command": command};
    RtmpConnectionPlatform.instance.connect(params);
  }

  void close() async {
    assert(_memory != null);
    final Map<String, dynamic> params = {"memory": _memory};
    RtmpConnectionPlatform.instance.close(params);
  }
}
