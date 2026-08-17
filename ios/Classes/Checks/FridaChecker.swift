import Foundation
import Darwin
import MachO

enum FridaChecker {
  static func isFridaAbsent() -> Bool {
    return !hasFridaPort() && !hasFridaDylib()
  }

  private static func hasFridaPort() -> Bool {
    let ports: [UInt16] = [27042, 27043]
    return ports.contains { port in
      let socket = socket(AF_INET, SOCK_STREAM, 0)
      defer { close(socket) }

      var addr = sockaddr_in()
      addr.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
      addr.sin_family = sa_family_t(AF_INET)
      addr.sin_port = port.bigEndian
      addr.sin_addr.s_addr = inet_addr("127.0.0.1")

      let result = withUnsafePointer(to: &addr) {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
          connect(socket, $0, socklen_t(MemoryLayout<sockaddr_in>.size))
        }
      }
      return result == 0
    }
  }

  private static func hasFridaDylib() -> Bool {
    let count = _dyld_image_count()
    for index in 0..<count {
      guard let name = _dyld_get_image_name(index) else { continue }
      let imageName = String(cString: name).lowercased()
      if imageName.contains("frida") || imageName.contains("gadget") {
        return true
      }
    }
    return false
  }
}
