import 'package:device_guard/device_guard.dart';

class AppUtils {
  /// Converts an Android SDK API level to its major version name.
  static String getAndroidVersion(int? sdk) {
    if (sdk == null) return 'Unknown';
    if (sdk >= 35) return '15';
    if (sdk >= 34) return '14';
    if (sdk >= 33) return '13';
    if (sdk >= 32) return '12L';
    if (sdk >= 31) return '12';
    if (sdk >= 30) return '11';
    if (sdk >= 29) return '10';
    if (sdk >= 28) return '9';
    if (sdk >= 27) return '8.1';
    if (sdk >= 26) return '8.0';
    return 'API $sdk';
  }

  /// Formats the RAM display value.
  static String formatRam(double? ram) {
    if (ram == null) return '0 GB';
    // Marketed RAM is usually the ceiling of the actual reported RAM
    return '${ram.ceil()} GB';
  }

  /// Performs the standard security checks for the application.
  static Future<DeviceGuardResult> performChecks(DeviceGuard plugin) async {
    // Requirements: Android > 12 (API 33+), RAM >= 6GB, Dev Options OFF
    return await plugin.verifyDeviceGuard(
      minSdk: 33,
      minRamGb: 6,
      requireDeveloperOptionsOff: true,
    );
  }
}
