import UIKit

enum ScreenRecordingChecker {
  static func isScreenRecordingOff() -> Bool {
    if #available(iOS 11.0, *) {
      return !UIScreen.main.isCaptured
    }
    return true
  }
}
