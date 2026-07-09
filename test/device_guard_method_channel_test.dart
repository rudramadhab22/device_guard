
import 'package:device_guard/src/platform/device_guard_method_channel.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelDeviceGuard platform = MethodChannelDeviceGuard();
  const MethodChannel channel = MethodChannel('device_guard');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'getPlatformVersion':
          return '42';
        case 'isAndroidVersionSupported':
          return true;
        case 'isRamSufficient':
          return true;
        case 'isDeveloperOptionsOff':
          return true;
        case 'getTotalRam':
          return 8.0;
        case 'getAndroidSdkInt':
          return 34;
        default:
          return null;
      }
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });

  test('isAndroidVersionSupported', () async {
    expect(await platform.isAndroidVersionSupported(34), true);
  });

  test('isRamSufficient', () async {
    expect(await platform.isRamSufficient(4), true);
  });

  test('isDeveloperOptionsOff', () async {
    expect(await platform.isDeveloperOptionsOff(), true);
  });

  test('getTotalRam', () async {
    expect(await platform.getTotalRam(), 8.0);
  });

  test('getAndroidSdkInt', () async {
    expect(await platform.getAndroidSdkInt(), 34);
  });
}
