package com.oasystspl.device_guard.checks

import android.app.ActivityManager
import android.content.Context
import kotlin.math.ceil

object RamChecker {
    fun getTotalRamGb(context: Context): Double {
        val activityManager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val memoryInfo = ActivityManager.MemoryInfo()
        activityManager.getMemoryInfo(memoryInfo)
        val bytesInGb = 1024.0 * 1024.0 * 1024.0
        return memoryInfo.totalMem.toDouble() / bytesInGb
    }

    fun isRamSufficient(context: Context, minRamGb: Int): Boolean {
        return ceil(getTotalRamGb(context)) >= minRamGb
    }
}
