import Foundation
import CFNetwork

enum VpnChecker {
  static func isVpnOff() -> Bool {
    guard let settings = CFNetworkCopySystemProxySettings()?.takeRetainedValue() as? [String: Any],
          let scoped = settings["__SCOPED__"] as? [String: Any] else {
      return true
    }

    let vpnKeys = ["tap", "tun", "ppp", "ipsec", "utun"]
    return !scoped.keys.contains { key in
      vpnKeys.contains { key.lowercased().contains($0) }
    }
  }
}
