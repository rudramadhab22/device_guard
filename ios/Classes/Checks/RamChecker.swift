import Foundation

enum RamChecker {
  static func getTotalRamGb() -> Double {
    let bytes = ProcessInfo.processInfo.physicalMemory
    let bytesInGb = 1024.0 * 1024.0 * 1024.0
    return Double(bytes) / bytesInGb
  }
}
