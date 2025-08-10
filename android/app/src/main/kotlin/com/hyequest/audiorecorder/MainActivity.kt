package com.hyequest.audiorecorder

import com.hyequest.audiorecorder.data.audiorecorder.AudioRecorder
import com.hyequest.audiorecorder.data.HyeFlutterMethodHandler
import com.hyequest.audiorecorder.data.PermissionManager
import com.hyequest.audiorecorder.data.audiorecorder.RecorderStatusEventStreamHandler
import com.hyequest.audiorecorder.data.audiorecorder.RecorderWaveformEventStreamHandler
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val permissionManager = PermissionManager(this)
        val recorderWaveformEventStreamHandler = RecorderWaveformEventStreamHandler()
        val recorderStatusEventStreamHandler = RecorderStatusEventStreamHandler()
        val audioRecorder = AudioRecorder(permissionManager, recorderWaveformEventStreamHandler,recorderStatusEventStreamHandler)

        val methodChannel =
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.hyequest.audiorecorder.methodchannel")
        methodChannel.setMethodCallHandler(HyeFlutterMethodHandler(audioRecorder))

        val recordWaveformChannel = EventChannel(flutterEngine.dartExecutor.binaryMessenger, "com.hyequest.audiorecorder.recorder_waveform_eventchannel")
        recordWaveformChannel.setStreamHandler(recorderWaveformEventStreamHandler)

        val recordStatusChannel = EventChannel(flutterEngine.dartExecutor.binaryMessenger, "com.hyequest.audiorecorder.recorder_status_eventchannel")
        recordStatusChannel.setStreamHandler(recorderStatusEventStreamHandler)
    }
}