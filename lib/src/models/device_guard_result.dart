/// Represents the combined results of all device security checks.
/// 
/// This model holds both the requirements requested by the developer
/// and the actual values found on the device.
class DeviceGuardResult {
  /// True if the Android version meets the [minSdk] requirement.
  /// Null if this check was not performed.
  final bool? isAndroidVersionSupported;
  
  /// True if the device has at least [minRamGb] of RAM.
  /// Null if this check was not performed.
  final bool? isRamSufficient;
  
  /// True if Developer Options are turned off.
  /// Null if this check was not performed.
  final bool? isDeveloperOptionsOff;

  /// The minimum SDK requirement used for this check.
  final int? minSdk;

  /// The minimum RAM requirement used for this check.
  final int? minRamGb;

  /// Whether Developer Options were required to be off.
  final bool? requireDeveloperOptionsOff;

  /// The actual Android SDK version (API Level) found on the device.
  final int actualSdkInt;

  /// The actual total RAM found on the device in GB.
  final double actualRamGb;

  /// The actual platform version string (e.g., "Android 14").
  final String? platformVersion;

  DeviceGuardResult({
    this.isAndroidVersionSupported,
    this.isRamSufficient,
    this.isDeveloperOptionsOff,
    this.minSdk,
    this.minRamGb,
    this.requireDeveloperOptionsOff,
    required this.actualSdkInt,
    required this.actualRamGb,
    this.platformVersion,
  });

  /// Returns `true` only if ALL performed security checks are satisfied.
  bool get isValid {
    final versionOk = isAndroidVersionSupported ?? true;
    final ramOk = isRamSufficient ?? true;
    final devOptionsOk = isDeveloperOptionsOk;
    
    return versionOk && ramOk && devOptionsOk;
  }

  /// Helper to check if Developer Options requirement is satisfied.
  bool get isDeveloperOptionsOk {
    if (requireDeveloperOptionsOff == true) {
      return isDeveloperOptionsOff ?? true;
    }
    return true;
  }

  /// Returns the actual RAM rounded up to the nearest integer.
  /// Example: 5.32 GB -> 6 GB.
  int get displayRamGb => actualRamGb.ceil();

  /// Returns a user-friendly error message listing all failed security checks.
  String get errorMessage {
    List<String> errors = [];
    if (isAndroidVersionSupported == false) {
      errors.add("Android version must be API $minSdk or higher (Found: $actualSdkInt).");
    }
    if (isRamSufficient == false) {
      errors.add("Device must have at least $minRamGb GB of RAM (Found: $displayRamGb GB).");
    }
    if (isDeveloperOptionsOff == false && requireDeveloperOptionsOff == true) {
      errors.add("Developer options must be turned off.");
    }
    return errors.join("\n");
  }
}
