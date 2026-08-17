/// Default thresholds and opt-in security flags for [DeviceGuard.verifyDeviceGuard].
///
/// Pass individual overrides to `verifyDeviceGuard` or spread [defaults] and
/// change only what you need. Null means the check is skipped.
class DeviceGuardDefaults {
  DeviceGuardDefaults._();

  /// Default minimum Android API level (Android 14).
  static const int minSdk = 34;

  /// Default minimum total RAM in GB (marketed value, uses ceil).
  static const int minRamGb = 4;

  /// Require Developer Options to be disabled.
  static const bool requireDeveloperOptionsOff = true;

  /// Require device to be not rooted (Android) / not jailbroken (iOS).
  static const bool requireNotRooted = true;

  /// Require device to be a physical device, not an emulator/simulator.
  static const bool requireNotEmulator = true;

  /// Require USB debugging to be disabled (Android). Ignored on iOS.
  static const bool requireUsbDebuggingOff = false;

  /// Require mock/simulated location to be disabled.
  static const bool requireMockLocationOff = false;

  /// Require no active VPN connection.
  static const bool requireNoVpn = false;

  /// Require no active screen recording.
  static const bool requireNoScreenRecording = false;

  /// Require no active screen sharing / mirroring.
  static const bool requireNoScreenSharing = false;

  /// Require no overlay apps with draw-on-top permission (Android).
  static const bool requireNoOverlayApps = false;

  /// Require Frida instrumentation to be absent.
  static const bool requireNoFrida = false;

  /// Require Magisk to be absent (Android only).
  static const bool requireNoMagisk = false;

  /// Require Xposed framework to be absent (Android only).
  static const bool requireNoXposed = false;
}
