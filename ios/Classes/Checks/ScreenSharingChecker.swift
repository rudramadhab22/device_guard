import UIKit

enum ScreenSharingChecker {
  static func isScreenSharingOff() -> Bool {
    if #available(iOS 11.0, *) {
      if UIScreen.main.isCaptured {
        return false
      }
    }

    return UIScreen.screens.count <= 1
  }
}
