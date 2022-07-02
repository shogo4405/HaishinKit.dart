import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'haishin_kit_method_channel.dart';

abstract class HaishinKitPlatform extends PlatformInterface {
  /// Constructs a HaishinKitPlatform.
  HaishinKitPlatform() : super(token: _token);

  static final Object _token = Object();

  static HaishinKitPlatform _instance = MethodChannelHaishinKit();

  /// The default instance of [HaishinKitPlatform] to use.
  ///
  /// Defaults to [MethodChannelHaishinKit].
  static HaishinKitPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [HaishinKitPlatform] when
  /// they register themselves.
  static set instance(HaishinKitPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
