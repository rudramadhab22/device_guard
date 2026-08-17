import Foundation

enum MockLocationChecker {
  static func isMockLocationOff() -> Bool {
    // iOS does not expose mock location status without location permissions.
    // Treat as off unless known jailbreak location-spoofing tools are present.
    let spoofingPaths = [
      "/Library/MobileSubstrate/DynamicLibraries/LocationFaker.dylib",
      "/Library/MobileSubstrate/DynamicLibraries/Relocate.dylib",
    ]
    return !spoofingPaths.contains { FileManager.default.fileExists(atPath: $0) }
  }
}
