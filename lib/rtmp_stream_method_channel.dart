import 'package:haishin_kit/av_capture_session_preset.dart';
import 'package:haishin_kit/rtmp_stream_platform_interface.dart';

import 'haishin_kit_method_channel.dart';

/// The method channel implementation of [RtmpStreamPlatform]
class MethodChannelRtmpStream extends RtmpStreamPlatform {
  @override
  Future<bool?> getHasAudio() async {
    return await MethodChannelHaishinKit.channel
        .invokeMethod<bool?>("RtmpStream#getHasAudio");
  }

  @override
  Future<void> setHasAudio(Map<String, dynamic> params) async {
    return await MethodChannelHaishinKit.channel
        .invokeMethod<void>("RtmpStream#setHasAudio", params);
  }

  @override
  Future<bool?> getHasVideo() async {
    return await MethodChannelHaishinKit.channel
        .invokeMethod<bool?>("RtmpStream#getHasVideo");
  }

  @override
  Future<void> setHasVideo(Map<String, dynamic> params) async {
    return await MethodChannelHaishinKit.channel
        .invokeMethod<void>("RtmpStream#setHasVideo", params);
  }

  @override
  Future<void> setFrameRate(Map<String, dynamic> params) async {
    return await MethodChannelHaishinKit.channel
        .invokeMethod<void>("RtmpStream#setFrameRate", params);
  }

  @override
  Future<void> setSessionPreset(Map<String, dynamic> params) async {
    return await MethodChannelHaishinKit.channel
        .invokeMethod<void>("RtmpStream#setSessionPreset", params);
  }

  @override
  Future<void> setAudioSettings(Map<String, dynamic> params) async {
    return await MethodChannelHaishinKit.channel
        .invokeMethod<void>("RtmpStream#setAudioSettings", params);
  }

  @override
  Future<void> setVideoSettings(Map<String, dynamic> params) async {
    return await MethodChannelHaishinKit.channel
        .invokeMethod<void>("RtmpStream#setVideoSettings", params);
  }

  @override
  Future<void> attachAudio(Map<String, dynamic> params) async {
    return await MethodChannelHaishinKit.channel
        .invokeMethod<void>("RtmpStream#attachAudio", params);
  }

  @override
  Future<void> attachVideo(Map<String, dynamic> params) async {
    return await MethodChannelHaishinKit.channel
        .invokeMethod<void>("RtmpStream#attachVideo", params);
  }

  @override
  Future<void> publish(Map<String, dynamic> params) async {
    return await MethodChannelHaishinKit.channel
        .invokeMethod<void>("RtmpStream#publish", params);
  }

  @override
  Future<void> play(Map<String, dynamic> params) async {
    return await MethodChannelHaishinKit.channel
        .invokeMethod<void>("RtmpStream#play", params);
  }

  @override
  Future<int?> registerTexture(Map<String, dynamic> params) async {
    return await MethodChannelHaishinKit.channel
        .invokeMethod<int>("RtmpStream#registerTexture", params);
  }

  @override
  Future<void> close(Map<String, dynamic> params) async {
    return await MethodChannelHaishinKit.channel
        .invokeMethod<void>("RtmpStream#close", params);
  }

  @override
  Future<void> dispose(Map<String, dynamic> params) async {
    return await MethodChannelHaishinKit.channel
        .invokeMethod<void>("RtmpStream#dispose", params);
  }
}
