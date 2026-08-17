package com.oasystspl.device_guard.checks

import android.app.AppOpsManager
import android.content.Context
import android.os.Build
import android.provider.Settings

object MockLocationChecker {
    fun isMockLocationOff(context: Context): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            return !hasMockLocationAppOps(context)
        }

        @Suppress("DEPRECATION")
        val allowMockLocation = Settings.Secure.getInt(
            context.contentResolver,
            Settings.Secure.ALLOW_MOCK_LOCATION,
            0,
        )
        return allowMockLocation == 0
    }

    private fun hasMockLocationAppOps(context: Context): Boolean {
        return try {
            val appOps = context.getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
            val mockLocation = Settings.Secure.getString(
                context.contentResolver,
                "mock_location",
            )
            if (!mockLocation.isNullOrEmpty()) {
                return true
            }

            @Suppress("DEPRECATION")
            val packages = context.packageManager.getInstalledPackages(0)
            packages.any { pkg ->
                val applicationInfo = pkg.applicationInfo ?: return@any false
                @Suppress("DEPRECATION")
                val mode = appOps.checkOpNoThrow(
                    AppOpsManager.OPSTR_MOCK_LOCATION,
                    applicationInfo.uid,
                    pkg.packageName,
                )
                mode == AppOpsManager.MODE_ALLOWED
            }
        } catch (_: Exception) {
            false
        }
    }
}
