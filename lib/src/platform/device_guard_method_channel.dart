import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'device_guard_platform_interface.dart';

/// MethodChannel bridge to native Android and iOS implementations.
class MethodChannelDeviceGuard extends DeviceGuardPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('device_guard');

  Future<T?> _invoke<T>(String method, [Map<String, dynamic>? arguments]) async {
    try {
      return await methodChannel.invokeMethod<T>(method, arguments);
    } on PlatformException {
      return null;
    }
  }

  @override
  Future<String?> getPlatformVersion() async {
    return _invoke<String>('getPlatformVersion');
  }

  @override
  Future<bool> isAndroidVersionSupported(int minSdk) async {
    if (!Platform.isAndroid) return false;
    return (await _invoke<bool>(
          'isAndroidVersionSupported',
          {'minSdk': minSdk},
        )) ??
        false;
  }

  @override
  Future<bool> isDeveloperOptionsOff() async {
    return (await _invoke<bool>('isDeveloperOptionsOff')) ?? false;
  }

  @override
  Future<double> getTotalRam() async {
    return (await _invoke<double>('getTotalRam')) ?? 0.0;
  }

  @override
  Future<int> getAndroidSdkInt() async {
    if (!Platform.isAndroid) return 0;
    return (await _invoke<int>('getAndroidSdkInt')) ?? 0;
  }

  @override
  Future<bool> isNotRooted() async {
    return (await _invoke<bool>('isNotRooted')) ?? false;
  }

  @override
  Future<bool> isNotEmulator() async {
    return (await _invoke<bool>('isNotEmulator')) ?? false;
  }

  @override
  Future<bool> isUsbDebuggingOff() async {
    return (await _invoke<bool>('isUsbDebuggingOff')) ?? false;
  }

  @override
  Future<bool> isMockLocationOff() async {
    return (await _invoke<bool>('isMockLocationOff')) ?? false;
  }

  @override
  Future<bool> isVpnOff() async {
    return (await _invoke<bool>('isVpnOff')) ?? false;
  }

  @override
  Future<bool> isScreenRecordingOff() async {
    return (await _invoke<bool>('isScreenRecordingOff')) ?? false;
  }

  @override
  Future<bool> isScreenSharingOff() async {
    return (await _invoke<bool>('isScreenSharingOff')) ?? false;
  }

  @override
  Future<bool> hasNoOverlayApps() async {
    return (await _invoke<bool>('hasNoOverlayApps')) ?? false;
  }

  @override
  Future<bool> isFridaAbsent() async {
    return (await _invoke<bool>('isFridaAbsent')) ?? false;
  }

  @override
  Future<bool> isMagiskAbsent() async {
    return (await _invoke<bool>('isMagiskAbsent')) ?? false;
  }

  @override
  Future<bool> isXposedAbsent() async {
    return (await _invoke<bool>('isXposedAbsent')) ?? false;
  }
}
