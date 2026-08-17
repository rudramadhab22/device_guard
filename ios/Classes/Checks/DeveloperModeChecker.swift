import Foundation

enum DeveloperModeChecker {
  static func isDeveloperOptionsOff() -> Bool {
    #if targetEnvironment(simulator)
      return true
    #else
      return !hasDeveloperDiskImage()
    #endif
  }

  private static func hasDeveloperDiskImage() -> Bool {
    let paths = [
      "/Developer",
      "/private/var/mobile/Library/MobileInstallation/Staging",
    ]
    return paths.contains { FileManager.default.fileExists(atPath: $0) }
  }
}
