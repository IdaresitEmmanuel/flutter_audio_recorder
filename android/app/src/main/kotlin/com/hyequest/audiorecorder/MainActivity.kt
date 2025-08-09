package com.hyequest.audiorecorder

import com.hyequest.audiorecorder.data.AudioRecorder
import com.hyequest.audiorecorder.data.HyeFlutterMethodHandler
import com.hyequest.audiorecorder.data.PermissionManager
import com.hyequest.audiorecorder.data.WaveformEventStreamHandler
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val permissionManager = PermissionManager(this)
        val waveformEventStreamHandler = WaveformEventStreamHandler()
        val audioRecorder = AudioRecorder(permissionManager, waveformEventStreamHandler)

        val methodChannel =
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.hyequest.audiorecorder.methodchannel")
        methodChannel.setMethodCallHandler(HyeFlutterMethodHandler(audioRecorder))

        val connectionChannel = EventChannel(flutterEngine.dartExecutor.binaryMessenger, "com.hyequest.audiorecorder.waveform_eventchannel")
        connectionChannel.setStreamHandler(waveformEventStreamHandler)
    }
}