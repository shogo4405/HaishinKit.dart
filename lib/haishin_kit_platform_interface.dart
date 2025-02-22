import 'package:haishin_kit/rtmp_connection.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'haishin_kit_method_channel.dart';

/// The HaishinKit platform interface.
abstract class HaishinKitPlatform extends PlatformInterface {
  /// Creates an instance.
  HaishinKitPlatform() : super(token: _token);

  static final Object _token = Object();

  static HaishinKitPlatform _instance = MethodChannelHaishinKit();

  static HaishinKitPlatform get instance => _instance;

  /// Sets the [HaishinKitPlatform.instance]
  static set instance(HaishinKitPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Creates a new RtmpConnection platformt instance.
  Future<int?> newRtmpConnection() {
    throw UnimplementedError('newRtmpConnection() has not been implemented.');
  }

  /// Creates a new RtmpStream platform instance.
  Future<int?> newRtmpStream(RtmpConnection connection) {
    throw UnimplementedError('newRtmpStream() has not been implemented.');
  }

  /// Gets the HaishinKit library version.
  Future<String?> getPlatformVersion() {
    throw UnimplementedError('getPlatformVersion() has not been implemented.');
  }
}
