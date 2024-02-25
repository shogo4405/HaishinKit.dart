import 'package:haishin_kit/audio_source.dart';
import 'package:haishin_kit/av_capture_session_preset.dart';
import 'package:haishin_kit/screen_settings.dart';
import 'package:haishin_kit/video_settings.dart';
import 'package:haishin_kit/video_source.dart';

import 'audio_settings.dart';

/// The Stream class is the foundation of a RTMPStream.
abstract class Stream {
  /// The memory address.
  int? get memory;

  /// Gets the frameRate.
  int get frameRate;

  /// Sets the frameRate.
  set frameRate(int value);

  /// Specifies the sessionPreset for iOS.
  set sessionPreset(AVCaptureSessionPreset value);

  /// Specifies the video codec properties.
  set videoSettings(VideoSettings videoSettings);

  /// Specifies the audio codec properties.
  set audioSettings(AudioSettings audioSettings);

  /// Specifies the screen properties.
  set screenSettings(ScreenSettings screenSettings);

  /// Gets the hasAudio property.
  Future<bool?> getHasAudio();

  /// Sets the hasAudio property.
  Future<void> setHasAudio(bool value);

  /// Gets the hasVideo property.
  Future<bool?> getHasVideo();

  /// Sets the hasVideo property.
  Future<void> setHasVideo(bool value);

  /// Attaches an AudioSource to this stream.
  Future<void> attachAudio(AudioSource? audio);

  /// Attaches a VideoSource to this stream.
  Future<void> attachVideo(VideoSource? video);

  /// Register a texture to this stream.
  Future<int?> registerTexture(Map<String, dynamic> params);

  /// Stops playing or publishing and makes available other uses.
  Future<void> close();

  Future<void> unregisterTexture(Map<String, dynamic> params);

  Future<int?> updateTextureSize(Map<String, dynamic> params);

  /// Disposes the NetStream platform instance.
  Future<void> dispose();
}
