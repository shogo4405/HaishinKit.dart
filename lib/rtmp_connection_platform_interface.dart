import 'package:haishin_kit/rtmp_connection_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class RtmpConnectionPlatform extends PlatformInterface {
  RtmpConnectionPlatform() : super(token: _token);

  static final Object _token = Object();

  static RtmpConnectionPlatform _instance = MethodChannelRtmpConnection();

  static RtmpConnectionPlatform get instance => _instance;

  static set instance(RtmpConnectionPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }
  
  Future<void> connect(Map<String, dynamic> params) {
    throw UnimplementedError('connect() has not been implemented.');
  }

  Future<void> close(Map<String, dynamic> params) {
    throw UnimplementedError('close() has not been implemented.');
  }
}
