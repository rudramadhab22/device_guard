import 'dart:io';

import 'src/models/device_guard_config.dart';
import 'src/platform/device_guard_platform_interface.dart';
import 'src/models/device_guard_result.dart';

export 'src/models/device_guard_config.dart';
export 'src/models/device_guard_result.dart';

/// High-level device security verification for Android and iOS.
class DeviceGuard {
  Future<String?> getPlatformVersion() {
    return DeviceGuardPlatform.instance.getPlatformVersion();
  }

  Future<bool> isAndroidVersionSupported(int minSdk) {
    return DeviceGuardPlatform.instance.isAndroidVersionSupported(minSdk);
  }

  Future<bool> isRamSufficient(int minRamGb) async {
    final totalRam = await getTotalRam();
    return totalRam.ceil() >= minRamGb;
  }

  Future<bool> isDeveloperOptionsOff() {
    return DeviceGuardPlatform.instance.isDeveloperOptionsOff();
  }

  Future<double> getTotalRam() {
    return DeviceGuardPlatform.instance.getTotalRam();
  }

  Future<int> getAndroidSdkInt() {
    return DeviceGuardPlatform.instance.getAndroidSdkInt();
  }

  Future<bool> isNotRooted() {
    return DeviceGuardPlatform.instance.isNotRooted();
  }

  Future<bool> isNotEmulator() {
    return DeviceGuardPlatform.instance.isNotEmulator();
  }

  Future<bool> isUsbDebuggingOff() {
    return DeviceGuardPlatform.instance.isUsbDebuggingOff();
  }

  Future<bool> isMockLocationOff() {
    return DeviceGuardPlatform.instance.isMockLocationOff();
  }

  Future<bool> isVpnOff() {
    return DeviceGuardPlatform.instance.isVpnOff();
  }

  Future<bool> isScreenRecordingOff() {
    return DeviceGuardPlatform.instance.isScreenRecordingOff();
  }

  Future<bool> isScreenSharingOff() {
    return DeviceGuardPlatform.instance.isScreenSharingOff();
  }

  Future<bool> hasNoOverlayApps() {
    return DeviceGuardPlatform.instance.hasNoOverlayApps();
  }

  Future<bool> isFridaAbsent() {
    return DeviceGuardPlatform.instance.isFridaAbsent();
  }

  Future<bool> isMagiskAbsent() {
    return DeviceGuardPlatform.instance.isMagiskAbsent();
  }

  Future<bool> isXposedAbsent() {
    return DeviceGuardPlatform.instance.isXposedAbsent();
  }

