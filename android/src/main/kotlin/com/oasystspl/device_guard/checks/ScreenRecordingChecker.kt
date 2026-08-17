package com.oasystspl.device_guard.checks

import android.content.Context
import android.hardware.display.DisplayManager
import android.view.Display

object ScreenRecordingChecker {
    fun isScreenRecordingOff(context: Context): Boolean {
        return !hasVirtualDisplay(context)
    }

    private fun hasVirtualDisplay(context: Context): Boolean {
        val displayManager =
            context.getSystemService(Context.DISPLAY_SERVICE) as DisplayManager
        return displayManager.displays.any { display ->
            display.displayId != Display.DEFAULT_DISPLAY &&
                display.flags and Display.FLAG_PRESENTATION == 0
        }
    }
}
