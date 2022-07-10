import 'package:flutter/services.dart';
import 'package:haishin_kit/haishin_kit_platform_interface.dart';
import 'package:haishin_kit/rtmp_connection_platform_interface.dart';

class RtmpConnection {
  static Future<RtmpConnection> create() async {
    var object = RtmpConnection._();
    object._memory = await HaishinKitPlatform.instance.newRtmpConnection();
    object._channel =
        EventChannel("com.haishinkit.eventchannel/${object._memory}");
    return object;
  }

  int? _memory;
  late EventChannel _channel;

  RtmpConnection._();

  /// The platform memory address.
  int? get memory => _memory;

  /// The event channel.
  EventChannel get eventChannel => _channel;

  /// Creates a two-way connection to an application on RTMP Server.
  void connect(String command) async {
    assert(_memory != null);
    final Map<String, dynamic> params = {"memory": _memory, "command": command};
    RtmpConnectionPlatform.instance.connect(params);
  }

  /// Closes the connection from the server.
  void close() async {
    assert(_memory != null);
    final Map<String, dynamic> params = {"memory": _memory};
    RtmpConnectionPlatform.instance.close(params);
  }
}
