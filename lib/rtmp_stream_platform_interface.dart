import 'package:haishin_kit/rtmp_stream_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class RtmpStreamPlatform extends PlatformInterface {
  RtmpStreamPlatform() : super(token: _token);

  static final Object _token = Object();

  static RtmpStreamPlatform _instance = MethodChannelRtmpStream();

  static RtmpStreamPlatform get instance => _instance;

  static set instance(RtmpStreamPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<double?> create(Map<String, dynamic> params) {
    throw UnimplementedError('create() has not been implemented.');
  }

  Future<void> attachAudio(Map<String, dynamic> params) {
    throw UnimplementedError('attachAudio() has not been implemented.');
  }

  Future<void> attachVideo(Map<String, dynamic> params) {
    throw UnimplementedError('attachVideo() has not been implemented.');
  }

  Future<void> play(Map<String, dynamic> params) {
    throw UnimplementedError('play() has not been implemented.');
  }

  Future<void> publish(Map<String, dynamic> params) {
    throw UnimplementedError('publish() has not been implemented.');
  }

  Future<void> close(Map<String, dynamic> params) {
    throw UnimplementedError('close() has not been implemented.');
  }
}
