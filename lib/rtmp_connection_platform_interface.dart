import 'package:haishin_kit/rtmp_connection_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// The HaishinKit RtmpConnection platform instance.
abstract class RtmpConnectionPlatform extends PlatformInterface {
  RtmpConnectionPlatform() : super(token: _token);

  static final Object _token = Object();

  static RtmpConnectionPlatform _instance = MethodChannelRtmpConnection();

  static RtmpConnectionPlatform get instance => _instance;

  /// Sets the [RtmpConnectionPlatform.instance]
  static set instance(RtmpConnectionPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Creates a two-way connection to an application on RTMP Server.
  Future<void> connect(Map<String, dynamic> params) {
    throw UnimplementedError('connect() has not been implemented.');
  }

  /// Closes the connection from the server.
  Future<void> close(Map<String, dynamic> params) {
    throw UnimplementedError('close() has not been implemented.');
  }

  /// Disposes the RtmpConnection platform instance.
  Future<void> dispose(Map<String, dynamic> params) {
    throw UnimplementedError('dispose() has not been implemented.');
  }
}
