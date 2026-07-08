import 'src/device_guard_platform_interface.dart';
import 'device_guard_result.dart';

export 'device_guard_result.dart';

/// The main class for the Device Guard plugin.
class DeviceGuard {
  /// Fetches the current platform version string (e.g., "Android 14").
  Future<String?> getPlatformVersion() {
    return DeviceGuardPlatform.instance.getPlatformVersion();
  }

  /// Checks if the device's Android version meets the minimum requirement.
  Future<bool> isAndroidVersionSupported(int minSdk) {
    return DeviceGuardPlatform.instance.isAndroidVersionSupported(minSdk);
  }

  /// Checks if the device has the specified minimum total RAM in GB.
  Future<bool> isRamSufficient(int minRamGb) {
    return DeviceGuardPlatform.instance.isRamSufficient(minRamGb);
  }

  /// Checks if Developer Options are currently disabled on the device.
  Future<bool> isDeveloperOptionsOff() {
    return DeviceGuardPlatform.instance.isDeveloperOptionsOff();
  }

  /// Fetches the current total RAM of the device in GB.
  Future<double> getTotalRam() {
    return DeviceGuardPlatform.instance.getTotalRam();
  }

  /// Fetches the current Android SDK version (API level).
  Future<int> getAndroidSdkInt() {
    return DeviceGuardPlatform.instance.getAndroidSdkInt();
  }

  /// Performs a complete security verification based on custom requirements.
  /// 
  /// The developer must specify the requirements:
  /// [minSdk] - Minimum Android API level.
  /// [minRamGb] - Minimum RAM in GB.
  /// [requireDeveloperOptionsOff] - Whether Developer Options must be OFF (default true).
  /// 
  /// Returns a [DeviceGuardResult] containing the status of each check.
  Future<DeviceGuardResult> verifyDeviceGuard({
    required int minSdk,
    required int minRamGb,
    bool requireDeveloperOptionsOff = true,
  }) async {
    final sdkInt = await getAndroidSdkInt();
    final totalRam = await getTotalRam();
    final devOptionsCheck = await isDeveloperOptionsOff();
    final platformVersion = await getPlatformVersion();

    final versionSupported = sdkInt >= minSdk;
    
    // We use ceil() for verification to match the "Marketed" RAM requested by developers.
    final ramSufficient = totalRam.ceil() >= minRamGb;

    return DeviceGuardResult(
      isAndroidVersionSupported: versionSupported,
      isRamSufficient: ramSufficient,
      isDeveloperOptionsOff: devOptionsCheck,
      minSdk: minSdk,
      minRamGb: minRamGb,
      requireDeveloperOptionsOff: requireDeveloperOptionsOff,
      actualSdkInt: sdkInt,
      actualRamGb: totalRam,
      platformVersion: platformVersion,
    );
  }
}
