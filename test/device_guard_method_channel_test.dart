import 'dart:io';

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
        case 'isDeveloperOptionsOff':
          return true;
        case 'getTotalRam':
          return 8.0;
        case 'getAndroidSdkInt':
          return 34;
        case 'isNotRooted':
          return true;
        case 'isNotEmulator':
          return true;
        case 'isUsbDebuggingOff':
          return true;
        case 'isMockLocationOff':
          return true;
        case 'isVpnOff':
          return true;
        case 'isScreenRecordingOff':
          return true;
        case 'isScreenSharingOff':
          return true;
        case 'hasNoOverlayApps':
          return true;
        case 'isFridaAbsent':
          return true;
        case 'isMagiskAbsent':
          return true;
        case 'isXposedAbsent':
          return true;
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
    if (!Platform.isAndroid) return;
    expect(await platform.isAndroidVersionSupported(34), true);
  });

  test('isDeveloperOptionsOff', () async {
    expect(await platform.isDeveloperOptionsOff(), true);
  });

  test('getTotalRam', () async {
    expect(await platform.getTotalRam(), 8.0);
  });

  test('getAndroidSdkInt', () async {
    if (!Platform.isAndroid) return;
    expect(await platform.getAndroidSdkInt(), 34);
  });

  test('isNotRooted', () async {
    expect(await platform.isNotRooted(), true);
  });

  test('isNotEmulator', () async {
    expect(await platform.isNotEmulator(), true);
  });

  test('isUsbDebuggingOff', () async {
    expect(await platform.isUsbDebuggingOff(), true);
  });

  test('isMockLocationOff', () async {
    expect(await platform.isMockLocationOff(), true);
  });

  test('isVpnOff', () async {
    expect(await platform.isVpnOff(), true);
  });

  test('isScreenRecordingOff', () async {
    expect(await platform.isScreenRecordingOff(), true);
  });

  test('isScreenSharingOff', () async {
    expect(await platform.isScreenSharingOff(), true);
  });

  test('hasNoOverlayApps', () async {
    expect(await platform.hasNoOverlayApps(), true);
  });

  test('isFridaAbsent', () async {
    expect(await platform.isFridaAbsent(), true);
  });

  test('isMagiskAbsent', () async {
    expect(await platform.isMagiskAbsent(), true);
  });

  test('isXposedAbsent', () async {
    expect(await platform.isXposedAbsent(), true);
  });
}
