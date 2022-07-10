import 'package:haishin_kit/audio_source.dart';
import 'package:haishin_kit/video_settings.dart';
import 'package:haishin_kit/video_source.dart';

import 'audio_settings.dart';
import 'capture_settings.dart';

/// The NetStream class is the foundation of a RTMPStream.
abstract class NetStream {
  /// The memory address.
  int? get memory;

  /// Specifies stream video compression properties.
  set videoSettings(VideoSettings videoSettings);

  /// Specifies stream audio compression properties.
  set audioSettings(AudioSettings audioSettings);

  /// Specifies stream AVSession properties.
  set captureSettings(CaptureSettings captureSettings);

  /// Attaches an AudioSource to this stream.
  Future<void> attachAudio(AudioSource? audio);

  /// Attaches a VideoSource to this stream.
  Future<void> attachVideo(VideoSource? video);

  /// Register a texture to this stream.
  Future<int?> registerTexture(Map<String, dynamic> params);

  /// Stops playing or publishing and makes available other uses.
  Future<void> close();
}
