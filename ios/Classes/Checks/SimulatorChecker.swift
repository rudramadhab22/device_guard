import Foundation

enum SimulatorChecker {
  static func isNotEmulator() -> Bool {
    #if targetEnvironment(simulator)
      return false
    #else
      return !isSimulatorModel()
    #endif
  }

  private static func isSimulatorModel() -> Bool {
    var systemInfo = utsname()
    uname(&systemInfo)
    let model = withUnsafePointer(to: &systemInfo.machine) {
      $0.withMemoryRebound(to: CChar.self, capacity: 1) {
        String(validatingUTF8: $0) ?? ""
      }
    }
    return model.contains("x86") || model.contains("i386") || model.contains("arm64") && ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] != nil
  }
}
