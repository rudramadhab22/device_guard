package com.oasystspl.device_guard.checks

import android.content.Context
import android.provider.Settings

object UsbDebuggingChecker {
    fun isUsbDebuggingOff(context: Context): Boolean {
        val adbEnabled = Settings.Global.getInt(
            context.contentResolver,
            Settings.Global.ADB_ENABLED,
            0,
        )
        return adbEnabled == 0
    }
}
