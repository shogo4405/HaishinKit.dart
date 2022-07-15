import 'package:haishin_kit/rtmp_stream_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// The HaishinKit RtmpStream platform interface
abstract class RtmpStreamPlatform extends PlatformInterface {
  RtmpStreamPlatform() : super(token: _token);

  static final Object _token = Object();

  static RtmpStreamPlatform _instance = MethodChannelRtmpStream();

  static RtmpStreamPlatform get instance => _instance;

  /// Sets the [RtmpStreamPlatform.instance]
  static set instance(RtmpStreamPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Sets the audio decoding properties.
  Future<void> setAudioSettings(Map<String, dynamic> params) {
    throw UnimplementedError('setAudioSettings() has not been implemented.');
  }

  /// Sets the video decoding properties.
  Future<void> setVideoSettings(Map<String, dynamic> params) {
    throw UnimplementedError('setVideoSettings() has not been implemented.');
  }

  /// Sets the AVCaptureSession(iOS) properties.
  Future<void> setCaptureSettings(Map<String, dynamic> params) {
    throw UnimplementedError('setCaptureSettings() has not been implemented.');
  }

  /// Attaches an audio source.
  Future<void> attachAudio(Map<String, dynamic> params) {
    throw UnimplementedError('attachAudio() has not been implemented.');
  }

  /// Attaches a video source.
  Future<void> attachVideo(Map<String, dynamic> params) {
    throw UnimplementedError('attachVideo() has not been implemented.');
  }

  /// Plays a live source from a RTMP server.
  Future<void> play(Map<String, dynamic> params) {
    throw UnimplementedError('play() has not been implemented.');
  }

  /// Publishes a live source.
  Future<void> publish(Map<String, dynamic> params) {
    throw UnimplementedError('publish() has not been implemented.');
  }

  /// Register a texture with FlutterTexture.
  Future<int?> registerTexture(Map<String, dynamic> params) async {
    throw UnimplementedError('registerTexture() has not been implemented.');
  }

  /// Closes the connection.
  Future<void> close(Map<String, dynamic> params) {
    throw UnimplementedError('close() has not been implemented.');
  }

  /// Disposes the RtmpStream platform instance.
  Future<void> dispose(Map<String, dynamic> params) {
    throw UnimplementedError('dispose() has not been implemented.');
  }
}
