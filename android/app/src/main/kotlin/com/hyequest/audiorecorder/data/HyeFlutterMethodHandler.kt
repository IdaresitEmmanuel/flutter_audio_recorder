package com.hyequest.audiorecorder.data

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch

class HyeFlutterMethodHandler(private val audioRecorder: AudioRecorder) : MethodChannel.MethodCallHandler {
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {

        when(call.method){
            "startRecorder" -> {
                val scope = CoroutineScope(Job() + Dispatchers.Main)
                scope.launch {
                    try {
                        audioRecorder.start()
                        result.success(true)
                    } catch (e: AudioRecorder.RecorderError.MissingMicrophonePermission) {
                        // Handle permission error
                        result.error("MISSING_PERMISSION_ERROR", "Microphone permission denied", e)
                    }catch (e: Exception) {
                        result.error("RECORDER_START_ERROR", e.message, e)
                    }
                }

            }
            "pauseRecorder" -> {

                try {
                    audioRecorder.pause()
                    result.success(true)
                } catch (e: Exception) {
                    println("RECORD_PAUSE_ERROR")
                    println(e)
                    result.error("RECORD_PAUSE_ERROR", "Unable to pause recorder", null)
                }
            }
            "resumeRecorder" -> {

                try {
                    audioRecorder.resume()
                    result.success(true)
                } catch (e: IllegalStateException) {
                    println(e)
                    result.error("RECORDER_RESUME_ERROR", "Unable to resume recorder", null)
                }

            }
            "stopRecorder" -> {

                try {
                   audioRecorder.stop()
                    result.success(true)
                } catch (e: Exception) {
                    println(e)
                    result.error("RECORDER_STOP_ERROR", "Unable to stop recorder", null)
                }
            }
            else -> {
               result.notImplemented()
            }
        }
    }

}