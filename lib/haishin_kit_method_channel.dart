import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'haishin_kit_platform_interface.dart';

/// An implementation of [HaishinKitPlatform] that uses method channels.
class MethodChannelHaishinKit extends HaishinKitPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('haishin_kit');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
