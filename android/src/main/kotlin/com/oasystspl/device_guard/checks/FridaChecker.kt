package com.oasystspl.device_guard.checks

import java.io.BufferedReader
import java.io.File
import java.io.FileReader
import java.net.InetSocketAddress
import java.net.Socket

object FridaChecker {
    private val fridaArtifacts = listOf(
        "frida-server",
        "frida-agent",
        "frida-gadget",
        "libfrida",
        "re.frida.server",
    )

    fun isFridaAbsent(): Boolean {
        return !hasFridaPort() && !hasFridaMaps() && !hasFridaFiles()
    }

    private fun hasFridaPort(): Boolean {
        val ports = listOf(27042, 27043)
        return ports.any { port ->
            try {
                Socket().use { socket ->
                    socket.connect(InetSocketAddress("127.0.0.1", port), 200)
                    true
                }
            } catch (_: Exception) {
                false
            }
        }
    }

    private fun hasFridaMaps(): Boolean {
        return try {
            BufferedReader(FileReader("/proc/self/maps")).use { reader ->
                reader.lineSequence().any { line ->
                    fridaArtifacts.any { artifact ->
                        line.lowercase().contains(artifact)
                    }
                }
            }
        } catch (_: Exception) {
            false
        }
    }

    private fun hasFridaFiles(): Boolean {
        val paths = listOf(
            "/data/local/tmp/frida-server",
            "/data/local/tmp/re.frida.server",
            "/sdcard/frida-server",
        )
        return paths.any { File(it).exists() }
    }
}
