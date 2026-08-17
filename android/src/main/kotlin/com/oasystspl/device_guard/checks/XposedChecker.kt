package com.oasystspl.device_guard.checks

import android.content.Context
import java.io.File

object XposedChecker {
    private val xposedPaths = listOf(
        "/system/framework/XposedBridge.jar",
        "/system/lib/libxposed_art.so",
        "/system/lib64/libxposed_art.so",
        "/system/xposed.prop",
        "/data/data/de.robv.android.xposed.installer",
    )

    private val xposedPackages = listOf(
        "de.robv.android.xposed.installer",
        "io.va.exposed",
        "org.meowcat.edxposed.manager",
        "org.lsposed.manager",
    )

    fun isXposedAbsent(context: Context): Boolean {
        return !hasXposedPaths() &&
            !hasXposedPackages(context) &&
            !hasXposedStackTrace()
    }

    private fun hasXposedPaths(): Boolean {
        return xposedPaths.any { File(it).exists() }
    }

    private fun hasXposedPackages(context: Context): Boolean {
        val pm = context.packageManager
        return xposedPackages.any { pkg ->
            try {
                pm.getPackageInfo(pkg, 0)
                true
            } catch (_: Exception) {
                false
            }
        }
    }

    private fun hasXposedStackTrace(): Boolean {
        return try {
            throw Exception("xposed_probe")
        } catch (exception: Exception) {
            exception.stackTrace.any { element ->
                element.className.lowercase().contains("xposed")
            }
        }
    }
}
