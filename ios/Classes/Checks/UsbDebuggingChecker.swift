import Foundation

enum UsbDebuggingChecker {
  static func isUsbDebuggingOff() -> Bool {
    // iOS does not expose USB debugging in the same way as Android.
    return true
  }
}
