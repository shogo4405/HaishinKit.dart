import 'package:flutter/services.dart';

import 'haishin_kit_platform_interface.dart';

/// The method channel implementation of [HaishinKitPlatform]
class MethodChannelHaishinKit extends HaishinKitPlatform {
  static const MethodChannel channel = MethodChannel('com.haishinkit');

  @override
  Future<String?> getVersion() async {
    return await channel.invokeMethod<String>('getVersion');
  }
}
