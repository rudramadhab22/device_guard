package com.oasystspl.device_guard

import android.content.Context
import android.os.Build
import com.oasystspl.device_guard.checks.DeveloperOptionsChecker
import com.oasystspl.device_guard.checks.EmulatorChecker
import com.oasystspl.device_guard.checks.FridaChecker
import com.oasystspl.device_guard.checks.MagiskChecker
import com.oasystspl.device_guard.checks.MockLocationChecker
import com.oasystspl.device_guard.checks.OverlayAppsChecker
import com.oasystspl.device_guard.checks.RamChecker
import com.oasystspl.device_guard.checks.RootChecker
import com.oasystspl.device_guard.checks.ScreenRecordingChecker
import com.oasystspl.device_guard.checks.ScreenSharingChecker
import com.oasystspl.device_guard.checks.UsbDebuggingChecker
import com.oasystspl.device_guard.checks.VpnChecker
import com.oasystspl.device_guard.checks.XposedChecker
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class DeviceGuardPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "device_guard")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        try {
            when (call.method) {
                "getPlatformVersion" -> {
                    result.success("Android ${Build.VERSION.RELEASE}")
                }
                "isAndroidVersionSupported" -> {
                    val minSdk = call.argument<Int>("minSdk") ?: 34
                    result.success(Build.VERSION.SDK_INT >= minSdk)
                }
                "isRamSufficient" -> {
                    val minRamGb = call.argument<Int>("minRamGb") ?: 4
                    result.success(RamChecker.isRamSufficient(context, minRamGb))
                }
                "isDeveloperOptionsOff" -> {
                    result.success(DeveloperOptionsChecker.isDeveloperOptionsOff(context))
                }
                "getTotalRam" -> {
                    result.success(RamChecker.getTotalRamGb(context))
                }
                "getAndroidSdkInt" -> {
                    result.success(Build.VERSION.SDK_INT)
                }
                "isNotRooted" -> {
                    result.success(RootChecker.isNotRooted(context))
                }
                "isNotEmulator" -> {
                    result.success(EmulatorChecker.isNotEmulator())
                }
                "isUsbDebuggingOff" -> {
                    result.success(UsbDebuggingChecker.isUsbDebuggingOff(context))
                }
                "isMockLocationOff" -> {
                    result.success(MockLocationChecker.isMockLocationOff(context))
                }
                "isVpnOff" -> {
                    result.success(VpnChecker.isVpnOff(context))
                }
                "isScreenRecordingOff" -> {
                    result.success(ScreenRecordingChecker.isScreenRecordingOff(context))
                }
                "isScreenSharingOff" -> {
                    result.success(ScreenSharingChecker.isScreenSharingOff(context))
                }
                "hasNoOverlayApps" -> {
                    result.success(OverlayAppsChecker.hasNoOverlayApps(context))
                }
                "isFridaAbsent" -> {
                    result.success(FridaChecker.isFridaAbsent())
                }
                "isMagiskAbsent" -> {
                    result.success(MagiskChecker.isMagiskAbsent(context))
                }
                "isXposedAbsent" -> {
                    result.success(XposedChecker.isXposedAbsent(context))
                }
                else -> {
                    result.notImplemented()
                }
            }
        } catch (exception: Exception) {
            result.error("DEVICE_GUARD_ERROR", exception.message, null)
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        if (::channel.isInitialized) {
            channel.setMethodCallHandler(null)
        }
    }
}
