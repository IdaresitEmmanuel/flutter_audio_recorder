package com.hyequest.audiorecorder.data

import android.Manifest
import android.content.pm.PackageManager
import androidx.activity.ComponentActivity
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import androidx.core.content.ContextCompat
import kotlinx.coroutines.suspendCancellableCoroutine
import kotlin.coroutines.resume

class PermissionManager(private val activity: ComponentActivity) {

    private lateinit var requestPermissionLauncher: ActivityResultLauncher<String>
    private var continuation: kotlin.coroutines.Continuation<Boolean>? = null

    init {
        setupPermissionLauncher()
    }

    private fun setupPermissionLauncher() {
        requestPermissionLauncher = activity.registerForActivityResult(
            ActivityResultContracts.RequestPermission()
        ) { isGranted: Boolean ->
            continuation?.resume(isGranted)
            continuation = null
        }
    }

    suspend fun requestAudioPermission(): Boolean {
        return if (ContextCompat.checkSelfPermission(
                activity,
                Manifest.permission.RECORD_AUDIO
            ) == PackageManager.PERMISSION_GRANTED
        ) {
            true
        } else {
            suspendCancellableCoroutine { cont ->
                continuation = cont
                requestPermissionLauncher.launch(Manifest.permission.RECORD_AUDIO)
            }
        }
    }
}