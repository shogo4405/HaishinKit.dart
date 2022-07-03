import 'package:haishin_kit/audio_source.dart';
import 'package:haishin_kit/video_settings.dart';
import 'package:haishin_kit/video_source.dart';

import 'audio_settings.dart';
import 'capture_settings.dart';

/// The NetStream class is the foundation of a RTMPStream.
abstract class NetStream {
  double? get memory;

  /// Specifies stream video compression properties.
  set videoSettings(VideoSettings videoSettings);

  /// Specifies stream audio compression properties.
  set audioSettings(AudioSettings audioSettings);

  /// Specifies stream AVSession properties.
  set captureSettings(CaptureSettings captureSettings);

  Future<void> attachAudio(AudioSource? audio);

  Future<void> attachVideo(VideoSource? video);

  Future<int?> registerTexture();

  /// Stops playing or publishing and makes available other uses.
  Future<void> close();
}
