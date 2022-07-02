import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'haishin_kit_platform_interface.dart';

class MethodChannelHaishinKit extends HaishinKitPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('com.haishinkit');

  @override
  Future<String?> getVersion() async {
    return await methodChannel.invokeMethod<String>('getVersion');
  }
}
