package com.hyequest.audiorecorder.data.audiorecorder

import android.annotation.SuppressLint
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import android.media.AudioFormat
import android.media.AudioRecord
import android.media.MediaRecorder
import com.hyequest.audiorecorder.data.PermissionManager
import java.util.Timer
import java.util.TimerTask

class AudioRecorder(
    private val permissionManager: PermissionManager,
    private val recorderWaveformEventStreamHandler: RecorderWaveformEventStreamHandler,
    private val recorderStatusEventStreamHandler: RecorderStatusEventStreamHandler
) {

    private var audioRecord: AudioRecord? = null
    private var isRecording = false
    private var bufferSize = 0

    private var recordDuration = 0.0 //  milliseconds

    private var timer: Timer? = null

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
        recordDuration = 0.0

        startTimer()
        startReading()
    }

    fun pause() {
        audioRecord?.stop()
        isRecording = false
        sendStatus()
    }

    suspend fun resume() {
        audioRecord?.startRecording()
        isRecording = true
        startReading()
        sendStatus()
    }

    fun stop() {
        isRecording = false
        audioRecord?.stop()
        audioRecord?.release()
        audioRecord = null
        recordDuration = 0.0
        sendStatus()
    }

    private fun startTimer() {
        stopTimer()
        timer = Timer()
        timer?.schedule(object : TimerTask() {
            override fun run() {
                if (isRecording) {
                    recordDuration += 100.0 // increase by 100 ms per tick
                    sendStatus()
                }
            }
        }, 0L, 100L) // delay=0, period=100ms
    }

    private fun stopTimer() {
        timer?.cancel()
        timer = null
    }

    private suspend fun startReading() {
        // Launch in background
        withContext(Dispatchers.IO) {
            val buffer = ShortArray(bufferSize)
            while (isRecording) {
                val read = audioRecord?.read(buffer, 0, buffer.size) ?: 0
                if (read > 0) {
                    val normalized = buffer.take(read).map { it.toDouble() / Short.MAX_VALUE }
                    val model = RecordWaveformModel(timestamp = recordDuration, data = normalized)
                    recorderWaveformEventStreamHandler.send(model.toMap())
                }
            }
        }
    }

    private fun sendStatus(){
        val model = RecordStatusModel(isRecording = isRecording, recordDuration = recordDuration)
        recorderStatusEventStreamHandler.send(model.toMap())
    }

    sealed class RecorderError(message: String) : Exception(message) {
        data object MissingMicrophonePermission :
            RecorderError("Microphone permission is not granted") {
            private fun readResolve(): Any = MissingMicrophonePermission
        }
    }
}
