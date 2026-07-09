import 'package:device_guard/src/platform/device_guard_method_channel.dart';
import 'package:device_guard/src/platform/device_guard_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:device_guard/device_guard.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDeviceGuardPlatform
    with MockPlatformInterfaceMixin
    implements DeviceGuardPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('Android 14');

  @override
  Future<bool> isAndroidVersionSupported(int minSdk) => Future.value(true);

  @override
  Future<bool> isDeveloperOptionsOff() => Future.value(true);

  @override
  Future<bool> isRamSufficient(int minRamGb) => Future.value(true);

  @override
  Future<int> getAndroidSdkInt() => Future.value(34);

  @override
  Future<double> getTotalRam() => Future.value(8.0);
}

void main() {
  final DeviceGuardPlatform initialPlatform = DeviceGuardPlatform.instance;

  test('$MethodChannelDeviceGuard is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelDeviceGuard>());
  });

  test('verifyDeviceGuard returns correct results', () async {
    DeviceGuard deviceGuardPlugin = DeviceGuard();
    MockDeviceGuardPlatform fakePlatform = MockDeviceGuardPlatform();
    DeviceGuardPlatform.instance = fakePlatform;

    final result = await deviceGuardPlugin.verifyDeviceGuard(
      minSdk: 33,
      minRamGb: 4,
    );

    expect(result.isValid, true);
    expect(result.platformVersion, 'Android 14');
    expect(result.displayRamGb, 8);
  });
}
