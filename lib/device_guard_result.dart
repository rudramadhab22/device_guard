import 'dart:math' as math;

/// Represents the combined results of all device security checks.
class DeviceGuardResult {
  /// True if the Android version meets the [minSdk] requirement.
  final bool isAndroidVersionSupported;
  
  /// True if the device has at least [minRamGb] of RAM.
  final bool isRamSufficient;
  
  /// True if Developer Options are turned off.
  final bool isDeveloperOptionsOff;

  /// The minimum SDK requirement used for this check.
  final int minSdk;

  /// The minimum RAM requirement used for this check.
  final int minRamGb;

  /// Whether Developer Options were required to be off.
  final bool requireDeveloperOptionsOff;

  /// The actual Android SDK version (API Level) found on the device.
  final int actualSdkInt;

  /// The actual total RAM found on the device in GB.
  final double actualRamGb;

  /// The actual platform version string (e.g., "Android 14").
  final String? platformVersion;

  DeviceGuardResult({
    required this.isAndroidVersionSupported,
    required this.isRamSufficient,
    required this.isDeveloperOptionsOff,
    required this.minSdk,
    required this.minRamGb,
    required this.requireDeveloperOptionsOff,
    required this.actualSdkInt,
    required this.actualRamGb,
    this.platformVersion,
  });

  /// Returns `true` only if ALL required security conditions are satisfied.
  bool get isValid =>
      isAndroidVersionSupported && 
      isRamSufficient && 
      (!requireDeveloperOptionsOff || isDeveloperOptionsOff);

  /// Returns the actual RAM rounded to the nearest integer (e.g., 5.32 -> 6).
  /// This is often what users expect to see as the "Marketed" RAM.
  int get displayRamGb => actualRamGb.ceil();

  /// Returns a user-friendly error message listing all failed security checks.
  String get errorMessage {
    List<String> errors = [];
    if (!isAndroidVersionSupported) {
      errors.add("Android version is too old (Found: ${platformVersion ?? 'API $actualSdkInt'}).");
    }
    if (!isRamSufficient) {
      errors.add("Device must have at least $minRamGb GB of RAM (Found: $displayRamGb GB).");
    }
    if (requireDeveloperOptionsOff && !isDeveloperOptionsOff) {
      errors.add("Developer options must be turned off.");
    }
    return errors.join("\n");
  }
}
