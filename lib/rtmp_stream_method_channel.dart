import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haishin_kit/rtmp_stream_platform_interface.dart';

class MethodChannelRtmpStream extends RtmpStreamPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('com.haishinkit');

  @override
  Future<double?> create(Map<String, dynamic> params) async {
    return await methodChannel.invokeMethod<double?>(
        'RtmpStream#create', params);
  }

  @override
  Future<void> attachAudio(Map<String, dynamic> params) async {
    return await methodChannel.invokeMethod<void>(
        "RtmpStream#attachAudio", params);
  }

  @override
  Future<void> attachVideo(Map<String, dynamic> params) async {
    return await methodChannel.invokeMethod<void>(
        "RtmpStream#attachVideo", params);
  }

  @override
  Future<void> publish(Map<String, dynamic> params) async {
    return await methodChannel.invokeMethod<void>("RtmpStream#publish", params);
  }

  @override
  Future<void> play(Map<String, dynamic> params) async {
    return await methodChannel.invokeMethod<void>("RtmpStream#play", params);
  }

  @override
  Future<void> close(Map<String, dynamic> params) async {
    return await methodChannel.invokeMethod<void>("RtmpStream#close", params);
  }
}
