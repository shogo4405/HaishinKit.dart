import 'package:flutter/services.dart';
import 'package:haishin_kit/rtmp_connection.dart';

import 'haishin_kit_platform_interface.dart';

/// The method channel implementation of [HaishinKitPlatform]
class MethodChannelHaishinKit extends HaishinKitPlatform {
  static const MethodChannel channel = MethodChannel('com.haishinkit');

  @override
  Future<int?> newRtmpConnection() async {
    return await channel.invokeMethod<int?>('newRtmpConnection');
  }

  @override
  Future<int?> newRtmpStream(RtmpConnection connection) async {
    return await channel
        .invokeMethod<int?>('newRtmpStream', {"connection": connection.memory});
  }

  @override
  Future<String?> getPlatformVersion() async {
    return await channel.invokeMethod<String>('getPlatformVersion');
  }
}
