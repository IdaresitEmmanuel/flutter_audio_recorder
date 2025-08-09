package com.hyequest.audiorecorder.data

import android.annotation.SuppressLint
import android.media.*
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

class AudioRecorder (private val permissionManager: PermissionManager, private val waveformEventStreamHandler:  WaveformEventStreamHandler) {

    private var audioRecord: AudioRecord? = null
    private var isRecording = false
    private var bufferSize = 0

    @SuppressLint("MissingPermission")
    suspend fun start() {
        val hasPermission = permissionManager.requestAudioPermission()
        if (!hasPermission) {
            throw RecorderError.MissingMicrophonePermission
        }

        bufferSize = AudioRecord.getMinBufferSize(
            44100,
            AudioFormat.CHANNEL_IN_MONO,
            AudioFormat.ENCODING_PCM_16BIT
        )

        audioRecord = AudioRecord(
            MediaRecorder.AudioSource.MIC,
            44100,
            AudioFormat.CHANNEL_IN_MONO,
            AudioFormat.ENCODING_PCM_16BIT,
            bufferSize
        )

        audioRecord?.startRecording()
        isRecording = true

        // Launch in background
        withContext(Dispatchers.IO) {
            val buffer = ShortArray(bufferSize)
            while (isRecording) {
                val read = audioRecord?.read(buffer, 0, buffer.size) ?: 0
                if (read > 0) {
                    val normalized = buffer.take(read).map { it.toDouble() / Short.MAX_VALUE }
                    waveformEventStreamHandler.send(normalized)
                }
            }
        }
    }

    fun pause() {
        audioRecord?.stop()
        isRecording = false
    }

    fun resume() {
        audioRecord?.startRecording()
        isRecording = true
    }

    fun stop() {
        isRecording = false
        audioRecord?.stop()
        audioRecord?.release()
        audioRecord = null
    }

    sealed class RecorderError(message: String) : Exception(message) {
        object MissingMicrophonePermission :
            RecorderError("Microphone permission is not granted") {
            private fun readResolve(): Any = MissingMicrophonePermission
        }
    }
}
