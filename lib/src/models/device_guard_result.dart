/// Combined results of all device security checks.
///
/// Nullable boolean fields mean the check was not requested.
/// When a check is requested, `true` means the requirement passed.
class DeviceGuardResult {
  final bool? isAndroidVersionSupported;
  final bool? isRamSufficient;
  final bool? isDeveloperOptionsOff;
  final bool? isNotRooted;
  final bool? isNotEmulator;
  final bool? isUsbDebuggingOff;
  final bool? isMockLocationOff;
  final bool? isVpnOff;
  final bool? isScreenRecordingOff;
  final bool? isScreenSharingOff;
  final bool? hasNoOverlayApps;
  final bool? isFridaAbsent;
  final bool? isMagiskAbsent;
  final bool? isXposedAbsent;

  final int? minSdk;
  final int? minRamGb;
  final bool? requireDeveloperOptionsOff;
  final bool? requireNotRooted;
  final bool? requireNotEmulator;
  final bool? requireUsbDebuggingOff;
  final bool? requireMockLocationOff;
  final bool? requireNoVpn;
  final bool? requireNoScreenRecording;
  final bool? requireNoScreenSharing;
  final bool? requireNoOverlayApps;
  final bool? requireNoFrida;
  final bool? requireNoMagisk;
  final bool? requireNoXposed;

  final int actualSdkInt;
  final double actualRamGb;
  final String? platformVersion;

  DeviceGuardResult({
    this.isAndroidVersionSupported,
    this.isRamSufficient,
    this.isDeveloperOptionsOff,
    this.isNotRooted,
    this.isNotEmulator,
    this.isUsbDebuggingOff,
    this.isMockLocationOff,
    this.isVpnOff,
    this.isScreenRecordingOff,
    this.isScreenSharingOff,
    this.hasNoOverlayApps,
    this.isFridaAbsent,
    this.isMagiskAbsent,
    this.isXposedAbsent,
    this.minSdk,
    this.minRamGb,
    this.requireDeveloperOptionsOff,
    this.requireNotRooted,
    this.requireNotEmulator,
    this.requireUsbDebuggingOff,
    this.requireMockLocationOff,
    this.requireNoVpn,
    this.requireNoScreenRecording,
    this.requireNoScreenSharing,
    this.requireNoOverlayApps,
    this.requireNoFrida,
    this.requireNoMagisk,
    this.requireNoXposed,
    required this.actualSdkInt,
    required this.actualRamGb,
    this.platformVersion,
  });

  /// Returns `true` only if ALL performed security checks are satisfied.
  bool get isValid {
    return _pass(isAndroidVersionSupported) &&
        _pass(isRamSufficient) &&
        _passIfRequired(requireDeveloperOptionsOff, isDeveloperOptionsOff) &&
        _passIfRequired(requireNotRooted, isNotRooted) &&
        _passIfRequired(requireNotEmulator, isNotEmulator) &&
        _passIfRequired(requireUsbDebuggingOff, isUsbDebuggingOff) &&
        _passIfRequired(requireMockLocationOff, isMockLocationOff) &&
        _passIfRequired(requireNoVpn, isVpnOff) &&
        _passIfRequired(requireNoScreenRecording, isScreenRecordingOff) &&
        _passIfRequired(requireNoScreenSharing, isScreenSharingOff) &&
        _passIfRequired(requireNoOverlayApps, hasNoOverlayApps) &&
        _passIfRequired(requireNoFrida, isFridaAbsent) &&
        _passIfRequired(requireNoMagisk, isMagiskAbsent) &&
        _passIfRequired(requireNoXposed, isXposedAbsent);
  }

  bool _pass(bool? value) => value ?? true;

  bool _passIfRequired(bool? required, bool? value) {
    if (required != true) return true;
    return value ?? true;
  }

  int get displayRamGb => actualRamGb.ceil();

  String get errorMessage {
    final errors = <String>[];

    if (isAndroidVersionSupported == false) {
      errors.add(
        'Android version must be API $minSdk or higher (Found: $actualSdkInt).',
      );
    }
    if (isRamSufficient == false) {
      errors.add(
        'Device must have at least $minRamGb GB of RAM (Found: $displayRamGb GB).',
      );
    }
    if (isDeveloperOptionsOff == false && requireDeveloperOptionsOff == true) {
      errors.add('Developer options must be turned off.');
    }
    if (isNotRooted == false && requireNotRooted == true) {
      errors.add('Device must not be rooted or jailbroken.');
    }
    if (isNotEmulator == false && requireNotEmulator == true) {
      errors.add('Emulators and simulators are not allowed.');
    }
    if (isUsbDebuggingOff == false && requireUsbDebuggingOff == true) {
      errors.add('USB debugging must be turned off.');
    }
    if (isMockLocationOff == false && requireMockLocationOff == true) {
      errors.add('Mock location must be disabled.');
    }
    if (isVpnOff == false && requireNoVpn == true) {
      errors.add('VPN connections are not allowed.');
    }
    if (isScreenRecordingOff == false && requireNoScreenRecording == true) {
      errors.add('Screen recording must not be active.');
    }
    if (isScreenSharingOff == false && requireNoScreenSharing == true) {
      errors.add('Screen sharing/mirroring must not be active.');
    }
    if (hasNoOverlayApps == false && requireNoOverlayApps == true) {
      errors.add('Overlay apps must not be present.');
    }
    if (isFridaAbsent == false && requireNoFrida == true) {
      errors.add('Frida instrumentation must not be detected.');
    }
    if (isMagiskAbsent == false && requireNoMagisk == true) {
      errors.add('Magisk must not be detected.');
    }
    if (isXposedAbsent == false && requireNoXposed == true) {
      errors.add('Xposed framework must not be detected.');
    }

    return errors.join('\n');
  }
}
