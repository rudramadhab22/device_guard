import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'device_guard_platform_interface.dart';

/// An implementation of [DeviceGuardPlatform] that uses MethodChannels to 
/// communicate with the native Android code.
class MethodChannelDeviceGuard extends DeviceGuardPlatform {
  /// The method channel used to interact with the native platform.
  /// The channel name 'device_guard' must match the one defined in the Kotlin side.
  @visibleForTesting
  final methodChannel = const MethodChannel('device_guard');

  @override
  Future<String?> getPlatformVersion() async {
    // Invokes the native 'getPlatformVersion' method.
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }

  @override
  Future<bool> isAndroidVersionSupported(int minSdk) async {
    // This plugin only supports Android-specific security checks.
    if (!Platform.isAndroid) return false;
    
    // Calls native Android to check SDK_INT >= minSdk.
    final isSupported = await methodChannel.invokeMethod<bool>(
      'isAndroidVersionSupported',
      {'minSdk': minSdk},
    );
    return isSupported ?? false;
  }

  @override
  Future<bool> isRamSufficient(int minRamGb) async {
    // Non-Android platforms are considered non-compliant by default.
    if (!Platform.isAndroid) return false;
    
    // Calls native Android to verify if total RAM is >= minRamGb.
    final isSufficient = await methodChannel.invokeMethod<bool>(
      'isRamSufficient',
      {'minRamGb': minRamGb},
    );
    return isSufficient ?? false;
  }

  @override
  Future<bool> isDeveloperOptionsOff() async {
    // Non-Android platforms are considered non-compliant by default.
    if (!Platform.isAndroid) return false;
    
    // Calls native Android to check if DEVELOPMENT_SETTINGS_ENABLED is 0.
    final isOff = await methodChannel.invokeMethod<bool>('isDeveloperOptionsOff');
    return isOff ?? false;
  }

  @override
  Future<double> getTotalRam() async {
    if (!Platform.isAndroid) return 0.0;
    final ram = await methodChannel.invokeMethod<double>('getTotalRam');
    return ram ?? 0.0;
  }

  @override
  Future<int> getAndroidSdkInt() async {
    if (!Platform.isAndroid) return 0;
    final sdk = await methodChannel.invokeMethod<int>('getAndroidSdkInt');
    return sdk ?? 0;
  }
}
