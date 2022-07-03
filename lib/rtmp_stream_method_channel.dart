import 'package:haishin_kit/rtmp_stream_platform_interface.dart';

import 'haishin_kit_method_channel.dart';

/// The method channel implementation of [RtmpStreamPlatform]
class MethodChannelRtmpStream extends RtmpStreamPlatform {
  @override
  Future<double?> create(Map<String, dynamic> params) async {
    return await MethodChannelHaishinKit.channel
        .invokeMethod<double?>('RtmpStream#create', params);
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
  Future<void> setCaptureSettings(Map<String, dynamic> params) async {
    return await MethodChannelHaishinKit.channel
        .invokeMethod<void>("RtmpStream#setCaptureSettings", params);
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
}
