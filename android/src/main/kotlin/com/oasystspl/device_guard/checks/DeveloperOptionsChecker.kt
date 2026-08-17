package com.oasystspl.device_guard.checks

import android.content.Context
import android.provider.Settings

object DeveloperOptionsChecker {
    fun isDeveloperOptionsOff(context: Context): Boolean {
        val devOptions = Settings.Global.getInt(
            context.contentResolver,
            Settings.Global.DEVELOPMENT_SETTINGS_ENABLED,
            0,
        )
        return devOptions == 0
    }
}
