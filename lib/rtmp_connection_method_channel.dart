import 'package:haishin_kit/haishin_kit_method_channel.dart';
import 'package:haishin_kit/rtmp_connection_platform_interface.dart';

/// The method channel implementation of [RtmpConnectionPlatform]
class MethodChannelRtmpConnection extends RtmpConnectionPlatform {
  @override
  Future<double?> create() async {
    return await MethodChannelHaishinKit.channel
        .invokeMethod<double?>('RtmpConnection#create');
  }

  @override
  Future<void> connect(Map<String, dynamic> params) async {
    return await MethodChannelHaishinKit.channel
        .invokeMethod<void>('RtmpConnection#connect', params);
  }

  @override
  Future<void> close(Map<String, dynamic> params) async {
    return await MethodChannelHaishinKit.channel
        .invokeMethod<void>('RtmpConnection#close', params);
  }
}
