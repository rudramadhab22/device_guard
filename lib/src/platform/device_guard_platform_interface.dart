import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'device_guard_method_channel.dart';

/// The interface that implementations of DeviceGuard must implement.
abstract class DeviceGuardPlatform extends PlatformInterface {
  DeviceGuardPlatform() : super(token: _token);

  static final Object _token = Object();

  static DeviceGuardPlatform _instance = MethodChannelDeviceGuard();

  static DeviceGuardPlatform get instance => _instance;

  static set instance(DeviceGuardPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('getPlatformVersion() has not been implemented.');
  }

  Future<bool> isAndroidVersionSupported(int minSdk) {
    throw UnimplementedError(
      'isAndroidVersionSupported() has not been implemented.',
    );
  }

  Future<bool> isDeveloperOptionsOff() {
    throw UnimplementedError(
      'isDeveloperOptionsOff() has not been implemented.',
    );
  }

  Future<double> getTotalRam() {
    throw UnimplementedError('getTotalRam() has not been implemented.');
  }

  Future<int> getAndroidSdkInt() {
    throw UnimplementedError('getAndroidSdkInt() has not been implemented.');
  }

  Future<bool> isNotRooted() {
    throw UnimplementedError('isNotRooted() has not been implemented.');
  }

  Future<bool> isNotEmulator() {
    throw UnimplementedError('isNotEmulator() has not been implemented.');
  }

  Future<bool> isUsbDebuggingOff() {
    throw UnimplementedError('isUsbDebuggingOff() has not been implemented.');
  }

  Future<bool> isMockLocationOff() {
    throw UnimplementedError('isMockLocationOff() has not been implemented.');
  }

  Future<bool> isVpnOff() {
    throw UnimplementedError('isVpnOff() has not been implemented.');
  }

  Future<bool> isScreenRecordingOff() {
    throw UnimplementedError(
      'isScreenRecordingOff() has not been implemented.',
    );
  }

  Future<bool> isScreenSharingOff() {
    throw UnimplementedError('isScreenSharingOff() has not been implemented.');
  }

  Future<bool> hasNoOverlayApps() {
    throw UnimplementedError('hasNoOverlayApps() has not been implemented.');
  }

  Future<bool> isFridaAbsent() {
    throw UnimplementedError('isFridaAbsent() has not been implemented.');
  }

  Future<bool> isMagiskAbsent() {
    throw UnimplementedError('isMagiskAbsent() has not been implemented.');
  }

  Future<bool> isXposedAbsent() {
    throw UnimplementedError('isXposedAbsent() has not been implemented.');
  }
}
