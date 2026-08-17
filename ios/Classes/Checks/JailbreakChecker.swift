import Foundation
import UIKit

enum JailbreakChecker {
  static func isNotRooted() -> Bool {
    return !hasSuspiciousFiles() && !canWriteOutsideSandbox() && !hasSuspiciousSchemes()
  }

  private static func hasSuspiciousFiles() -> Bool {
    let paths = [
      "/Applications/Cydia.app",
      "/Library/MobileSubstrate/MobileSubstrate.dylib",
      "/bin/bash",
      "/usr/sbin/sshd",
      "/etc/apt",
      "/private/var/lib/apt/",
      "/private/var/stash",
      "/private/var/tmp/cydia.log",
      "/var/cache/apt",
      "/var/lib/cydia",
      "/usr/libexec/sftp-server",
      "/usr/bin/ssh",
    ]
    return paths.contains { FileManager.default.fileExists(atPath: $0) }
  }

  private static func canWriteOutsideSandbox() -> Bool {
    let testPath = "/private/jailbreak_test_\(UUID().uuidString).txt"
    do {
      try "test".write(toFile: testPath, atomically: true, encoding: .utf8)
      try FileManager.default.removeItem(atPath: testPath)
      return true
    } catch {
      return false
    }
  }

  private static func hasSuspiciousSchemes() -> Bool {
    guard let url = URL(string: "cydia://package/com.example.package") else {
      return false
    }
    return UIApplication.shared.canOpenURL(url)
  }
}
