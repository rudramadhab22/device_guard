import Foundation

enum OverlayAppsChecker {
  static func hasNoOverlayApps() -> Bool {
    // iOS sandbox prevents overlay apps outside system APIs.
    return true
  }
}
