import 'package:haishin_kit/av_capture_session_preset.dart';
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

  /// Gets the hasAudio property.
  Future<bool?> getHasAudio() {
    throw UnimplementedError('getHasAudio() has not been implemented.');
  }

  /// Sets the hasAudio property.
  Future<void> setHasAudio(Map<String, dynamic> params) {
    throw UnimplementedError('setHasAudio() has not been implemented.');
  }

  /// Gets the hasVideo property.
  Future<bool?> getHasVideo() {
    throw UnimplementedError('getHasVideo() has not been implemented.');
  }

  /// Sets the hasVideo property.
  Future<void> setHasVideo(Map<String, dynamic> params) {
    throw UnimplementedError('setHasVideo() has not been implemented.');
  }

  /// Sets the frameRate property.
  Future<void> setFrameRate(Map<String, dynamic> params) {
    throw UnimplementedError('setFrameRate() has not been implemented.');
  }

  /// Sets the sessionPreset property.
  Future<void> setSessionPreset(Map<String, dynamic> params) {
    throw UnimplementedError('setSessionPreset has not been implemented.');
  }

  /// Sets the audio decoding properties.
  Future<void> setAudioSettings(Map<String, dynamic> params) {
    throw UnimplementedError('setAudioSettings() has not been implemented.');
  }

  /// Sets the sessionPreset for the AVCaptureSession.
  Future<void> setVideoSettings(Map<String, dynamic> params) {
    throw UnimplementedError('setVideoSettings() has not been implemented.');
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