  /// Performs security verification based on flexible requirements.
  ///
  /// Pass only the parameters you want to validate. Omitted parameters skip
  /// that check. Set [useDefaults] to `true` to apply [DeviceGuardDefaults]
  /// for any parameter you leave null.
  Future<DeviceGuardResult> verifyDeviceGuard({
    bool useDefaults = false,
    int? minSdk,
    int? minRamGb,
    bool? requireDeveloperOptionsOff,
    bool? requireNotRooted,
    bool? requireNotEmulator,
    bool? requireUsbDebuggingOff,
    bool? requireMockLocationOff,
    bool? requireNoVpn,
    bool? requireNoScreenRecording,
    bool? requireNoScreenSharing,
    bool? requireNoOverlayApps,
    bool? requireNoFrida,
    bool? requireNoMagisk,
    bool? requireNoXposed,
  }) async {
    final effectiveMinSdk =
        minSdk ?? (useDefaults ? DeviceGuardDefaults.minSdk : null);
    final effectiveMinRamGb =
        minRamGb ?? (useDefaults ? DeviceGuardDefaults.minRamGb : null);
    final effectiveRequireDeveloperOptionsOff = requireDeveloperOptionsOff ??
        (useDefaults ? DeviceGuardDefaults.requireDeveloperOptionsOff : null);
    final effectiveRequireNotRooted = requireNotRooted ??
        (useDefaults ? DeviceGuardDefaults.requireNotRooted : null);
    final effectiveRequireNotEmulator = requireNotEmulator ??
        (useDefaults ? DeviceGuardDefaults.requireNotEmulator : null);
    final effectiveRequireUsbDebuggingOff = requireUsbDebuggingOff ??
        (useDefaults ? DeviceGuardDefaults.requireUsbDebuggingOff : null);
    final effectiveRequireMockLocationOff = requireMockLocationOff ??
        (useDefaults ? DeviceGuardDefaults.requireMockLocationOff : null);
    final effectiveRequireNoVpn =
        requireNoVpn ?? (useDefaults ? DeviceGuardDefaults.requireNoVpn : null);
    final effectiveRequireNoScreenRecording = requireNoScreenRecording ??
        (useDefaults ? DeviceGuardDefaults.requireNoScreenRecording : null);
    final effectiveRequireNoScreenSharing = requireNoScreenSharing ??
        (useDefaults ? DeviceGuardDefaults.requireNoScreenSharing : null);
    final effectiveRequireNoOverlayApps = requireNoOverlayApps ??
        (useDefaults ? DeviceGuardDefaults.requireNoOverlayApps : null);
    final effectiveRequireNoFrida = requireNoFrida ??
        (useDefaults ? DeviceGuardDefaults.requireNoFrida : null);
    final effectiveRequireNoMagisk = requireNoMagisk ??
        (useDefaults ? DeviceGuardDefaults.requireNoMagisk : null);
    final effectiveRequireNoXposed = requireNoXposed ??
        (useDefaults ? DeviceGuardDefaults.requireNoXposed : null);

    final sdkInt = Platform.isAndroid ? await getAndroidSdkInt() : 0;
    final totalRam = await getTotalRam();
    final platformVersion = await getPlatformVersion();

    bool? versionSupported;
    if (effectiveMinSdk != null && Platform.isAndroid) {
      versionSupported = sdkInt >= effectiveMinSdk;
    }

    bool? ramSufficient;
    if (effectiveMinRamGb != null) {
      ramSufficient = totalRam.ceil() >= effectiveMinRamGb;
    }

    bool? devOptionsOff;
    if (effectiveRequireDeveloperOptionsOff != null) {
      devOptionsOff = await isDeveloperOptionsOff();
    }

    bool? notRooted;
    if (effectiveRequireNotRooted != null) {
      notRooted = await isNotRooted();
    }

    bool? notEmulator;
    if (effectiveRequireNotEmulator != null) {
      notEmulator = await isNotEmulator();
    }

    bool? usbDebuggingOff;
    if (effectiveRequireUsbDebuggingOff != null) {
      usbDebuggingOff = await isUsbDebuggingOff();
    }

    bool? mockLocationOff;
    if (effectiveRequireMockLocationOff != null) {
      mockLocationOff = await isMockLocationOff();
    }

    bool? vpnOff;
    if (effectiveRequireNoVpn != null) {
      vpnOff = await isVpnOff();
    }

    bool? screenRecordingOff;
    if (effectiveRequireNoScreenRecording != null) {
      screenRecordingOff = await isScreenRecordingOff();
    }

    bool? screenSharingOff;
    if (effectiveRequireNoScreenSharing != null) {
      screenSharingOff = await isScreenSharingOff();
    }

    bool? noOverlayApps;
    if (effectiveRequireNoOverlayApps != null) {
      noOverlayApps = await hasNoOverlayApps();
    }

    bool? fridaAbsent;
    if (effectiveRequireNoFrida != null) {
      fridaAbsent = await isFridaAbsent();
    }

    bool? magiskAbsent;
    if (effectiveRequireNoMagisk != null) {
      magiskAbsent = await isMagiskAbsent();
    }

    bool? xposedAbsent;
    if (effectiveRequireNoXposed != null) {
      xposedAbsent = await isXposedAbsent();
    }

    return DeviceGuardResult(
      isAndroidVersionSupported: versionSupported,
      isRamSufficient: ramSufficient,
      isDeveloperOptionsOff: devOptionsOff,
      isNotRooted: notRooted,
      isNotEmulator: notEmulator,
      isUsbDebuggingOff: usbDebuggingOff,
      isMockLocationOff: mockLocationOff,
      isVpnOff: vpnOff,
      isScreenRecordingOff: screenRecordingOff,
      isScreenSharingOff: screenSharingOff,
      hasNoOverlayApps: noOverlayApps,
      isFridaAbsent: fridaAbsent,
      isMagiskAbsent: magiskAbsent,
      isXposedAbsent: xposedAbsent,
      minSdk: effectiveMinSdk,
      minRamGb: effectiveMinRamGb,
      requireDeveloperOptionsOff: effectiveRequireDeveloperOptionsOff,
      requireNotRooted: effectiveRequireNotRooted,
      requireNotEmulator: effectiveRequireNotEmulator,
      requireUsbDebuggingOff: effectiveRequireUsbDebuggingOff,
      requireMockLocationOff: effectiveRequireMockLocationOff,
      requireNoVpn: effectiveRequireNoVpn,
      requireNoScreenRecording: effectiveRequireNoScreenRecording,
      requireNoScreenSharing: effectiveRequireNoScreenSharing,
      requireNoOverlayApps: effectiveRequireNoOverlayApps,
      requireNoFrida: effectiveRequireNoFrida,
      requireNoMagisk: effectiveRequireNoMagisk,
      requireNoXposed: effectiveRequireNoXposed,
      actualSdkInt: sdkInt,
      actualRamGb: totalRam,
      platformVersion: platformVersion,
    );
  }
}
