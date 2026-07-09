import 'src/platform/device_guard_platform_interface.dart';
import 'src/models/device_guard_result.dart';

export 'src/models/device_guard_result.dart';

/// The main class for the Device Guard plugin providing high-level security verification.
/// 
/// This plugin allows developers to verify device security conditions like:
/// * Minimum Android Version (API Level)
/// * Minimum RAM (Total Memory)
/// * Developer Options Status
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
  /// Uses ceil() on actual RAM for comparison (e.g., 5.32 GB is treated as 6 GB).
  Future<bool> isRamSufficient(int minRamGb) async {
    final totalRam = await getTotalRam();
    return totalRam.ceil() >= minRamGb;
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

  /// Performs security verification based on flexible requirements.
  /// 
  /// Pass only the parameters you want to validate.
  /// * [minSdk]: If provided, validates Android API level.
  /// * [minRamGb]: If provided, validates total RAM (Marketed value).
  /// * [requireDeveloperOptionsOff]: If provided, ensures Developer Options are OFF.
  /// 
  /// This method is highly flexible: you can use any one, any two, or all three checks.
  /// 
  /// Returns a [DeviceGuardResult] indicating the status of the requested checks.
  Future<DeviceGuardResult> verifyDeviceGuard({
    int? minSdk,
    int? minRamGb,
    bool? requireDeveloperOptionsOff,
  }) async {
    final sdkInt = await getAndroidSdkInt();
    final totalRam = await getTotalRam();
    final platformVersion = await getPlatformVersion();
    
    bool? versionSupported;
    if (minSdk != null) {
      versionSupported = sdkInt >= minSdk;
    }

    bool? ramSufficient;
    if (minRamGb != null) {
      // Comparison uses the rounded up (ceil) value for Marketed RAM.
      ramSufficient = totalRam.ceil() >= minRamGb;
    }

    bool? devOptionsOff;
    if (requireDeveloperOptionsOff != null) {
      devOptionsOff = await isDeveloperOptionsOff();
    }

    return DeviceGuardResult(
      isAndroidVersionSupported: versionSupported,
      isRamSufficient: ramSufficient,
      isDeveloperOptionsOff: devOptionsOff,
      minSdk: minSdk,
      minRamGb: minRamGb,
      requireDeveloperOptionsOff: requireDeveloperOptionsOff,
      actualSdkInt: sdkInt,
      actualRamGb: totalRam,
      platformVersion: platformVersion,
    );
  }
}
