import 'package:flutter/services.dart';
import 'package:haishin_kit/audio_source.dart';
import 'package:haishin_kit/av_capture_session_preset.dart';
import 'package:haishin_kit/haishin_kit_platform_interface.dart';
import 'package:haishin_kit/net_stream.dart';
import 'package:haishin_kit/rtmp_connection.dart';
import 'package:haishin_kit/rtmp_stream_platform_interface.dart';
import 'package:haishin_kit/video_settings.dart';
import 'package:haishin_kit/video_source.dart';

import 'audio_settings.dart';

class RtmpStream extends NetStream {
  static Future<RtmpStream> create(RtmpConnection connection) async {
    var object = RtmpStream._();
    object._memory =
        await HaishinKitPlatform.instance.newRtmpStream(connection);
    object._eventChannel =
        EventChannel("com.haishinkit.eventchannel/${object._memory}");
    return object;
  }

  int? _memory;
  late EventChannel _eventChannel;

  int _frameRate = 30;
  AVCaptureSessionPreset _sessionPreset = AVCaptureSessionPreset.hd1280x720;
  VideoSettings _videoSettings = VideoSettings();
  AudioSettings _audioSettings = AudioSettings();

  RtmpStream._();

  @override
  int? get memory => _memory;

  EventChannel get eventChannel => _eventChannel;

  @override
  int get frameRate => _frameRate;

  @override
  set frameRate(int frameRate) {
    assert(_memory != null);
    _frameRate = frameRate;
    RtmpStreamPlatform.instance
        .setFrameRate({"memory": _memory, "value": frameRate});
  }

  AVCaptureSessionPreset get sessionPreset => _sessionPreset;

  @override
  set sessionPreset(AVCaptureSessionPreset sessionPreset) {
    assert(_memory != null);
    _sessionPreset = sessionPreset;
    RtmpStreamPlatform.instance.setSessionPreset(
        {"memory": _memory, "value": sessionPreset.presetName});
  }

  VideoSettings get videoSettings => _videoSettings;

  @override
  set videoSettings(VideoSettings videoSettings) {
    assert(_memory != null);
    _videoSettings = videoSettings;
    RtmpStreamPlatform.instance.setVideoSettings(
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

  @override
  Future<void> setHasAudio(bool value) async {
    assert(_memory != null);
    RtmpStreamPlatform.instance
        .setHasAudio({"memory": _memory, "value": value});
  }

  @override
  Future<bool?> getHasAudio() {
    assert(_memory != null);
    return RtmpStreamPlatform.instance.getHasAudio();
  }

  @override
  Future<void> setHasVideo(bool value) async {
    assert(_memory != null);
    RtmpStreamPlatform.instance
        .setHasVideo({"memory": _memory, "value": value});
  }

  @override
  Future<bool?> getHasVideo() {
    assert(_memory != null);
    return RtmpStreamPlatform.instance.getHasVideo();
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

  @override
  Future<void> dispose() async {
    assert(_memory != null);
    RtmpStreamPlatform.instance.dispose({"memory": _memory});
  }
}
