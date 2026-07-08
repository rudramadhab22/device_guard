# device_guard

A highly configurable Flutter plugin to verify device security conditions before allowing user access.

## Features

Verify the following conditions with custom thresholds:
*   **Android Version**: Ensure the device is running a minimum API level.
*   **RAM Capacity**: Check if the device has enough total RAM (in GB).
*   **Developer Options**: Verify if Developer Options are disabled.

## Usage

### Simple Usage (Defaults)

By default, it checks for Android 14+, 4GB RAM, and Developer Options OFF.

```dart
final deviceGuard = DeviceGuard();
final result = await deviceGuard.verifyDeviceGuard();

if (result.isValid) {
  // Allow access
} else {
  print(result.errorMessage);
}
```

### Custom Requirements

You can specify your own security requirements:

```dart
final result = await deviceGuard.verifyDeviceGuard(
  minSdk: 30,             // Require Android 11+
  minRamGb: 6,            // Require 6GB RAM
  requireDeveloperOptionsOff: true, 
);

if (!result.isValid) {
  print("Blocked: ${result.errorMessage}");
  print("Required RAM: ${result.minSdk} GB, Found: ${result.actualRamGb} GB");
  print("Required API: ${result.minSdk}, Found: ${result.actualSdkInt}");
}
```

## Folder Structure

This plugin follows the recommended federated plugin architecture:
*   `lib/device_guard.dart`: Public API and result models.
*   `lib/src/`: Internal implementation and platform interface.

