import 'package:flutter_test/flutter_test.dart';
import 'package:haishin_kit/haishin_kit.dart';
import 'package:haishin_kit/haishin_kit_platform_interface.dart';
import 'package:haishin_kit/haishin_kit_method_channel.dart';
import 'package:haishin_kit/rtmp_connection.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockHaishinKitPlatform
    with MockPlatformInterfaceMixin
    implements HaishinKitPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<int?> newRtmpConnection() {
    throw UnimplementedError();
  }

  @override
  Future<int?> newRtmpStream(RtmpConnection connection) {
    throw UnimplementedError();
  }
}

void main() {
  final HaishinKitPlatform initialPlatform = HaishinKitPlatform.instance;

  test('$MethodChannelHaishinKit is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelHaishinKit>());
  });

  test('getPlatformVersion', () async {
    HaishinKit haishinKitPlugin = HaishinKit();
    MockHaishinKitPlatform fakePlatform = MockHaishinKitPlatform();
    HaishinKitPlatform.instance = fakePlatform;

    expect(await haishinKitPlugin.getPlatformVersion(), '42');
  });
}
