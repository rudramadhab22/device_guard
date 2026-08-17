## 0.0.2

Initial release of Device Guard for Android and iOS.

### Added

* Loosely coupled `verifyDeviceGuard()` API — pass only the checks you need; omitted flags are skipped
* `useDefaults` plus `DeviceGuardDefaults` for a built-in security profile
* Device checks:
  * Android API level (`minSdk`)
  * RAM capacity (`minRamGb`)
  * Developer Options / Developer Mode
  * Root / Jailbreak
  * Emulator / Simulator
  * USB Debugging
  * Mock Location
  * VPN
  * Screen Recording
  * Screen Sharing
  * Overlay Apps
  * Frida
  * Magisk
  * Xposed
* `DeviceGuardResult` with nullable per-check fields, `isValid`, and `errorMessage`
* Individual check methods (`isNotRooted()`, `isVpnOff()`, …)
* Native Kotlin checkers on Android and Swift checkers on iOS
* `ACCESS_NETWORK_STATE` permission for VPN detection
* Example app with a scrollable results screen
