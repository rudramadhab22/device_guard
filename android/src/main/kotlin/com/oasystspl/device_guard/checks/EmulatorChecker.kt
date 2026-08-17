package com.oasystspl.device_guard.checks

import android.os.Build

object EmulatorChecker {
    fun isNotEmulator(): Boolean {
        return !(isEmulatorFingerprint() || isEmulatorBuild() || isEmulatorHardware())
    }

    private fun isEmulatorFingerprint(): Boolean {
        return Build.FINGERPRINT.startsWith("generic") ||
            Build.FINGERPRINT.lowercase().contains("vbox") ||
            Build.FINGERPRINT.lowercase().contains("test-keys") ||
            Build.MODEL.contains("google_sdk") ||
            Build.MODEL.contains("Emulator") ||
            Build.MODEL.contains("Android SDK built for x86") ||
            Build.MANUFACTURER.contains("Genymotion") ||
            Build.HARDWARE.contains("goldfish") ||
            Build.HARDWARE.contains("ranchu") ||
            Build.PRODUCT.contains("sdk") ||
            Build.PRODUCT.contains("emulator") ||
            Build.PRODUCT.contains("simulator")
    }

    private fun isEmulatorBuild(): Boolean {
        val brand = Build.BRAND ?: return false
        val device = Build.DEVICE ?: return false
        return brand.startsWith("generic") && device.startsWith("generic")
    }

    private fun isEmulatorHardware(): Boolean {
        val hardware = Build.HARDWARE?.lowercase() ?: return false
        return hardware.contains("goldfish") ||
            hardware.contains("ranchu") ||
            hardware.contains("vbox")
    }
}
