import Flutter
import UIKit

public class DeviceGuardPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "device_guard", binaryMessenger: registrar.messenger())
    let instance = DeviceGuardPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "isDeveloperOptionsOff":
      result(DeveloperModeChecker.isDeveloperOptionsOff())
    case "getTotalRam":
      result(RamChecker.getTotalRamGb())
    case "isNotRooted":
      result(JailbreakChecker.isNotRooted())
    case "isNotEmulator":
      result(SimulatorChecker.isNotEmulator())
    case "isUsbDebuggingOff":
      result(UsbDebuggingChecker.isUsbDebuggingOff())
    case "isMockLocationOff":
      result(MockLocationChecker.isMockLocationOff())
    case "isVpnOff":
      result(VpnChecker.isVpnOff())
    case "isScreenRecordingOff":
      result(ScreenRecordingChecker.isScreenRecordingOff())
    case "isScreenSharingOff":
      result(ScreenSharingChecker.isScreenSharingOff())
    case "hasNoOverlayApps":
      result(OverlayAppsChecker.hasNoOverlayApps())
    case "isFridaAbsent":
      result(FridaChecker.isFridaAbsent())
    case "isMagiskAbsent":
      result(MagiskChecker.isMagiskAbsent())
    case "isXposedAbsent":
      result(XposedChecker.isXposedAbsent())
    case "isAndroidVersionSupported", "getAndroidSdkInt", "isRamSufficient":
      result(false)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
