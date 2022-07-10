import 'package:haishin_kit/rtmp_connection.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'haishin_kit_method_channel.dart';

abstract class HaishinKitPlatform extends PlatformInterface {
  HaishinKitPlatform() : super(token: _token);

  static final Object _token = Object();

  static HaishinKitPlatform _instance = MethodChannelHaishinKit();

  static HaishinKitPlatform get instance => _instance;

  static set instance(HaishinKitPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<int?> newRtmpConnection() {
    throw UnimplementedError('newRtmpConnection() has not been implemented.');
  }

  Future<int?> newRtmpStream(RtmpConnection connection) {
    throw UnimplementedError('newRtmpStream() has not been implemented.');
  }

  Future<String?> getVersion() {
    throw UnimplementedError('getVersion() has not been implemented.');
  }
}
