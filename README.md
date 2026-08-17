# Device Guard

**A loosely coupled Flutter plugin for Android and iOS device security checks.**

Pass only the checks you need. Skip the rest. Sensible defaults when you want them.

<p>
  <img alt="Platforms" src="https://img.shields.io/badge/platforms-Android%20%7C%20iOS-1E88E5?style=flat-square">
  <img alt="Flutter" src="https://img.shields.io/badge/Flutter-plugin-02569B?style=flat-square&logo=flutter&logoColor=white">
  <img alt="License" src="https://img.shields.io/badge/license-MIT-2E7D32?style=flat-square">
</p>

---

## Why Device Guard?

Banking, fintech, and enterprise apps often need to block compromised or non-compliant devices **before** the user reaches sensitive screens.

Device Guard keeps that logic **opt-in**:

| You pass | What happens |
|----------|----------------|
| `requireNotRooted: true` | Root / jailbreak is checked |
| omit the flag | That check is skipped |
| `useDefaults: true` | Built-in profile is applied for anything you leave null |

`result.isValid` is `true` only when **every requested check** passes.

---

## Checks

| Check | Flag | Android | iOS | Default |
|-------|------|:-------:|:---:|:-------:|
| Android API level | `minSdk` | Yes | — | `34` |
| RAM (GB, marketed / ceil) | `minRamGb` | Yes | Yes | `4` |
| Developer Options / Mode | `requireDeveloperOptionsOff` | Yes | Yes | `true` |
| Root / Jailbreak | `requireNotRooted` | Yes | Yes | `true` |
| Emulator / Simulator | `requireNotEmulator` | Yes | Yes | `true` |
| USB Debugging | `requireUsbDebuggingOff` | Yes | N/A | `false` |
| Mock Location | `requireMockLocationOff` | Yes | Yes | `false` |
| VPN | `requireNoVpn` | Yes | Yes | `false` |
| Screen Recording | `requireNoScreenRecording` | Yes | Yes | `false` |
| Screen Sharing | `requireNoScreenSharing` | Yes | Yes | `false` |
| Overlay Apps | `requireNoOverlayApps` | Yes | N/A | `false` |
| Frida | `requireNoFrida` | Yes | Yes | `false` |
| Magisk | `requireNoMagisk` | Yes | N/A | `false` |
| Xposed | `requireNoXposed` | Yes | N/A | `false` |

N/A checks return a safe pass on iOS (the threat does not apply).

---

## Install

```yaml
dependencies:
  device_guard:
    path: ../device_guard   # or your published version
```

```dart
import 'package:device_guard/device_guard.dart';
```

---

## Usage

### 1. Defaults

Applies `DeviceGuardDefaults` for any flag you do not override:

```dart
final deviceGuard = DeviceGuard();
final result = await deviceGuard.verifyDeviceGuard(useDefaults: true);

if (result.isValid) {
  // Allow access
} else {
  debugPrint(result.errorMessage);
}
```

Default profile:

- Android API **34+**
- **4 GB** RAM
- Developer Options **off**
- Not rooted / jailbroken
- Physical device (not emulator / simulator)

### 2. Pick only what you need

```dart
final result = await deviceGuard.verifyDeviceGuard(
  minSdk: 33,
  minRamGb: 6,
  requireDeveloperOptionsOff: true,
  requireNotRooted: true,
  requireNotEmulator: true,
  requireNoVpn: true,
  requireNoFrida: true,
);

if (!result.isValid) {
  debugPrint('Blocked:\n${result.errorMessage}');
}
```

### 3. Mix defaults with overrides

```dart
final result = await deviceGuard.verifyDeviceGuard(
  useDefaults: true,
  minSdk: 33,                 // override default 34
  requireNoVpn: true,         // extra check
  requireNoFrida: true,
  requireNoMagisk: true,
  requireNoXposed: true,
);
```

### 4. Individual checks

```dart
final clean = await deviceGuard.isNotRooted();
final noVpn = await deviceGuard.isVpnOff();
final noFrida = await deviceGuard.isFridaAbsent();
```

---

## Result

Every requested check is a nullable `bool` on `DeviceGuardResult`:

- `null` → not requested
- `true` → passed
- `false` → failed

```dart
result.isValid;                 // all requested checks passed
result.errorMessage;            // human-readable failures
result.actualSdkInt;            // device API (0 on iOS)
result.actualRamGb;             // raw RAM in GB
result.displayRamGb;            // ceil / marketed GB
result.platformVersion;         // e.g. "Android 15"
result.isNotRooted;             // true / false / null
```

---

## Architecture

Same pattern on both platforms: **one checker per concern**, wired through a MethodChannel.

```
lib/device_guard.dart              Public API
lib/src/models/                    Result + DeviceGuardDefaults
lib/src/platform/                  Federated platform interface

android/.../checks/                Kotlin checkers
ios/Classes/Checks/                Swift checkers
```

Host apps never depend on native types. They only pass `true` / `false` / omit.

---

## Android notes

The plugin declares `ACCESS_NETWORK_STATE` for VPN detection. It is merged into the host app automatically.

Rebuild the app after adding the plugin (hot reload does not pick up new permissions).

---

## Example

The `example/` app shows every check on a scrollable results screen. Configure which checks run in:

`example/lib/src/utils/app_utils.dart`

```dart
return plugin.verifyDeviceGuard(
  useDefaults: true,
  minSdk: 33,
  requireNoVpn: true,
  requireNoFrida: true,
);
```
