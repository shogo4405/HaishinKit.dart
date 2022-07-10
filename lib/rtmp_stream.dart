import 'package:haishin_kit/audio_source.dart';
import 'package:haishin_kit/net_stream.dart';
import 'package:haishin_kit/rtmp_connection.dart';
import 'package:haishin_kit/rtmp_stream_platform_interface.dart';
import 'package:haishin_kit/video_settings.dart';
import 'package:haishin_kit/video_source.dart';

import 'audio_settings.dart';
import 'capture_settings.dart';

class RtmpStream extends NetStream {
  static Future<RtmpStream> create(RtmpConnection connection) async {
    var object = RtmpStream._();
    final Map<String, dynamic> params = {"memory": connection.memory};
    object._memory = await RtmpStreamPlatform.instance.create(params);
    return object;
  }

  double? _memory;

  VideoSettings _videoSettings = VideoSettings();
  AudioSettings _audioSettings = AudioSettings();
  CaptureSettings _captureSettings = CaptureSettings();

  RtmpStream._();

  @override
  double? get memory => _memory;

  VideoSettings get videoSettings => _videoSettings;

  @override
  set videoSettings(VideoSettings videoSettings) {
    assert(_memory != null);
    _videoSettings = videoSettings;
    RtmpStreamPlatform.instance.setAudioSettings(
        {"memory": _memory, "settings": videoSettings.toMap()});
  }

  AudioSettings get audioSettings => _audioSettings;

  @override
  set audioSettings(AudioSettings audioSettings) {
    assert(_memory != null);
    _audioSettings = audioSettings;
    RtmpStreamPlatform.instance.setAudioSettings(
        {"memory": _memory, "settings": audioSettings.toMap()});
  }

  CaptureSettings get captureSettings => _captureSettings;

  @override
  set captureSettings(CaptureSettings captureSettings) {
    assert(_memory != null);
    _captureSettings = captureSettings;
    RtmpStreamPlatform.instance.setAudioSettings(
        {"memory": _memory, "settings": captureSettings.toMap()});
  }

  @override
  Future<void> attachAudio(AudioSource? audio) async {
    assert(_memory != null);
    RtmpStreamPlatform.instance
        .attachAudio({"memory": _memory, "source": audio?.toMap()});
  }

  @override
  Future<void> attachVideo(VideoSource? video) async {
    assert(_memory != null);
    RtmpStreamPlatform.instance
        .attachVideo({"memory": _memory, "source": video?.toMap()});
  }

  /// Sends streaming audio, video and data message from client.
  Future<void> publish(String name) async {
    assert(_memory != null);
    RtmpStreamPlatform.instance.publish({"memory": _memory, "name": name});
  }

  /// Plays a live stream from RTMPServer.
  Future<void> play(String name) async {
    assert(_memory != null);
    RtmpStreamPlatform.instance.play({"memory": _memory, "name": name});
  }

  @override
  Future<int?> registerTexture(Map<String, dynamic> params) async {
    assert(_memory != null);
    params["memory"] = _memory;
    return RtmpStreamPlatform.instance.registerTexture(params);
  }

  @override
  Future<void> close() async {
    assert(_memory != null);
    RtmpStreamPlatform.instance.close({"memory": _memory});
  }
}
