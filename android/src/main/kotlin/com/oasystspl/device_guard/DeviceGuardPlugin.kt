package com.oasystspl.device_guard

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import android.content.Context
import android.app.ActivityManager
import android.provider.Settings
import android.os.Build

class DeviceGuardPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "device_guard")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
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
                result.success(isRamSufficient(minRamGb.toLong()))
            }
            "isDeveloperOptionsOff" -> {
                result.success(isDeveloperOptionsOff())
            }
            "getTotalRam" -> {
                result.success(getTotalRamGb())
            }
            "getAndroidSdkInt" -> {
                result.success(Build.VERSION.SDK_INT)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun getTotalRamGb(): Double {
        val activityManager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val memoryInfo = ActivityManager.MemoryInfo()
        activityManager.getMemoryInfo(memoryInfo)
        
        val totalRamBytes = memoryInfo.totalMem
        val bytesInGb = 1073741824.0 // 1024 * 1024 * 1024
        return totalRamBytes.toDouble() / bytesInGb
    }

    private fun isRamSufficient(minRamGb: Long): Boolean {
        val activityManager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val memoryInfo = ActivityManager.MemoryInfo()
        activityManager.getMemoryInfo(memoryInfo)
        val totalRamBytes = memoryInfo.totalMem
        val requiredBytes = minRamGb * 1024L * 1024L * 1024L
        return totalRamBytes >= requiredBytes
    }

    private fun isDeveloperOptionsOff(): Boolean {
        val devOptions = Settings.Global.getInt(
            context.contentResolver,
            Settings.Global.DEVELOPMENT_SETTINGS_ENABLED,
            0
        )
        return devOptions == 0
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        if (::channel.isInitialized) {
            channel.setMethodCallHandler(null)
        }
    }
}
