package com.oasystspl.device_guard.checks

import android.content.Context
import java.io.File

object MagiskChecker {
    private val magiskPaths = listOf(
        "/sbin/.magisk",
        "/sbin/.core/mirror",
        "/sbin/.core/img",
        "/data/adb/magisk",
        "/cache/magisk.log",
        "/data/adb/magisk.db",
        "/data/adb/magisk.img",
        "/data/adb/modules",
    )

    private val magiskPackages = listOf(
        "com.topjohnwu.magisk",
        "com.topjohnwu.magisk.debug",
    )

    fun isMagiskAbsent(context: Context): Boolean {
        return !hasMagiskPaths() && !hasMagiskPackages(context)
    }

    private fun hasMagiskPaths(): Boolean {
        return magiskPaths.any { File(it).exists() }
    }

    private fun hasMagiskPackages(context: Context): Boolean {
        val pm = context.packageManager
        return magiskPackages.any { pkg ->
            try {
                pm.getPackageInfo(pkg, 0)
                true
            } catch (_: Exception) {
                false
            }
        }
    }
}
