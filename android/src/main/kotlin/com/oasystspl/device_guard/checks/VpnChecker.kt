package com.oasystspl.device_guard.checks

import android.content.Context
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.os.Build
import java.net.NetworkInterface

object VpnChecker {
    fun isVpnOff(context: Context): Boolean {
        return !hasVpnTransport(context) && !hasVpnInterface()
    }

    private fun hasVpnTransport(context: Context): Boolean {
        return try {
            val connectivityManager =
                context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                val network = connectivityManager.activeNetwork ?: return false
                val capabilities =
                    connectivityManager.getNetworkCapabilities(network) ?: return false
                capabilities.hasTransport(NetworkCapabilities.TRANSPORT_VPN)
            } else {
                @Suppress("DEPRECATION")
                connectivityManager.allNetworks.any { network ->
                    @Suppress("DEPRECATION")
                    val info = connectivityManager.getNetworkInfo(network)
                    info != null && info.typeName.equals("VPN", ignoreCase = true)
                }
            }
        } catch (_: SecurityException) {
            false
        } catch (_: Exception) {
            false
        }
    }

    private fun hasVpnInterface(): Boolean {
        return try {
            NetworkInterface.getNetworkInterfaces().toList().any { networkInterface ->
                networkInterface.isUp &&
                    (networkInterface.name.startsWith("tun") ||
                        networkInterface.name.startsWith("ppp") ||
                        networkInterface.name.startsWith("tap") ||
                        networkInterface.name.startsWith("wg") ||
                        networkInterface.name.startsWith("utun"))
            }
        } catch (_: Exception) {
            false
        }
    }
}
