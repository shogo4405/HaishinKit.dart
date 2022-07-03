import 'package:haishin_kit/rtmp_connection_platform_interface.dart';

class RtmpConnection {
  static Future<RtmpConnection> create() async {
    var object = RtmpConnection._();
    object._memory = await RtmpConnectionPlatform.instance.create();
    return object;
  }

  double? _memory;

  RtmpConnection._();

  double? get memory => _memory;

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
