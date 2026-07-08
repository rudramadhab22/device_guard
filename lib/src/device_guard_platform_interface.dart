import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'device_guard_method_channel.dart';

/// The interface that implementations of DeviceGuard must implement.
/// 
/// This follows the federated plugin pattern in Flutter, allowing for 
/// different platform-specific implementations (Android, iOS, etc.) to be 
/// plugged in.
abstract class DeviceGuardPlatform extends PlatformInterface {
  /// Constructs a DeviceGuardPlatform.
  DeviceGuardPlatform() : super(token: _token);

  static final Object _token = Object();

  // The default instance is the MethodChannel implementation.
  static DeviceGuardPlatform _instance = MethodChannelDeviceGuard();

  /// The default instance of [DeviceGuardPlatform] to use.
  ///
  /// Defaults to [MethodChannelDeviceGuard].
  static DeviceGuardPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DeviceGuardPlatform] when
  /// they register themselves.
  static set instance(DeviceGuardPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Returns the platform version.
  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  /// Abstract method to check for a minimum Android version.
  Future<bool> isAndroidVersionSupported(int minSdk) {
    throw UnimplementedError('isAndroidVersionSupported() has not been implemented.');
  }

  /// Abstract method to check for a minimum amount of RAM in GB.
  Future<bool> isRamSufficient(int minRamGb) {
    throw UnimplementedError('isRamSufficient() has not been implemented.');
  }

  /// Abstract method to check if Developer Options status matches the requirement.
  Future<bool> isDeveloperOptionsOff() {
    throw UnimplementedError('isDeveloperOptionsOff() has not been implemented.');
  }

  /// Fetches the current total RAM of the device in GB.
  Future<double> getTotalRam() {
    throw UnimplementedError('getTotalRam() has not been implemented.');
  }

  /// Fetches the current Android SDK version (API level).
  Future<int> getAndroidSdkInt() {
    throw UnimplementedError('getAndroidSdkInt() has not been implemented.');
  }
}
