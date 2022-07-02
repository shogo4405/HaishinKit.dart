import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:haishin_kit/rtmp_connection_platform_interface.dart';

class MethodChannelRtmpConnection extends RtmpConnectionPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('com.haishinkit');

  @override
  Future<double?> create() async {
    return await methodChannel.invokeMethod<double?>('RtmpConnection#create');
  }

  @override
  Future<void> connect(Map<String, dynamic> params) async {
    return await methodChannel.invokeMethod<void>(
        'RtmpConnection#connect', params);
  }

  @override
  Future<void> close(Map<String, dynamic> params) async {
    return await methodChannel.invokeMethod<void>(
        'RtmpConnection#close', params);
  }
}
