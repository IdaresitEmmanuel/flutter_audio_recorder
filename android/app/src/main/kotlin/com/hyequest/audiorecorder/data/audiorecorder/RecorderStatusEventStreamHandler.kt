package com.hyequest.audiorecorder.data.audiorecorder

import io.flutter.plugin.common.EventChannel

class RecorderStatusEventStreamHandler : EventChannel.StreamHandler {
    private var eventSink: EventChannel.EventSink? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    fun send(data: Any) {
        val mainHandler = android.os.Handler(android.os.Looper.getMainLooper())
        mainHandler.post {
            eventSink?.success(data)
        }
    }
}