import Foundation

enum XposedChecker {
  static func isXposedAbsent() -> Bool {
    // Xposed is Android-only.
    return true
  }
}
